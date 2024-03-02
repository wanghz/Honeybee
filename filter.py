import yaml
import urllib.request

def gathering_clash():
    #url = "http*//0.0.0.0:2550/sub?target=clash&url=https%3A%2F%2Fpp.dcd.one%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Frvorch.treze.cc%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Fkiwi2.cgweb.top%2Fclash%2Fproxies%3Fspeed%3D10"    
    url = "http:*//0.0.0.0:2550/sub?target=clash&url=https%3A%2F%2Fpp.dcd.one%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Frvorch.treze.cc%2Fclash%2Fproxies%3Fspeed%3D10%7Chttps%3A%2F%2Fkiwi2.cgweb.top%2Fclash%2Fproxies%3Fspeed%3D10"    
    hdr = { 'User-Agent' : 'Mozilla/5.0 (Windows NT 6.1; Win64; x64)' }
        
    req = urllib.request.Request(url, headers=hdr)
    response = urllib.request.urlopen(req)
    content = response.read().decode('utf-8')

    #源数据中有非法字符，修改一下
    data = content.replace("::", "")

    return data


# 过滤含有指定字符串的条目
def should_filter(entry):
    return any(filter_string in str(entry) for filter_string  in filter_strings)


def filter_yaml_file(filter_strings):
    data = data = yaml.safe_load(gathering_clash())

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
filter_strings = ["hysteria2", "hysteria", "trojan"]
htonly, vmess = filter_yaml_file(filter_strings)

# 将结果写回YAML文件
output_file = 'htonly.yml'
output_vmess = 'vmess.yml'
with open(output_file, 'w', encoding='utf-8') as file:
    # 写入 "proxies:" 头部
    file.write("proxies:\n")
    yaml.dump(htonly, file)
with open(output_vmess, 'w', encoding='utf-8') as file:
    # 写入 "proxies:" 头部
    file.write("proxies:\n")
    yaml.dump(vmess, file)
    
