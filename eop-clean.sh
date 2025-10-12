#!/bin/bash
currentdate=$(date +%Y%m%d)  
currentmonth=$(date +%Y%m)
currentmonths=$(date +%m)
currentyears=$(date +%Y)

urls=(
  "https://raw.githubusercontent.com/wiki/gfpcom/free-proxy-list/lists/vless.txt"
  "https://raw.githubusercontent.com/wiki/gfpcom/free-proxy-list/lists/vmess.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vless.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vmess.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/trojan.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vless.txt"
  #"https://raw.githubusercontent.com/Epodonios/v2ray-configs/refs/heads/main/Splitted-By-Protocol/vmess.txt"
  #"https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/refs/heads/master/collected-proxies/clash-meta/all.yaml"
  #"https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/ss.txt"
  #"https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/vless.txt"
  #"https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/vmess.txt"
  #"https://raw.githubusercontent.com/gfpcom/free-proxy-list/refs/heads/main/list/trojan.txt"
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
    if ! split -l 300 "$filename" "$output_prefix"; then
        echo "Error: Failed to split file" >&2
        return 1
    fi
    echo  "$url"   "$output_prefix"
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

#wget https://github.com/ericchiang/pup/releases/download/v0.4.0/pup_v0.4.0_linux_amd64.zip
#unzip pup_v0.4.0_linux_amd64.zip
#sudo mv pup /usr/local/bin/

#rm -f pup_*.zip.*
#rm -f split_alv
# do some editing
#cd ./sub
#cp ../editjson.py .

# cleaning
# 定义要检查和删除的文件列表
#rm -rf ./Config%20list*.txt

# end
echo bye~
