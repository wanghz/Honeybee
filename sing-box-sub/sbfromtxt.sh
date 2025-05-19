#!/bin/bash
all_files=(
        "htonly.yml"
)

URL="https://github.com/Alvin9999/new-pac/wiki/v2ray%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
# 使用 curl 获取网页内容，并用 pup 提取指定元素
CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(22) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT" 
  echo "$CONTENT" > split_alv
else
  echo "No content extracted" >&2
fi

CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(27) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT" 
  echo "$CONTENT" >> split_alv
else
  echo "No content extracted" >&2
fi

URL="https://github.com/Alvin9999/new-pac/wiki/ss%E5%85%8D%E8%B4%B9%E8%B4%A6%E5%8F%B7"
CONTENT=$(curl -s "$URL" | pup '#wiki-body > div > div:nth-child(25) > pre text{}')
if [ -n "$CONTENT" ]; then
  echo "$CONTENT" 
  echo "$CONTENT" >> split_alv
else
  echo "No content extracted" >&2
fi

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
        "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.txt" 
        "https://raw.githubusercontent.com/PuddinCat/BestClash/refs/heads/main/proxies.yaml" 
        "https://raw.githubusercontent.com/Barabama/FreeNodes/refs/heads/main/nodes/clashmeta.txt"
        "https://raw.githubusercontent.com/lagzian/SS-Collector/main/vmess.txt"
        "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Splitted-By-Protocol/vless.txt"
        "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Splitted-By-Protocol/trojan.txt"
        "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Splitted-By-Protocol/hysteria2.txt"
        "https://raw.githubusercontent.com/roosterkid/openproxylist/refs/heads/main/V2RAY_BASE64.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/trojan.txt"
        "https://raw.githubusercontent.com/gfpcom/free-proxy-list/main/list/vless.txt"
        "https://raw.githubusercontent.com/MatinGhanbari/v2ray-configs/main/subscriptions/filtered/subs/hy2.txt"
        "https://raw.githubusercontent.com/MatinGhanbari/v2ray-configs/main/subscriptions/filtered/subs/trojan.txt"
        "https://raw.githubusercontent.com/V2RAYCONFIGSPOOL/V2RAY_SUB/refs/heads/main/v2ray_configs.txt"
        "https://raw.githubusercontent.com/kSLAWIASCA/actions/refs/heads/main/Clash.yml"
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



