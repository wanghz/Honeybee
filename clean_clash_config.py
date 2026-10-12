#!/usr/bin/env python3
"""
Clash 配置清理工具：移除包含控制字符的代理及其在代理组中的引用。

用法:
    python clean_clash_config.py input.yaml output.yaml
    python clean_clash_config.py input.yaml  # 就地修改，备份为 input.yaml.bak
"""

import sys
import re
import yaml
import argparse
from pathlib import Path
from typing import Any, Dict, List, Set, Optional


CONTROL_CHAR_PATTERN = re.compile(r'[\x00-\x1f\x7f-\x9f]')


def has_control_chars(text: str) -> bool:
    """检查字符串是否包含控制字符。"""
    return bool(CONTROL_CHAR_PATTERN.search(text))


def find_proxies_with_control_chars(proxies: List[Dict[str, Any]]) -> Set[str]:
    """
    找出包含控制字符的代理名称。
    检查代理的所有字符串字段。
    """
    bad_names: Set[str] = set()
    for proxy in proxies:
        name = proxy.get('name')
        if not name:
            continue
        # 检查代理对象中所有字符串值
        def check_value(val: Any) -> bool:
            if isinstance(val, str):
                return has_control_chars(val)
            if isinstance(val, dict):
                return any(check_value(v) for v in val.values())
            if isinstance(val, list):
                return any(check_value(v) for v in val)
            return False

        if check_value(proxy):
            bad_names.add(name)
    return bad_names


def filter_proxy_groups(proxy_groups: List[Dict[str, Any]], bad_names: Set[str]) -> List[Dict[str, Any]]:
    """
    过滤代理组：
    1. 从 proxies 列表中移除坏的代理名
    2. 如果代理组的 proxies 变空，移除整个代理组
    """
    cleaned_groups = []
    for group in proxy_groups:
        proxies = group.get('proxies', [])
        if not isinstance(proxies, list):
            cleaned_groups.append(group)
            continue

        filtered = [p for p in proxies if p not in bad_names]
        if filtered:
            new_group = group.copy()
            new_group['proxies'] = filtered
            cleaned_groups.append(new_group)
        # 如果 filtered 为空，丢弃该代理组
    return cleaned_groups


def clean_clash_config(input_path: Path, output_path: Optional[Path] = None, inplace: bool = False) -> Dict[str, Any]:
    """
    清理 Clash 配置文件。
    返回清理后的配置字典。
    """
    with input_path.open('r', encoding='utf-8') as f:
        content = f.read()

    # 先尝试用 yaml 安全加载
    try:
        config = yaml.safe_load(content)
    except yaml.YAMLError as e:
        print(f"YAML 解析错误: {e}", file=sys.stderr)
        # 尝试宽松加载
        config = yaml.load(content, Loader=yaml.FullLoader)

    if not config:
        print("配置为空", file=sys.stderr)
        return {}

    proxies = config.get('proxies', [])
    proxy_groups = config.get('proxy-groups', config.get('proxies_group', []))

    if not proxies:
        print("未找到 proxies 段", file=sys.stderr)
        return config

    # 找出有控制字符的代理
    bad_names = find_proxies_with_control_chars(proxies)
    print(f"发现 {len(bad_names)} 个包含控制字符的代理: {sorted(bad_names)}")

    # 过滤 proxies
    clean_proxies = [p for p in proxies if p.get('name') not in bad_names]
    print(f"proxies: {len(proxies)} -> {len(clean_proxies)}")

    # 过滤 proxy-groups
    clean_groups = filter_proxy_groups(proxy_groups, bad_names)
    print(f"proxy-groups: {len(proxy_groups)} -> {len(clean_groups)}")

    # 构建新配置
    new_config = config.copy()
    new_config['proxies'] = clean_proxies
    # 保持原 key 名称
    if 'proxy-groups' in config:
        new_config['proxy-groups'] = clean_groups
    elif 'proxies_group' in config:
        new_config['proxies_group'] = clean_groups

    # 写入输出
    out_path = output_path or (input_path if inplace else input_path.with_suffix('.clean.yaml'))
    if inplace:
        backup_path = input_path.with_suffix(input_path.suffix + '.bak')
        input_path.rename(backup_path)
        print(f"已备份原文件到: {backup_path}")

    with out_path.open('w', encoding='utf-8') as f:
        yaml.dump(new_config, f, allow_unicode=True, sort_keys=False, default_flow_style=False)

    print(f"已写入: {out_path}")
    return new_config


def main():
    parser = argparse.ArgumentParser(description='清理 Clash 配置中的控制字符代理')
    parser.add_argument('input', help='输入 YAML 文件路径')
    parser.add_argument('output', nargs='?', help='输出 YAML 文件路径（可选，默认就地修改并备份）')
    parser.add_argument('--inplace', '-i', action='store_true', help='就地修改输入文件（会创建 .bak 备份）')
    args = parser.parse_args()

    input_path = Path(args.input)
    if not input_path.exists():
        print(f"文件不存在: {input_path}", file=sys.stderr)
        sys.exit(1)

    output_path = Path(args.output) if args.output else None
    clean_clash_config(input_path, output_path, args.inplace)


if __name__ == '__main__':
    main()
