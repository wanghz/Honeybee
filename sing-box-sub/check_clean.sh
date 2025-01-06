#!/bin/bash

# 指定要执行的程序
program="./sing-box check -c "
# 指定第二个要执行的程序
second_program="python3 cfg_clean.py"

# 创建一个临时文件来存储输出
temp_output=$(mktemp)

# 遍历以 f 和 k 开头的 JSON 文件
for json_file in f*.json k*.json; do
    if [[ -f "$json_file" ]]; then
        while true; do    
            output=$($program "$json_file" 2>&1)
            if [[ -n "$output" ]]; then
                echo "File: $json_file"
                echo "Output: $output"
                echo "-------------------"

                number=$(echo "$output" | sed -n 's/.*outbound\[\([0-9]*\)\].*/\1/p')
                echo "提取的数字是: $number"

                $second_program "$json_file" "index" "$number"

                output=$($program "$json_file" 2>&1)
            else
                break
            fi
        done
    fi
done

# 删除临时文件
rm -f "$temp_output"
