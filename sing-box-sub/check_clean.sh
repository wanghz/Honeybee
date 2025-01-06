#!/bin/bash

# 检查依赖是否可用
if ! command -v sing-box &>/dev/null; then
    echo "Error: sing-box not installed or not in PATH"
    exit 1
fi

if ! command -v python3 &>/dev/null; then
    echo "Error: Python3 not installed or not in PATH"
    exit 1
fi

# 指定要执行的程序
program="./sing-box check -c"
second_program="python3 cfg_clean.py"

# 遍历以 f 和 k 开头的 JSON 文件
for json_file in f*.json k*.json; do
    if [[ -f "$json_file" ]]; then
        echo "Processing file: $json_file"
        max_attempts=500
        attempts=0
        while true; do
            attempts=$((attempts + 1))
            if [[ $attempts -ge $max_attempts ]]; then
                echo "Reached maximum attempts for $json_file"
                break
            fi

            output=$($program "$json_file" 2>&1)
            if [[ -n "$output" ]]; then
                echo "File: $json_file"
                echo "Output: $output"
                echo "-------------------"

                number=$(echo "$output" | sed -n 's/.*outbound\[\([0-9]*\)\].*/\1/p')
                echo "Extracted number: $number"

                $second_program "$json_file" "index" "$number"

                output=$($program "$json_file" 2>&1)
            else
                echo "No output. Exiting loop for $json_file"
                break
            fi
        done
    else
        echo "No matching JSON files found"
    fi
done
