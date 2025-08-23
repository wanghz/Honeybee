#!/bin/bash
currentdate=$(date +%Y%m%d)  
currentmonth=$(date +%Y%m)
currentmonths=$(date +%m)
currentyears=$(date +%Y)

urls=(
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vless.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vmess.txt"
  "https://raw.githubusercontent.com/Misaka-blog/chromego_merge/refs/heads/main/sub/merged_proxies_new.yaml"
  "https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/trojan.txt"
  "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/refs/heads/main/protocols/tr.txt"
  "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/refs/heads/main/protocols/vl.txt"
  "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/refs/heads/main/protocols/vm.txt"
  "https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/ss.txt"
  "https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/vless.txt"
  "https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/vmess.txt"
  "https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/trojan.txt"
)

cd ./sub
# Function to download and filter text files
download_and_filter() {
    local url="$1"
    local filename="${url##*/}"
    local output_prefix="split_${filename:0:2}_"
    local temp_file
    temp_file=$(mktemp)

    # Download the file
    if ! curl -s "$url" -o "$filename"; then
        echo "Error: Failed to download $url" >&2
        return 1
    fi
    if [[ ! -s "$filename" ]]; then
        echo "Error: Downloaded file is empty" >&2
        return 1
    fi

    # Filter the file
    local substring="5ubscrpt10n"
    if [[ "$url" =~ $substring ]]; then
        if ! shuf -n 3000 "$filename" > "$temp_file"; then
            echo "Error: Failed to filter file" >&2
            return 1
        fi
        mv "$temp_file" "$filename"
        echo "heading file ok"
    fi

    # Filter URLs
    if ! sed '/^ss:\/\/\|^vless:\/\/\|^vmess:\/\/\|^hysteria\|^trojan:\/\//!d' "$filename" > "$temp_file"; then
        echo "Error: Failed to apply sed filter" >&2
        return 1
    fi
    mv "$temp_file" "$filename"

    # Split file
    if ! split -l 800 "$filename" "$output_prefix"; then
        echo "Error: Failed to split file" >&2
        return 1
    fi

    # Delete excess files
    local files=("$output_prefix"*)
    if [[ ${#files[@]} -gt 10 ]]; then
        for file in "${files[@]:10}"; do
            rm -f "$file"
        done
    fi
    # Clean up
    rm -f "$filename" "$temp_file"
}


# Loop through URLs and process each one
for url in "${urls[@]}"; do
    download_and_filter "$url"
done

cd ..
# download some others
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/refs/heads/master/collected-proxies/row-url/actives.txt" -o "./sub/split_act"
curl -s "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/clash-meta/actives_under_1000ms.yaml" -o "./sub/split_1k"

wget https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip
unzip pup_v0.4.0_linux_amd64.zip
sudo mv pup /usr/local/bin/

URL="https://github.com/Alvin9999/new-pac/wiki/v2ray%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
# 使用 curl 获取网页内容，并用 pup 提取指定元素
CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(22) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT" 
  echo "$CONTENT" >> ./sub/split_act
else
  echo "No content extracted" >&2
fi

CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(27) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT"  | tr -d '\n'
  echo "$CONTENT" >> ./sub/split_act
else
  echo "No content extracted" >&2
fi

URL="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(25) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT" 
  echo "$CONTENT" >> ./sub/split_act
else
  echo "No content extracted" >&2
fi
rm -f pup_*.zip.*
rm -f split_alv
# do some editing
cd ./sub
cp ../editjson.py .

# cleaning
# 定义要检查和删除的文件列表
#rm -rf ./Config%20list*.txt

cd ..
# end
echo bye~
