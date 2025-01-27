import json
import re
import sys

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


if __name__ == "__main__":
    # 检查命令行参数数量
    if len(sys.argv) <= 3:
        print("用法: python script.py <文件名> <字符串>")
    else:
        # 获取命令行参数
        file_path = sys.argv[1]
        token = sys.argv[2]
        number = int(sys.argv[3])

    # 读取JSON文件
    data = read_json(file_path)
    print("读取的JSON数据:", file_path)

    if token == 'method':
        # 先把method不对的去掉，要把相关tag的代理都去掉
        new_data, tag_list = process_outbounds_method(data)         
        for tag in tag_list:
            new_data = process_outbounds(new_data, tag)
    elif token == "index":
        new_data = process_outbounds_index(data, number)
    elif token == "check":
        new_data = data
        pass
    else: 
        new_data = process_outbounds(data, token)

    new_data = one_by_one(new_data)   #确保tag匹配
        
    # 写入JSON文件
    write_json(file_path, new_data)
    print("数据已写入",file_path)
