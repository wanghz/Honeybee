import yaml
from yaml.constructor import ConstructorError
import re 
import urllib.request

yaml.add_multi_constructor('str', lambda loader, suffix, node: None)

# 要过滤的字符串列表
filter_strings = ["hysteria2", "trojan","hysteria", "vmess"]

def gather_clash(url):
    hdr = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)' }    
    try:
        req = urllib.request.Request(url, headers=hdr)
        response = urllib.request.urlopen(req)
        content = response.read().decode('utf-8')
    except (http.client.IncompleteRead) as e:
        content = e.partial
    return content

def verify_clash(clash):
    #源数据中有非法字符，修改一下,否则load yaml报错。有两种非法字符：1. :: ；2. !<str> 
    #1. 去掉::
    data = clash.replace("::", "")

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
    with open('verified.yaml', 'w', encoding='utf-8') as file:
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
    with open(output_file, 'w', encoding='utf-8') as file:
        # 写入 "proxies:" 头部
        file.write("proxies:\n")
        yaml.dump(filtered_data, file)

    print("完成。")
        
# 示例用法
path = "./"
input_file = path + 'clash-1.yaml'
output_file = path + 'note.yml'
output_vmess = path + 'clash-1-v.yml'
url = "https://api-suc.0z.gs/sub?target=clash&url=https%3A%2F%2Fanaer.github.io%2FSub%2Fclash.yaml%7Chttps%3A%2F%2Fproxy.v2gh.com%2Fhttps%3A%2F%2Fraw.githubusercontent.com%2FPawdroid%2FFree-servers%2Fmain%2Fsub%7Chttps%3A%2F%2Fraw.githubusercontent.com%2Fermaozi01%2Ffree_clash_vpn%2Fmain%2Fsubscribe%2Fclash.yml&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FNZESupB%2FProfile%2Fmain%2Foutpref%2Fpypref%2Fpyfull.ini&filename=GitHub-GetNode&append_type=true&emoji=true&list=false&tfo=false&scv=true&fdn=false&sort=true&udp=true&new_name=true"

clash = gather_clash(url)
verified_lash = verify_clash(clash)
filter_yaml_file(verified_lash, output_file)
