#!/bin/bash
all_files=(
        #"htonly.yml"
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
        "https://raw.githubusercontent.com/MatinGhanbari/v2ray-configs/main/subscriptions/filtered/subs/trojan.txt"
        "https://raw.githubusercontent.com/WLget/V2Ray_configs_64/refs/heads/master/ConfigSub_list.txt"
        "https://raw.githubusercontent.com/shaoyouvip/free/refs/heads/main/base64.txt"
        "https://raw.githubusercontent.com/pachangcheng/mianfeijiedian/refs/heads/main/should.txt"
        "https://raw.githubusercontent.com/somemoo/v2rayfree/main/v2rayfree"
        "https://raw.githubusercontent.com/w154594742/free-v2ray-node/refs/heads/master/v2ray.txt"
        "https://raw.githubusercontent.com/PuddinCat/BestClash/refs/heads/main/proxies.yaml" 
        "https://media.githubusercontent.com/media/gfpcom/free-proxy-list/refs/heads/main/list/ss.txt"
        "https://media.githubusercontent.com/media/gfpcom/free-proxy-list/refs/heads/main/list/trojan.txt"
        "https://media.githubusercontent.com/media/gfpcom/free-proxy-list/refs/heads/main/list/hy.txt"
        "https://media.githubusercontent.com/media/gfpcom/free-proxy-list/refs/heads/main/list/hy2.txt"
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



