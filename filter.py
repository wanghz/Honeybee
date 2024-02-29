import yaml

# 要过滤的字符串列表
filter_strings = ["hysteria2", "hysteria", "trojan"]

# 过滤含有指定字符串的条目
def should_filter(entry):
    return any(filter_string in str(entry) for filter_string  in filter_strings)


def filter_yaml_file(input_file):
    with open(input_file, 'r', encoding='utf-8') as file:
        content = file.read()
    data = content.replace("::", ":")

    # 使用列表推导式过滤出满足条件的项目
    filtered_data = [item for item in data['proxies'] if item.get('type') == "hysteria2" or item.get('type') == "hysteria" or item.get('type') == "trojan"]
    vmess = [item for item in data['proxies'] if item.get('type') == 'vmess']

    # 打印过滤后的结果
    print(len(filtered_data), " 个代理")
    print(len(vmess), " 个vmess")

    # 将结果写回YAML文件
    output_file = 'htonly.yml'
    output_vmess = 'vmess.yml'
    with open(output_file, 'w', encoding='utf-8') as file:
        # 写入 "proxies:" 头部
        file.write("proxies:\n")
        yaml.dump(filtered_data, file)
    with open(output_vmess, 'w', encoding='utf-8') as file:
        # 写入 "proxies:" 头部
        file.write("proxies:\n")
        yaml.dump(vmess, file)
        
# 示例用法
input_file = 'clash.yaml'
filter_yaml_file(input_file)
