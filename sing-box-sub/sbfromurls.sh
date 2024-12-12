#!/bin/bash

# 定义两个文件的 URL
snakem982url1="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/nodelist.txt"
snakem982url2="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/proxies.txt"
local="https://raw.githubusercontent.com/wanghz/Honeybee/refs/heads/main/sing-box-sub/sub_urls.txt"

# 下载文件
curl -o snakem982url1.txt "$snakem982url1"
curl -o snakem982url2.txt "$snakem982url2"
curl -o localurl.txt "$local"
# 添加一些
echo "https://raw.gitmirror.com/Memory2314/VMesslinks/main/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml" >> localurl.txt
echo "https://raw.githubusercontent.com/Huibq/TrojanLinks/master/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/Huibq/TrojanLinks/master/links/trojan" >> localurl.txt

# 删除一些找不到的或没内容的
sed /i 's|https://raw.githubusercontent.com/yebekhe/TelegramV2rayCollector/main/sub/base64/mix|d' nodelist.txt
sed /i 's|https://raw.githubusercontent.com/Vauth/node/main/Master|d' nodelist.txt
sed /i 's|http://174.137.58.32:12580/clash/proxies|d' proxies.txt
sed /i 's|http://104.168.244.47:12580/clash/proxies|d' proxies.txt
sed /i 's|http://beetle.lander.work/clash/proxies|d' proxies.txt
sed /i 's|https://proxy.fldhhhhhh.top/clash/proxies|d' proxies.txt
sed /i 's|https://raw.gitmirror.com/Memory2314/VMesslinks/main/links/vmess|d' localurl.txt

# 初始化数组
urls=()
# 将文件内容合并到数组中
while IFS= read -r line; do
    urls+=("$line")
done < <(awk '1; ENDFILE {print ""}' snakem982url1.txt snakem982url2.txt localurl.txt)

counter=1
for url in "${urls[@]}"; do
    echo "Extracting from URL: $url"
    # curl "$url" | jq -r '.proxies[]'
    filename="./k${counter}.json"
    echo "Saving to file: $filename"
    jq --arg url "$url" --arg filename "$filename" '.subscribes[0].url = $url | .save_config_path = $filename' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done
