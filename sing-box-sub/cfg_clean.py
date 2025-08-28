import json
import re
import sys
import geoip2.database
import ipaddress
import socket
from typing import Tuple, Optional
import numbers

class GeoIPChecker:
    def __init__(self, db_path: str):
        """初始化 GeoIPChecker，加载数据库一次"""
        self.reader = geoip2.database.Reader(db_path)
        self.cache = {}  # 可选：缓存查询结果

    def is_iran_ip(self, ip_address: str) -> bool:
        """检查单个 IP 是否属于伊朗"""
        try:
            if ip_address in self.cache:
                return self.cache[ip_address]
            response = self.reader.country(ip_address)
            is_iran = response.country.iso_code == 'IR'
            self.cache[ip_address] = is_iran
            return is_iran
        except Exception as e:
            #print(f"Error for IP {ip_address}: {e}")
            return False

    def check_ip(self, ip_address: str) -> Tuple[str, bool]:
        """检查单个 IP，返回 (IP, 是否伊朗) 的结果"""
        return (ip_address, self.is_iran_ip(ip_address))

    def resolve_domain(self, domain: str) -> Optional[str]:
        """解析域名到 IP 地址，返回第一个有效的 IPv4 地址"""
        try:
            ip_address = socket.gethostbyname(domain)
            return ip_address
        except socket.gaierror as e:
            #print(f"Error resolving domain {domain}: {e}")
            return None

    def check_domain(self, domain: str) -> Tuple[str, Optional[str], bool]:
        """检查域名，返回 (域名, IP地址, 是否伊朗) 的结果"""
        ip_address = self.resolve_domain(domain)
        if ip_address:
            is_iran = self.is_iran_ip(ip_address)
            return (domain, ip_address, is_iran)
        return (domain, None, False)

    def __del__(self):
        """确保程序结束时关闭数据库"""
        self.reader.close()

def is_url_encoding_valid(encoded_str):
    # 正则表达式匹配 URL 编码格式
    pattern = re.compile(r"^(%[0-9A-Fa-f]{2}|[^%])*$")
    return bool(pattern.match(encoded_str))

# 读取JSON文件
def read_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data

# 写入JSON文件
def write_json(file_path, data):
    # 消除可能的多余的逗号
    # 转换为 JSON 字符串
    json_str = json.dumps(data, indent=4)
    # 解析回 Python 对象
    fixed_data = json.loads(json_str)    
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(fixed_data, file, ensure_ascii=False, indent=4)

def process_outbounds_method(data):
    tag_list = []
    data["outbounds"] = [outbound for outbound in data["outbounds"] if not ("method" in outbound and (outbound["method"] == "ss" or outbound["method"] == "{\"add\""))]
    for outbound in data["outbounds"]:
        if "method" in outbound and (outbound["method"] == "ss" or outbound["method"] == "{\"add\""):
            tag_list.append(outbound['tag'])

    return data, tag_list

def process_outbounds_index(data, index):
    s = data["outbounds"][index]['tag']
    data["outbounds"] = [outbound for outbound in data["outbounds"] if not (outbound["tag"] == s)]
    print(index, "removed")
    print("Wrong proxy:", s)
    return data
        
def process_outbounds(data, token):
    for outbound in data["outbounds"]:
        if "outbounds" in outbound and len(outbound["outbounds"]) > 5 and isinstance(outbound["outbounds"], list):
            try:
                outbound["outbounds"] = [x for x in outbound["outbounds"] if token not in x]
                print("消除了 ", token)
                if outbound["outbounds"][-1].endswith(","):
                    outbound["outbounds"][-1] = outbound["outbounds"][-1].rstrip(",")            
            except:
                pass
    
        if token in outbound["tag"]:
            data["outbounds"].remove(outbound)
            
    return data

def name_too_long(data):
    # 创建一个新的列表来存储有效的 outbounds
    valid_outbounds = []
    for outbound in data["outbounds"]:
        # 检查 outbound 是否包含 "outbounds" 并且是一个列表
        if "outbounds" in outbound and isinstance(outbound["outbounds"], list):
            # 过滤掉长度大于 150 的项目
            outbound["outbounds"] = [x for x in outbound["outbounds"] if len(x) <= 150]
            # 如果最后一个元素以逗号结尾，去掉逗号
            if outbound["outbounds"] and outbound["outbounds"][-1].endswith(","):
                outbound["outbounds"][-1] = outbound["outbounds"][-1].rstrip(",")
        
        # 检查 tag 是否存在并且长度是否大于 150
        if "tag" in outbound and len(outbound["tag"]) > 150:
            print('Removing- ', outbound["tag"])
            data["outbounds"].remove(outbound)
    
    return data

