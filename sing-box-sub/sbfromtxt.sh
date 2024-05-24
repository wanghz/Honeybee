#!/bin/bash

files=(
        "Config%2520list1.txt"
        "Config%2520list10.txt"
        "Config%2520list11.txt"
        "Config%2520list12.txt"
        "Config%2520list13.txt"
        "Config%2520list14.txt"
        "Config%2520list2.txt"
        "Config%2520list3.txt"
        "Config%2520list4.txt"
        "Config%2520list5.txt"
        "Config%2520list6.txt"
        "Config%2520list7.txt"
        "Config%2520list8.txt"
        "Config%2520list9.txt"
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



