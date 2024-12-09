#!/bin/bash

files=(
        "htonly.yml"
        "under1k.yml"
        "reality.txt"
        "vmess.txt"
)

# 使用 find 匹配以 "split" 开头的文件
files_split=$(find . -maxdepth 1 -type f -name "split*" -printf "%f\n")
all_files="$files $files_split"

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