def one_by_one(data):
    # 确定固定的 valid_tags
    invalid_types = ["direct", "auto", "selector", "block", "dns","urltest"]
    valid_types = ["trojan", "shadowsocks", "trojan", "ws", "socks","vmess","vless","hysteria","hysteria2"]

    #去重。 将字典序列化为字符串
    str_list = [json.dumps(d, sort_keys=True) for d in data["outbounds"]]
    unique_strs = list(dict.fromkeys(str_list))
    # 将字符串反序列化为字典
    data["outbounds"] = [json.loads(s) for s in unique_strs]
    # 删除 method 不对的代理
    data["outbounds"] = [item for item in data["outbounds"] if not ("method" in item and 'add"' in item.get("method"))]
    data["outbounds"] = [item for item in data["outbounds"] if not ("method" in item and  item.get("method") == "ss")]
    data["outbounds"] = [item for item in data["outbounds"] if not ("plugin" in item and 'obfs"' in item.get("plugin"))]
    data["outbounds"] = [item for item in data["outbounds"] if not ('tls' in item and 'reality' in item['tls'] and 'public_key' in item['tls']['reality'] and 'public_key' != None)] 
    # 过滤 outbounds 错误的path
    data["outbounds"] = [
        item for item in data["outbounds"]
        if not ("transport" in item and 'path' in item["transport"] and item["transport"].get("type") == 'ws' and not is_url_encoding_valid(item["transport"].get('path')))
    ]
    
    # 合并这两个列表，获取需要保留的 tag 集合
    required_tags = []
    for outbound in data.get("outbounds", []):  # 提供默认值以防止缺失
        tag = outbound.get("tag")
        if (
            "server" in outbound 
            and outbound.get("type").lower() in valid_types 
            and isinstance(tag, str)  # 确保 tag 是字符串
            and len(tag) <= 200
        ):
            required_tags.append(tag)

    # 更新 "🌏 !cn" 和 "auto" 的 outbounds 列表，移除不存在的 tag
    data["outbounds"][1]["outbounds"] = [tag for tag in required_tags]
    data["outbounds"][2]["outbounds"] = [tag for tag in required_tags]

    return data
    

def process_domain(domain: str, checker: GeoIPChecker) -> bool:
    """另一个函数，调用 checker.check_domain 处理域名"""
    domain, ip_address, is_iran = checker.check_domain(domain)
    if is_iran:
        pass
        #print(f"Domain {domain} resolved to IP {ip_address}: {'Iran' if is_iran else 'Not Iran'}")
    else:
        #print(f"Domain {domain}: Failed to resolve IP")
        pass
    return is_iran


