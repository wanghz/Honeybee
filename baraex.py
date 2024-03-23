from urllib import parse
import json
import requests
import re
import yaml
import ssl
import argparse
ssl._create_default_https_context = ssl._create_unverified_context
from urllib3.exceptions import InsecureRequestWarning
from urllib3 import disable_warnings
disable_warnings(InsecureRequestWarning)

def contains_chacha(dict):
    return "chacha" not in dict.get("cipher", "")

def download_proxy_file(url):
	# 替换为您想要获取内容的网页链接
	#url = "https://raw.githubusercontent.com/Barabama/FreeNodes/master/nodes/merged.txt"

	# 设置代理
	proxies = {
	    'http': 'http://127.0.0.1:7890',
	    'https': 'http://127.0.0.1:7890'
	}
	# 发送GET请求获取网页内容
	response = requests.get(url, verify=False)

	# 检查请求是否成功
	if response.status_code == 200:
	    # 获取网页内容
	    webpage_content = response.text

	    # 将文本内容按行分割
	    lines = webpage_content.split('\n')

	    # 选择不含"less"的行
	    #filtered_lines = [line for line in lines if "vless" not in line]

	    # 打印结果
	    #for line in filtered_lines:
	    #    print(len(line))
	else:
	    print(f"Failed to retrieve the webpage. Status cod: {response.status_code}")

	return lines


def verify_text(text):
    #源数据中有非法字符，修改一下,否则load yaml报错。有两种非法字符：1. :: ；2. !<str> 
    #1. 去掉::
    data = text.replace("::", "")

    # 按行分割字符串
    lines = data.splitlines()

    #2. 去掉 !<str>
    #print(len(lines))
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
    #with open('verified.yaml', 'w', encoding='utf-8') as file:
        # 将内容写入文件
        #file.write(my_string)

    return my_string


def write_to_file(filename, proxies):
	try:
		with open(filename, "w", encoding='utf-8') as file:
			file.write('proxies:\n')
			for proxy in proxies:
				file.write('  - ' + str(proxy) + '\n')
			print(f"{filename}\t{len(proxies)}\t成功。\n")
	except OSError as e:
		if e.errno == 22:
			print("写文件不成功.")


def process_url(url, filename):
	try:
		print(url)
		filtered_lines = download_proxy_file(url)
		print(f"代理服务器数量：\t{len(filtered_lines)}")

		proxies_str = '|'.join(filtered_lines)
		urlencode_str = parse.quote(proxies_str, safe="")

		convert_url = f"http://127.0.0.1:2550/sub?target=clash&url={urlencode_str}"
		response = requests.get(convert_url)
		yaml_data = response.text
		verified_data = verify_text(yaml_data)

		parsed_yaml = yaml.load(verified_data, Loader=yaml.FullLoader)

		# 提取proxies部分
		proxies = parsed_yaml.get('proxies')
		print(f"转换后服务器数量：\t{len(proxies)}")

		# 过滤掉cipher包含chacha的服务器
		#filtered_proxies = list(filter(lambda x: not contains_chacha(x), proxies))

		if proxies:
			write_to_file(filename, proxies)
		else:
			print("空内容，啥都没有。")
	except Exception as e:
		print(f"有问题，跳过。{e}")


#---Main---
#1. 下载含有代理内容的文本文件

#url = "https://raw.githubusercontent.com/Barabama/FreeNodes/master/nodes/merged.txt"
link = "https://github.com/Barabama/FreeNodes/raw/master/nodes/"
urls = []

# 发送GET请求获取网页内容
sess = requests.Session()
adapter = requests.adapters.HTTPAdapter(max_retries = 20)
sess.mount('http://', adapter)
url = "https://raw.githubusercontent.com/Barabama/FreeNodes/master/config.json"
response = sess.get(url,verify=False)

# 检查请求是否成功
if response.status_code == 200:
	print("打开网页,", response.status_code)

	# Parse the JSON data
	json_data = json.loads(response.text)

	# Extract all the "name" values
	names = [value["name"] for value in json_data.values()]

	print(len(names), "个文件")
	for name in names:
		urls.append(link+name+".txt")
	urls.append(link+ "merged.txt")
else:
	print("打开网页出错,", response.status_code)
	exit(102)

num = 0 
for url in urls:
	filename = "barabama" +str(num)+ ".yml"
	process_url(url, filename)
	num += 1

