#!/bin/bash
all_files=(
        "htonly.yml"
)

# 添加find找到的文件到数组
while IFS= read -r file; do
    all_files+=("$file")
done < <(find /home/runner/work/Honeybee/Honeybee/sub -type f -mmin -60 -name "split*" -printf "%f\n")


counter=1
for file in "${all_files[@]}"; do
    # 在这里添加您的提取逻辑
    localfile="https://raw.githubusercontent.com/wanghz/Honeybee/main/sub/$file"
    echo "Extracting from local file: $localfile"
    filename="./f${counter}.json"
    echo "Saving to file: $filename"
    jq --arg localfile "$localfile" --arg filename "$filename" '.subscribes[0].url = $localfile | .save_config_path = $filename' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done

links=(
        "https://raw.githubusercontent.com/Alvin9999/pac2/master/hysteria2/config.json"
        "https://chromego-sub.netlify.app/sub/base64.txt"
        "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.txt" 
        "https://raw.githubusercontent.com/PuddinCat/BestClash/refs/heads/main/proxies.yaml" 
        "https://raw.githubusercontent.com/Barabama/FreeNodes/refs/heads/main/nodes/clashmeta.txt"
        "https://raw.githubusercontent.com/lagzian/SS-Collector/main/vmess.txt"
        "https://raw.githubusercontent.com/roosterkid/openproxylist/refs/heads/main/V2RAY_BASE64.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/hysteria2.txt"
        "https://raw.githubusercontent.com/MatinGhanbari/v2ray-configs/main/subscriptions/filtered/subs/trojan.txt"
        "https://raw.githubusercontent.com/kSLAWIASCA/actions/refs/heads/main/Clash.yml"
        "https://raw.githubusercontent.com/WLget/V2Ray_configs_64/refs/heads/master/ConfigSub_list.txt"
        "https://raw.githubusercontent.com/shaoyouvip/free/refs/heads/main/base64.txt"
        "https://raw.githubusercontent.com/pachangcheng/mianfeijiedian/refs/heads/main/should.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/ss.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/vless.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/vless.txt"
)
counter=60
for file in "${links[@]}"; do
    # 在这里添加您的提取逻辑
    echo "Extracting from local file: $file"
    filename="./f${counter}.json"
    echo "Saving to file: $filename"
    jq --arg file "$file" --arg filename "$filename" '.subscribes[0].url = $file | .save_config_path = $filename' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done

rm -f split_*



