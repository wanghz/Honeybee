#!/bin/bash
currentdate=$(date +%Y%m%d)  
currentmonth=$(date +%Y%m)
currentmonths=$(date +%m)
currentyears=$(date +%Y)

urls=(
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list1.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list2.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list3.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list4.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list5.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list6.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list7.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list8.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list9.txt"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/Config%20list10.txt"
)

# Function to download and filter text files
download_and_filter() {
    url="$1"
    filename="${url##*/}"

    # Download the file
    curl -s "$url" -o "$filename"

    # Filter the file
    sed -i '/^ss:\/\/\|^vless:\/\/\|^vmess:\/\/\/|^hysteria|^trojan:\/\//!d' "$filename"
}

# Loop through URLs and process each one
for url in "${urls[@]}"; do
    download_and_filter "$url"
done

# download some others
curl -s "https://raw.githubusercontent.com/yebekhe/TVC/main/subscriptions/singbox/mix.json" -o "mix.json"
curl -s "https://raw.githubusercontent.com/yebekhe/TelegramV2rayCollector/main/singbox/sfasfi/mixLite.json" -o "mixlite.json"
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/clash-meta/actives_under_1000ms.yaml" -o "under1k.yml"
curl -s "https://raw.githubusercontent.com/lagzian/SS-Collector/main/vmess.txt" -o "vmess.txt"
curl -s "https://raw.githubusercontent.com/lagzian/SS-Collector/main/reality.txt" -o "reality.txt"

# do some edit
sed -i '/"tag": "mixed-in"/,/},/!d; s/"listen_port": 2080/"listen_port": 7890/' mix.json
sed -i '/"tag": "mixed-in"/,/},/!d; s/"listen_port": 2080/"listen_port": 7890/' mixlite.json
# 替换JSON文件中的字段值
sed -i 's/"tag": "dns-direct",\s*"address": "tcp:\/\/185.228.168.9"/"tag": "dns-direct", "address": "tcp:\/\/233.5.5.5"/g' mix.json
sed -i 's/"tag": "dns-direct",\s*"address": "tcp:\/\/95.85.95.85"/"tag": "dns-direct", "address": "tcp:\/\/233.5.5.5"/g' mixlite.json

# end
echo get subscribe sucessfully
echo hope you have a good day~
echo bye~
