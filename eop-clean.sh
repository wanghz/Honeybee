#!/bin/bash
currentdate=$(date +%Y%m%d)  
currentmonth=$(date +%Y%m)
currentmonths=$(date +%m)
currentyears=$(date +%Y)

urls=(
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/All_Configs_Sub.txt"
  "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/refs/heads/main/protocols/tr.txt"
)

cd ./sub
# Function to download and filter text files
download_and_filter() {
    url="$1"
    filename="${url##*/}"
    # 获取文件名首字符
    first_char="${filename:0:1}"
    # 使用时间戳或随机字符串生成唯一的前缀，避免覆盖
    output_prefix="split_${first_char%.*}_$(date +%s)_"

    # Download the file
    curl -s "$url" -o "$filename"
    # Filter the file
    sed -i '/^ss:\/\/\|^vless:\/\/\|^vmess:\/\/\|^hysteria\|^trojan:\/\//!d' "$filename"
    # 分割文件，限制每块 800 行
    split -l 800 "$filename" "$output_prefix"
}

# Loop through URLs and process each one
for url in "${urls[@]}"; do
    download_and_filter "$url"
done

cd ..
# download some others
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/refs/heads/master/collected-proxies/row-url/actives.txt" -o "./sub/split_act"
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/clash-meta/actives_under_1000ms.yaml" -o "./sub/split_1k"

# do some editing
cd ./sub
cp ../editjson.py .

# cleaning
# 定义要检查和删除的文件列表
#rm -rf ./Config%20list*.txt

cd ..
# end
echo bye~
