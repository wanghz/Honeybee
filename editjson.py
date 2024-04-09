import json


def load_json_with_comments(file_path):
    with open(file_path, 'r',encoding='utf-8') as f:
        lines = f.readlines()

    # 过滤掉以双斜杠开头的注释行
    lines = [line for line in lines if not line.strip().startswith('//')]

    # 合并剩余的行为一个字符串，并解析为 JSON 对象
    data = json.loads(''.join(lines))
    return data

#---Main---
# 下载的配置json有两项不适合，一是本地dns服务器地址，二是入口端口，在这里修改一下
# 使用自定义加载函数读取 JSON 文件
data = load_json_with_comments('m.json')

dns = data['dns']

# 替换本地dns服务器
dns['servers'][1]['address'] = "tcp://233.5.5.5"

# 删除 "inbounds" 中的前两项，修改端口
data['inbounds'] = data['inbounds'][-1:]
data['inbounds'][0]['listen_port'] = "7890"

print(dns['servers'][1]['address'], '\n***')
print(data['inbounds'])

# 写回到文件中
with open('m.json', 'w',encoding="utf-8") as file:
    json.dump(data, file, indent=4)
