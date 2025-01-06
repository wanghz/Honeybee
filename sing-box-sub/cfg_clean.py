import json
import re
import sys

# 读取JSON文件
def read_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data

# 写入JSON文件
def write_json(file_path, data):
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=4)

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


def one_by_one(data):
    # 确定固定的 valid_tags
    valid_tags = ["🌏 !cn", "auto", "block", "dns-out", "proxy"]

    # 提取两个关键的 outbounds 列表
    cn_outbounds = data["outbounds"][1]["outbounds"]
    auto_outbounds = data["outbounds"][2]["outbounds"]

    # 合并这两个列表，获取需要保留的 tag 集合
    required_tags = set(cn_outbounds + auto_outbounds)

    # 过滤字典：保持 valid_tags 原样，其他字典的 tag 必须与 required_tags 匹配
    filtered_outbounds = [
        outbound for outbound in data["outbounds"]
        if outbound["tag"] in valid_tags or outbound["tag"] in required_tags
    ]

    # 更新 "🌏 !cn" 和 "auto" 的 outbounds 列表，移除不存在的 tag
    existing_tags = {item["tag"] for item in filtered_outbounds}
    data["outbounds"][1]["outbounds"] = [tag for tag in cn_outbounds if tag in existing_tags]
    data["outbounds"][2]["outbounds"] = [tag for tag in auto_outbounds if tag in existing_tags]

    return data


if __name__ == "__main__":
    # 检查命令行参数数量
    if len(sys.argv) <= 3:
        print("用法: python script.py <文件名> <字符串>")
    else:
        #pass
        # 获取命令行参数
        file_path = sys.argv[1]
        token = sys.argv[2]
        number = int(sys.argv[3])

    # 读取JSON文件
    data = read_json(file_path)
    print("读取的JSON数据:", file_path)

    data = one_by_one(data)   #确保tag匹配
    
    if token == 'method':
        # 先把method不对的去掉，要把相关tag的代理都去掉
        new_data, tag_list = process_outbounds_method(data)         
        for tag in tag_list:
                new_data = process_outbounds(new_data, tag)
    elif token == "index":
        new_data = process_outbounds_index(data, number)
    else: 
        new_data = process_outbounds(data, token)
    
    # 写入JSON文件
    write_json(file_path, new_data)
    print("数据已写入",file_path)
