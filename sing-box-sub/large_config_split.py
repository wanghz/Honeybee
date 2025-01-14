import json
import os
import sys

def split(data,slice_num=500):
    valid_types = ["trojan", "shadowsocks", "trojan", "ws", "socks","vmess","vless","hysteria","hysteria2"]

    # 提取 outbounds
    outbounds = data.get("outbounds", [])

    # 分类特殊处理的类型
    special_types = outbounds[:5]

    # 提取特殊类型的 outbounds
    special_outbounds = outbounds[:5]

    # 非特殊类型的 outbounds
    regular_outbounds = outbounds[6:]

    # 拆分 regular_outbounds，每组最多 500 个
    chunks = [regular_outbounds[i:i + slice_num] for i in range(0, len(regular_outbounds), slice_num)]

    # 创建输出目录
    output_dir = "./"
    os.makedirs(output_dir, exist_ok=True)

    # 保存拆分文件
    for i, chunk in enumerate(chunks):
        new_data = data.copy()
        new_data["outbounds"][:5] = special_outbounds   # 合并特殊类型
        new_data["outbounds"][6:] =  chunk  # 合并特殊类型

        # 合并这两个列表，获取需要保留的 tag 集合
        required_tags = []
        for outbound in new_data.get("outbounds", []):  # 提供默认值以防止缺失
            tag = outbound.get("tag")
            if (
                "server" in outbound 
                and outbound.get("type").lower() in valid_types 
                and isinstance(tag, str)  # 确保 tag 是字符串
                and len(tag) <= 200
            ):
                required_tags.append(tag)

        # 更新 "🌏 !cn" 和 "auto" 的 outbounds 列表，移除不存在的 tag
        new_data["outbounds"][1]["outbounds"] = [tag for tag in required_tags]
        new_data["outbounds"][2]["outbounds"] = [tag for tag in required_tags]

        prefix = ’s' + input_file.split(".")[-2]
        
        #output_path = os.path.join(output_dir,f"{prefix}{i + 1}.json")
        if i == 0:
            filename = input_file
        else:
            filename = f"{prefix}_{i}.json"

        write_json(filename, new_data)
    
    print(f"拆分完成，共生成 {len(chunks)} 个文件，保存在 当前 文件夹中。")

    return len(chunks)

# 写入JSON文件
def write_json(file_path, data):
    # 消除可能的多余的逗号
    # 转换为 JSON 字符串
    json_str = json.dumps(data, indent=4)
    # 解析回 Python 对象
    fixed_data = json.loads(json_str)    
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(fixed_data, file, ensure_ascii=False, indent=4)

if __name__ == "__main__":
    # 检查命令行参数数量
    if len(sys.argv) < 2:
        print("用法: python script.py <文件名> <字符串>")
    else:
        # 获取命令行参数
        input_file = sys.argv[1]
        if len(sys.argv) > 2:
            slice_num = int(sys.argv[2])

    try:
        with open(input_file, "r", encoding="utf-8") as f:
            data = json.load(f)
        print("读取的JSON数据:", input_file)

        num = split(data,slice_num)

    except:
        print("打开文件出错。")   
