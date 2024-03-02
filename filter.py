import yaml
import re
import urllib.request

def gathering_clash():
    #url = "https://api-suc.0z.gs/sub?target=clash&url=https%3A%2F%2Fpp.dcd.one%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Frvorch.treze.cc%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Fkiwi2.cgweb.top%2Fclash%2Fproxies%3Fspeed%3D10"    
    url = "https://api-suc.0z.gs/sub?target=clash&url=https%3A%2F%2Fanaer.github.io%2FSub%2Fclash.yaml%7Chttps%3A%2F%2Fproxy.v2gh.com%2Fhttps%3A%2F%2Fraw.githubusercontent.com%2FPawdroid%2FFree-servers%2Fmain%2Fsub%7Chttps%3A%2F%2Fraw.githubusercontent.com%2Fermaozi01%2Ffree_clash_vpn%2Fmain%2Fsubscribe%2Fclash.yml&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FNZESupB%2FProfile%2Fmain%2Foutpref%2Fpypref%2Fpyfull.ini&filename=GitHub-GetNode&append_type=true&emoji=true&list=false&tfo=false&scv=true&fdn=false&sort=true&udp=true&new_name=true"
    #url = "http://0.0.0.0:2550/sub?target=clash&url=https%3A%2F%2Fpp.dcd.one%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Frvorch.treze.cc%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Fkiwi2.cgweb.top%2Fclash%2Fproxies%3Fspeed%3D10"    
    hdr = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)' }
        
    req = urllib.request.Request(url, headers=hdr)
    response = urllib.request.urlopen(req)
    content = response.read().decode('utf-8')

    #源数据中有非法字符，修改一下
    data = content.replace("::", "")

    # 定义正则表达式模式
    pattern = re.compile(r'3135771619')
    filter_string = '3135771619'

    newdata = ""
    # 处理字符串列表
    for line in data:
        # 检查是否包含模式
        #if not pattern.search(line):
        if filter_string not in line:
            # 如果不包含，则处理该行
            newdata += line
    
    return newdata


# 过滤含有指定字符串的条目
def should_filter(entry):
    return any(filter_string in str(entry) for filter_string  in filter_strings)


def filter_yaml_file(filter_strings):
    data = yaml.load(gathering_clash(), Loader=yaml.Loader)

    # 使用列表推导式过滤出满足条件的项目
    #filtered_data = [item for item in data['proxies'] if item.get('type') == "hysteria2" or item.get('type') == "hysteria" or item.get('type') == "trojan"]
    filtered_data = [item for item in data['proxies'] if item.get('type') in filter_strings]
    vmess = [item for item in data['proxies'] if item.get('type') == 'vmess']

    # 打印过滤后的结果
    print(len(filtered_data), " 个代理")
    print(len(vmess), " 个vmess")

    return  filtered_data, vmess


# Main
input_file = 'clash.yaml'

# 要过滤的字符串列表
filter_strings = ["hysteria2", "hysteria", "trojan", "vmess"]
htonly, vmess = filter_yaml_file(filter_strings)

# 将结果写回YAML文件
output_file = 'note.yml'
output_vmess = 'notevmess.yml'
with open(output_file, 'w', encoding='utf-8') as file:
    # 写入 "proxies:" 头部
    file.write("proxies:\n")
    yaml.dump(htonly, file)

    
