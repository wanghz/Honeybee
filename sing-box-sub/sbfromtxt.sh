#!/bin/bash

curl "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.txt" -o split_a01.json
curl "https://raw.githubusercontent.com/PuddinCat/BestClash/refs/heads/main/proxies.yaml" -o split_a02.json

all_files=(
        "split_a01"
        "split_1k"
        "htonly.yml"
        "split_a02"
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



