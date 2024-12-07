#!/bin/bash

# 定义两个文件的 URL
snakem982url1="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/nodelist.txt"
snakem982url2="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/proxies.txt"

# 下载文件
curl -o snakem982url1.txt "$snakem982url1"
curl -o snakem982url2.txt "$snakem982url2"

# 初始化数组
urls=()

# 将文件内容合并到数组中
while IFS= read -r line; do
    urls+=("$line")
done < <(cat file1.txt file2.txt)

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
