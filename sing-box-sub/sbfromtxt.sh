#!/bin/bash

files=(
        "Config%20list1.txt"
        "Config%20list10.txt"
        "Config%20list2.txt"
        "Config%20list3.txt"
        "Config%20list4.txt"
        "Config%20list5.txt"
        "Config%20list6.txt"
        "Config%20list7.txt"
        "Config%20list8.txt"
        "Config%20list9.txt"
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



