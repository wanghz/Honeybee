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

echo get subscribe sucessfully
echo hope you have a good day~
echo bye~
