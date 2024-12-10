#!/bin/bash
currentdate=$(date +%Y%m%d)  
currentmonth=$(date +%Y%m)
currentmonths=$(date +%m)
currentyears=$(date +%Y)

urls=(
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/All_Configs_Sub.txt"
)

cd ./sub
# Function to download and filter text files
download_and_filter() {
    url="$1"
    filename="${url##*/}"
    output_prefix="split_"   # 分割后文件的前缀

    # Download the file
    curl -s "$url" -o "$filename"
    # Filter the file
    sed -i '/^ss:\/\/\|^vless:\/\/\|^vmess:\/\/\/|^hysteria|^trojan:\/\//!d' "$filename"
    split -l 300 "$filename" "$output_prefix"
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
rm -rf ./mix.json
rm -rf ./mixlite.json
rm -rf ./under1k.yml
rm -rf ./verified.yaml
rm -rf ./note.yml

cd ..
# end
echo get subscribe sucessfully
echo hope you have a good day~
echo bye~
