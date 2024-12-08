#!/bin/bash

files=(
        "split_aa"
        "split_ab"
        "split_ac"
        "split_ad"
        "split_ae"
        "split_af"
        "split_ag"
        "split_ah"
        "split_ai"
        "htonly.yml"
        "under1k.yml"
        "reality.txt"
        "vmess.txt"
)

counter=1
for file in "${files[@]}"; do
    # 在这里添加您的提取逻辑
    localfile="https://raw.githubusercontent.com/wanghz/Honeybee/main/sub/$file"
    echo "Extracting from local file: $localfile"
    filename="./f${counter}.json"
    echo "Saving to file: $filename"
    jq --arg localfile "$localfile" --arg filename "$filename" '.subscribes[0].url = $localfile | .save_config_path = $filename' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done



