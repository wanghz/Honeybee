#!/bin/bash

chmod +x ../sing-box-sub/sing-box
# 指定要执行的程序
program="../sing-box-sub/sing-box check -c"
second_program="python3 ../sing-box-sub/cfg_clean.py"
split_program="python3 ../sing-box-sub/large_config_split.py"

# 预处理以 f 和 k 开头的 JSON 文件
for json_file in f*.json k*.json; do
    # 记录开始时间（纳秒级）
    start=$(date +%s%N)
    
    if [[ -f "$json_file" ]]; then
        echo "预处理 file: $json_file"
        # 清理潜在的不合规配置
        $second_program "$json_file" "check" 000\
        # 记录结束时间
        end=$(date +%s%N)
        # 计算耗时并转换为毫秒
        duration=$((end - start))
        milliseconds=$(echo "scale=3; $duration / 1000000" | bc)
        
        echo "预处理 $json_file 完成，耗时: $milliseconds 毫秒"
        echo "----------------------------------------"
    else
        echo "No matching JSON files found"
    fi
done

# 遍历以 f 和 k 开头的 JSON 文件
for json_file in f*.json k*.json; do
    # 记录开始时间（纳秒级）
    start=$(date +%s%N)
    
    if [[ -f "$json_file" ]]; then
        echo "Processing file: $json_file"
        max_attempts=100
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
                # 判断 $output 是否包含 "rule-set"
                if echo "$output" | grep -q "rule-set"; then
                    echo "Found 'rule-set' in output. Skipping further processing for $json_file."
                    continue
                else
                    number=$(echo "$output" | sed -n 's/.*outbounds\?\[\([0-9]*\)\].*/\1/p')
                    echo "Extracted number: $number"
                    $second_program "$json_file" "index" "$number"
                    output=$($program "$json_file" 2>&1)
                fi
            else
                echo "No output. checking $json_file"
                break
            fi
        done
        # 拆分过大的配置
        outbounds_length=$(jq '.outbounds | length' "$json_file")
        if [ "$outbounds_length" -gt 2000 ]; then
            $split_program "$json_file" "1000"
        fi
    
    # 记录结束时间
    end=$(date +%s%N)
    # 计算耗时并转换为毫秒
    duration=$((end - start))
    milliseconds=$(echo "scale=3; $duration / 1000000" | bc)
    
    echo "处理 $json_file 完成，耗时: $milliseconds 毫秒"
    echo "----------------------------------------"
        
    else
        echo "No matching JSON files found"
    fi
done