def process_outbounds_server_ip(data):
    tag_list = []
    server_list = []
    for outbound in data["outbounds"]:
        if "server" in outbound:
            try:
                ipaddress.ip_address(outbound['server'])
                ip, special_ip = checker.check_ip(outbound['server'])
                if special_ip:
                    print(outbound['server'], "Special ip, skip")
                    tag_list.append(outbound['tag'])
                    server_list.append(outbound)                

            except ValueError:
                try:
                    # 调用 process_domain 函数
                    special_ip = process_domain(outbound['server'], checker)
                    #print(outbound['server'])
                    if special_ip:
                        print(outbound['server'], "Special ip, skip")
                        tag_list.append(outbound['tag'])
                        server_list.append(outbound)
                        #data["outbounds"].remove(outbound)
                except ValueError:
                    pass  # 不是IP，继续判断域名

    Methods = ["aes-128-gcm",
                "aes-192-gcm",
                "aes-256-gcm",
                "chacha20-ietf-poly1305",
                "xchacha20-ietf-poly1305",
                "aes-128-ctr",
                "aes-192-ctr",
                "aes-256-ctr",
                "aes-128-cfb",
                "aes-192-cfb",
                "aes-256-cfb",
                "rc4-md5",
                "chacha20-ietf",
                "2022-blake3-aes-128-gcm",
                "2022-blake3-aes-256-gcm",
                "2022-blake3-chacha20-poly1305"]

    for outbound in data["outbounds"]:
        if "tls" in outbound and "reality" in outbound["tls"]:
            try:
                if outbound["tls"]["reality"]["public_key"] == None:
                    tag_list.append(outbound['tag'])
                    server_list.append(outbound)
                    print("public_key invalid")
            except ValueError:
                pass          
                                       
        if "transport" in outbound and "path" in outbound["transport"]:
            try:
                if len(outbound["transport"]["path"]) >0 and outbound["transport"]["path"][0] == "%":
                    tag_list.append(outbound['tag'])
                    server_list.append(outbound)
                    print("tls transport path error")
            except ValueError:
                pass 

        if "method" in outbound:
            if outbound["method"] not in Methods:
                tag_list.append(outbound['tag'])
                server_list.append(outbound)
                print("invalid method", outbound["tag"],outbound["method"])


        if "password" in outbound:
            if len(outbound["password"]) == 44 or len(outbound["password"]) > 64:
                tag_list.append(outbound['tag'])
                server_list.append(outbound)
                print("password too long", outbound["tag"],outbound["password"])
        
            
    data["outbounds"] = [item for item in data["outbounds"] if item not in server_list]

    #data["outbounds"][1]["outbounds"] = [item for item in data["outbounds"][1]["outbounds"] if item not in tag_list]  
    #data["outbounds"][2]["outbounds"] = [item for item in data["outbounds"][2]["outbounds"] if item not in tag_list]  
    for item in data["outbounds"]:
        if "tag" in item and item["tag"] in ["🌏auto", "🌏 !Choose"]:
            item["outbounds"] = [item for item in item["outbounds"] if item not in tag_list]
    #print(tag_list)
        
    return data, len(tag_list)

def remove_duplicates_from_outbound_lists(data):
    # Collect all valid tags that have 'server'
    valid_tags = {ob['tag'] for ob in data.get("outbounds", []) if "server" in ob}
    
    for outbound in data.get("outbounds", []):
        if "tag" in outbound and outbound["tag"] in ["🌏 !Choose", "🌏auto"]:
            if "outbounds" in outbound and isinstance(outbound["outbounds"], list):
                # Remove duplicates while preserving order, and filter only existing valid tags
                unique_outbounds = []
                seen = set()
                for tag in outbound["outbounds"]:
                    if tag not in seen and tag in valid_tags:
                        unique_outbounds.append(tag)
                        seen.add(tag)
                outbound["outbounds"] = unique_outbounds
    return data

if __name__ == "__main__":
    # 检查命令行参数数量
    # Check if the correct number of arguments is provided (script name + 3 arguments)
    if len(sys.argv) != 4:
        print("用法: python script.py <文件名> <字符串> <数字>")
        sys.exit(1)
    
    # Get command-line arguments
    file_path = sys.argv[1]
    token = sys.argv[2]
        
    # 读取JSON文件
    data = read_json(file_path)
    print("读取的JSON数据:", file_path)
    data = remove_duplicates_from_outbound_lists(data)
    data = one_by_one(data)   #确保tag匹配
    # 初始化 GeoIPChecker
    checker = GeoIPChecker('/home/runner/work/Honeybee/Honeybee/sing-box-sub/GeoLite2-Country.mmdb')
    new_data, howmany = process_outbounds_server_ip(data)
        
    if token == 'method':
        # 先把method不对的去掉，要把相关tag的代理都去掉
        new_data, tag_list = process_outbounds_method(new_data)         
        for tag in tag_list:
            new_data = process_outbounds(new_data, tag)
    elif token == "index":
        # Validate and convert the number argument
        try:
            number = int(sys.argv[3])
            if number not in (None, ''):
                if isinstance(number, numbers.Number):
                    new_data = process_outbounds_index(new_data, number)
        except ValueError:
            print(f"错误: 第三个参数 '{sys.argv[3]}' index 不存在")
            #sys.exit(1)
            pass        

    elif token == "check":
        pass
    else: 
        new_data = process_outbounds(new_data, token)


    # 写入JSON文件
    write_json(file_path, new_data)
    print("数据已写入",file_path)
