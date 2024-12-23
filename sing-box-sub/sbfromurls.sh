#!/bin/bash

# 定义两个文件的 URL
snakem982url1="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/nodelist.txt"
snakem982url2="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/proxies.txt"
local="https://raw.githubusercontent.com/wanghz/Honeybee/refs/heads/main/sing-box-sub/sub_urls.txt"

# 下载文件
curl -o snakem982url1.txt "$snakem982url1"
curl -o snakem982url2.txt "$snakem982url2"
curl -o url3.txt "https://raw.githubusercontent.com/LalatinaHub/Mineral/refs/heads/master/result/subs"

curl -o localurl.txt "$local"
cat snakem982url1.txt>>localurl.txt
cat snakem982url2.txt>>localurl.txt
cat url3.txt>>localurl.txt
# 添加一些
echo "https://raw.gitmirror.com/Memory2314/VMesslinks/main/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml" >> localurl.txt
echo "https://raw.githubusercontent.com/Huibq/TrojanLinks/master/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/Huibq/TrojanLinks/master/links/trojan" >> localurl.txt
echo "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/clash-meta.yaml" >> localurl.txt
echo "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/v2ray.txt" >> localurl.txt
echo "https://raw.githubusercontent.com/aiboboxx/clashfree/refs/heads/main/clash.yml" >> localurl.txt
echo "https://raw.githubusercontent.com/Flikify/getNode/refs/heads/main/clash.yaml" >> localurl.txt
echo "https://raw.githubusercontent.com/Flikify/getNode/refs/heads/main/clash.yaml" >> localurl.txt
echo "https://clash.crossxx.com/sub/vmess/1734076804" >> localurl.txt
echo "https://clash.crossxx.com/sub/hysteria/1734076804" >> localurl.txt
echo "https://raw.githubusercontent.com/Leon406/SubCrawler/refs/heads/main/sub/share/hysteria2" >> localurl.txt
echo "https://raw.githubusercontent.com/Leon406/SubCrawler/refs/heads/main/sub/share/v2" >> localurl.txt
echo "https://raw.githubusercontent.com/Leon406/SubCrawler/refs/heads/main/sub/share/tr" >> localurl.txt
echo "https://github.com/MhdiTaheri/V2rayCollector/blob/main/sub/mix" >> localurl.txt
echo "https://raw.githubusercontent.com/lagzian/SS-Collector/refs/heads/main/VLESS/VL100.txt" >> localurl.txt
echo "https://raw.githubusercontent.com/mheidari98/.proxy/refs/heads/main/trojan">> localurl.txt
echo "https://raw.githubusercontent.com/vxiaov/free_proxies/refs/heads/main/clash/clash.provider.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/Space-00/V2ray-configs/refs/heads/main/config.txt">>localurl.txt
# 删除一些找不到的或没内容的
sed -i '/yebekhe\/TelegramV2rayCollector\/main\/sub\/base64\/mix/d' localurl.txt
sed -i '/Vauth\/node\/main\/Master/d' localurl.txt
sed -i '/^http:\/\/174\.137\.58\.32:12580\/clash\/proxies/d' localurl.txt
sed -i '/^http:\/\/104\.168\.244\.47:12580\/clash\/proxies/d' localurl.txt
sed -i '/^http:\/\/beetle\.lander\.work\/clash\/proxies/d' localurl.txt
sed -i '/^https:\/\/proxy\.fldhhhhhh\.top\/clash\/proxies/d' localurl.txt
sed -i '/banyunxiaoxi\.icu/d' localurl.txt
sed -i '/^https:\/\/raw\.gitmirror\.com\/Memory2314/d' localurl.txt
sed -i '/^https:\/\/dpaste\.com/d' local.url.txt
sed -i '/^https:\/\/hiddify-freevpnhomes-subscription\.meshkintaj\.homes/d' localurl.txt
sed -i 'baipiaoyes\.com/d' localurl.txt
sed -i 'Memory2314\/VMesslinks\/refs\/heads\/main\/links\/vmess/d' localurl.txt
# 初始化数组
urls=()
# 将文件内容合并到数组中
while IFS= read -r line; do
    urls+=("$line")
done < <(awk '1; ENDFILE {print ""}' localurl.txt)

counter=1
for url in "${urls[@]}"; do
    echo "Extracting from URL: $url"
    # curl "$url" | jq -r '.proxies[]'
    filename="./k${counter}.json"
    echo "Saving to file: $filename"
    jq --arg url "$url" --arg filename "$filename" '.subscribes[0].url = $url | .save_config_path = $filename' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done
