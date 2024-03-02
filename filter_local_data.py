import yaml
from yaml.constructor import ConstructorError
import re 

yaml.add_multi_constructor('str', lambda loader, suffix, node: None)

# 要过滤的字符串列表
filter_strings = ["hysteria2", "trojan","hysteria"]

def verify_clash(input_file):
    # 打开文本文件以只读模式
    with open(input_file, 'r',encoding='utf-8') as file:
        # 逐行读取文件内容
        data = file.read()

    #源数据中有非法字符，修改一下,否则load yaml报错。有两种非法字符：1. :: ；2. !<str> 
    #1. 去掉::
    data = data.replace("::", "")

    # 按行分割字符串
    lines = data.splitlines()

    #2. 去掉 !<str>
    print(len(lines))
    # 定义正则表达式模式
    pattern = re.compile(r'password:\s+!<str>')

    filtered_lines = []
    # 处理字符串列表
    for line in lines:
        # 检查是否包含模式
        if not pattern.search(line):
            # 如果不包含，则处理该行
            filtered_lines.append(line)
        else:
            print("发现错误行---")
            print(line)
    
    # 过滤非法字符完毕，组装回去
    # 使用换行符连接列表元素
    my_string = '\n'.join(filtered_lines)

    # 打开文本文件以写入模式
    with open('111.yaml', 'w',encoding='utf-8') as file:
        # 将内容写入文件
        file.write(my_string)

    return my_string


# 过滤含有指定字符串的条目
def should_filter(entry):
    return any(filter_string in str(entry) for filter_string  in filter_strings)


def filter_yaml_file(clash, output_file):
    # 读取YAML文件
    try:
        data = yaml.safe_load(clash)
    except yaml.YAMLError as e:
        # 处理 YAMLError 异常
        print(f"Error loading YAML with safe_load: {e}")


    print("读入clash yaml数据")
    # 使用列表推导式过滤出满足条件的项目
    filtered_data = [item for item in data['proxies'] if item.get('type') in filter_strings]
    vmess = [item for item in data['proxies'] if item.get('type') == 'vmess']

    # 打印过滤后的结果
    print(len(filtered_data), " 个代理")
    print(len(vmess), " 个vmess")

    # 将结果写回YAML文件
    with open(output_file, 'w') as file:
        # 写入 "proxies:" 头部
        file.write("proxies:\n")
        yaml.dump(filtered_data, file)
    with open(output_vmess, 'w') as file:
        # 写入 "proxies:" 头部
        file.write("proxies:\n")
        yaml.dump(vmess, file)

    print("完成。")
        
# 示例用法
path = "/Users/wangjiaozhu/download/"
input_file = path + 'clash-1.yaml'
output_file = path + 'clash-1-ht.yml'
output_vmess = path + 'clash-1-v.yml'
clash = verify_clash(input_file)
filter_yaml_file(clash, output_file)

