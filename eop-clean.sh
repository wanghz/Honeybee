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
curl -s "https://raw.githubusercontent.com/yebekhe/TVC/main/subscriptions/singbox/mix.json" -o "./sub/mix.json"
curl -s "https://raw.githubusercontent.com/yebekhe/TelegramV2rayCollector/main/singbox/sfasfi/mixLite.json" -o "./sub/mixlite.json"
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/clash-meta/actives_under_1000ms.yaml" -o "./sub/under1k.yml"

# do some editing
cd ./sub
cp ../editjson.py .
python editjson.py  mix.json
python editjson.py  mixlite.json
cp ../sing-box-subscribe-no-flask-2.7.0/e*.json .

# cleaning
# 定义要检查和删除的文件列表
#rm -rf ./Config%20list*.txt
rm -rf vmess.txt
rm -rf reality.txt



cd ..
# end
echo get subscribe sucessfully
echo hope you have a good day~
echo bye~
