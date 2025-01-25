#!/bin/bash

all_files=(
        "split_act"
        "split_1k"
        "htonly.yml"
)

# 获取 sub/ 目录下过去60分钟提交的 split* 文件（安全处理含空格/特殊字符）
# 获取 sub/ 目录下过去60分钟提交的 split* 文件，并提取纯文件名
while IFS= read -r -d $'\0' filepath; do
    # 提取文件名（去除路径）
    filename=$(basename "$filepath")
    # 再次过滤确保符合 split* 模式（防止路径干扰）
    if [[ "$filename" == split* ]]; then
        all_files+=("$filename")
    fi
done < <(
    git -C /home/runner/work/Honeybee/Honeybee log \
    --since "60 minutes ago" \
    --name-only \
    --pretty=format: \
    --submodule=diff \
    -- "sub/split*" \
    | grep -av '^$' \
    | sort -zu \
    | sed 's|^sub/||'  # 移除 sub/ 前缀（如果存在）
)

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



