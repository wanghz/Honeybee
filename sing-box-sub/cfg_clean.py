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
    data["outbounds"] = [outbound for outbound in data["outbounds"] if outbound["tag"] != s]
    print(index, "removed")
    print("Wrong proxy:", s)
    return data
        
def process_outbounds(data, token):
    # 合并遍历：先收集要移除的outbounds，然后一次过滤
    to_remove = set()
    for outbound in data["outbounds"]:
        if "outbounds" in outbound and len(outbound["outbounds"]) > 5 and isinstance(outbound["outbounds"], list):
            try:
                outbound["outbounds"] = [x for x in outbound["outbounds"] if token not in x]
                print("消除了 ", token)
                if outbound["outbounds"] and outbound["outbounds"][-1].endswith(","):
                    outbound["outbounds"][-1] = outbound["outbounds"][-1].rstrip(",")            
            except:
                pass
        
        if "tag" in outbound and token in outbound["tag"]:
            to_remove.add(id(outbound))  # 使用id来唯一标识对象，避免直接比较dict
    
    data["outbounds"] = [outbound for outbound in data["outbounds"] if id(outbound) not in to_remove]
            
    return data

def name_too_long(data):
    # 合并遍历：收集要移除的outbounds，同时处理outbounds列表
    to_remove = set()
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
            to_remove.add(id(outbound))
    
    data["outbounds"] = [outbound for outbound in data["outbounds"] if id(outbound) not in to_remove]
    return data

def one_by_one(data):
    # Define valid and invalid types as sets for faster lookup
    invalid_types = {"direct", "auto", "selector", "block", "dns", "urltest"}
    valid_types = {"trojan", "shadowsocks", "ws", "tuic", "socks", "vmess", "vless", "hysteria", "hysteria2"}

    # Deduplicate outbounds, preserving order
    str_list = [json.dumps(d, sort_keys=True) for d in data["outbounds"]]
    unique_strs = list(dict.fromkeys(str_list))
    data["outbounds"] = [json.loads(s) for s in unique_strs]

    # 合并所有过滤条件到一个遍历中
    filtered_outbounds = []
    required_tags = []
    for item in data["outbounds"]:
        if (
            ("method" in item and 'add"' in item.get("method", "")) or
            ("method" in item and item.get("method") == "ss") or
            ("plugin" in item and 'obfs"' in item.get("plugin", "")) or
            ("tls" in item and "reality" in item.get("tls", {}) and "public_key" in item["tls"].get("reality", {})) or
            ("transport" in item and "path" in item.get("transport", {}) and item["transport"].get("type") == "ws" and not is_url_encoding_valid(item["transport"].get("path")))
        ):
            continue  # 跳过无效的

        filtered_outbounds.append(item)

        # Collect required tags
        tag = item.get("tag")
        if (
            "server" in item 
            and item.get("type", "").lower() in valid_types 
            and isinstance(tag, str) 
            and len(tag) <= 200
        ):
            required_tags.append(tag)

    data["outbounds"] = filtered_outbounds

    # Update outbounds for indices 1 and 2
    if len(data["outbounds"]) > 1:
        data["outbounds"][1]["outbounds"] = required_tags[:]
    if len(data["outbounds"]) > 2:
        data["outbounds"][2]["outbounds"] = required_tags[:]

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

def process_outbounds_server_ip(data, checker):
    tag_list = []
    Methods = {
        "aes-128-gcm",
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
        "2022-blake3-chacha20-poly1305"
    }

    # 合并所有检查到一个遍历中
    to_remove_tags = set()
    for outbound in data["outbounds"]:
        remove = False

        if "server" in outbound:
            server = outbound['server']
            try:
                ipaddress.ip_address(server)
                _, special_ip = checker.check_ip(server)
                if special_ip:
                    print(server, "Special ip, skip")
                    remove = True
            except ValueError:
                try:
                    special_ip = process_domain(server, checker)
                    if special_ip:
                        print(server, "Special ip, skip")
                        remove = True
                except ValueError:
                    pass

        if not remove:
            if "tls" in outbound and "reality" in outbound["tls"]:
                try:
                    if outbound["tls"]["reality"]["public_key"] is None:
                        print("public_key invalid")
                        remove = True
                except KeyError:
                    pass          

            if "transport" in outbound and "path" in outbound["transport"]:
                try:
                    path = outbound["transport"]["path"]
                    if len(path) > 0 and path[0] == "%":
                        print("tls transport path error")
                        remove = True
                except KeyError:
                    pass 

            if "method" in outbound:
                if outbound["method"] not in Methods:
                    print("invalid method", outbound["tag"], outbound["method"])
                    remove = True

            if "password" in outbound:
                if len(outbound["password"]) == 44 or len(outbound["password"]) > 480:
                    print("password too long", outbound["tag"], outbound["password"])
                    remove = True
                    
            if "plugin" in outbound:
                if outbound["plugin"] == "v2ray-plugin":
                    print("v2ray-plugin: unknown mode")        
                    remove = True

        if remove:
            to_remove_tags.add(outbound['tag'])

    # 一次性过滤outbounds
    data["outbounds"] = [item for item in data["outbounds"] if item['tag'] not in to_remove_tags]

    # 更新selector/auto的outbounds
    for item in data["outbounds"]:
        if "tag" in item and item["tag"] in ["🌏auto", "🌏 !Choose"]:
            item["outbounds"] = [sub_tag for sub_tag in item["outbounds"] if sub_tag not in to_remove_tags]
        
    return data, len(to_remove_tags)

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

    if token == 'method':
        # 先把method不对的去掉，要把相关tag的代理都去掉
        new_data, tag_list = process_outbounds_method(data)         
        for tag in tag_list:
            new_data = process_outbounds(new_data, tag)  # 注意这里用new_data
    elif token == "index":
        # Validate and convert the number argument
        try:
            number = int(sys.argv[3])
            if number not in (None, ''):
                if isinstance(number, numbers.Number):
                    new_data = process_outbounds_index(data, number)
        except ValueError:
            print(f"错误: 第三个参数 '{sys.argv[3]}' index 不存在")
            #sys.exit(1)
            pass        
    elif token == "check":
        data = remove_duplicates_from_outbound_lists(data)
        data = one_by_one(data)   #确保tag匹配
        # 初始化 GeoIPChecker
        checker = GeoIPChecker('/home/runner/work/Honeybee/Honeybee/sing-box-sub/GeoLite2-Country.mmdb')
        new_data, howmany = process_outbounds_server_ip(data, checker)  # 传入checker
    else: 
        new_data = process_outbounds(data, token)

    # 写入JSON文件
    write_json(file_path, new_data)
    print("数据已写入",file_path)
