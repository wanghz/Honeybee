#!/bin/bash

# 定义两个文件的 URL
snakem982url1="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/nodelist.txt"
snakem982url2="https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/proxies.txt"
local="https://raw.githubusercontent.com/wanghz/Honeybee/refs/heads/main/sing-box-sub/sub_urls.txt"

# 下载文件
curl "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/nodelist.txt" -o snakem982url1.txt 
curl "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/proxies.txt" -o snakem982url2.txt 
curl "https://raw.githubusercontent.com/LalatinaHub/Mineral/refs/heads/master/result/subs" -o url3.txt 

curl -o localurl.txt "$local"
echo "" >> localurl.txt
cat snakem982url1.txt>>localurl.txt
echo "" >> localurl.txt
cat snakem982url2.txt>>localurl.txt
echo "" >> localurl.txt
cat url3.txt>>localurl.txt
echo "" >> localurl.txt
# 添加一些
echo "https://raw.gitmirror.com/Memory2314/VMesslinks/main/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml" >> localurl.txt
echo "https://raw.githubusercontent.com/MhdiTaheri/V2rayCollector/refs/heads/main/sub/mix" >> localurl.txt
echo "https://raw.githubusercontent.com/lagzian/SS-Collector/refs/heads/main/VLESS/VL100.txt" >> localurl.txt
echo "https://raw.githubusercontent.com/lagzian/SS-Collector/refs/heads/main/SS/Trinity.txt">>localurl.txt
echo "https://raw.githubusercontent.com/zhangkaiitugithub/passcro/main/speednodes.txt">>localurl.txt
echo "https://raw.githubusercontent.com/vxiaov/free_proxies/refs/heads/main/clash/clash.provider.yaml">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/subscribe/protocols/vless">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/subscribe/protocols/vmess">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/subscribe/protocols/hysteria">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/splitted/subscribe">>localurl.txt
echo "https://raw.githubusercontent.com/4n0nymou3/multi-proxy-config-fetcher/refs/heads/main/configs/proxy_configs.txt">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/refs/heads/main/subscription%20links.json">>localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/V2RAY-CLASH-BASE64-Subscription.Links/refs/heads/main/SUB%20LINKS">>localurl.txt
echo "https://raw.githubusercontent.com/ermaozi/get_subscribe/main/subscribe/v2ray.txt">>localurl.txt
echo "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/clash-meta.yaml">>localurl.txt
#echo "https://hideshots.eu/sub.txt">>localurl.txt
#echo "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/main/mini/m1n1-5ub-1.txt">>localurl.txt
#echo "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/main/mini/m1n1-5ub-3.txt">>localurl.txt
#echo "https://raw.githubusercontent.com/sevcator/5ubscrpt10n/main/mini/m1n1-5ub-4.txt">>localurl.txt
#echo "https://raw.githubusercontent.com/qianlima8888/autoClashProxy/refs/heads/main/list.yaml">>localurl.txt
echo "https://raw.githubusercontent.com/SamanGho/v2ray_collector/refs/heads/main/last_150.txt">>localurl.txt
#echo "https://xray.abvpn.ru/vless/37208d52-8823-412d-944e-0a8ef08a5079/6397639568.json#abvpn">>localurl.txt
#echo "https://istanbulsydneyhotel.com/blogs/site/sni.php?security=reality">>localurl.txt
#echo "https://istanbulsydneyhotel.com/blogs/site/sni.php">>localurl.txt
#echo "https://clash.crossxx.com/sub/vmess/1734076804" >> localurl.txt
#echo "https://clash.crossxx.com/sub/hysteria/1734076804" >> localurl.txt
# 删除一些找不到的或没内容的
sed -i -e '/yebekhe\/TelegramV2rayCollector\/main\/sub\/base64\/mix/d' \
       -e '/\/Vauth/d' \
       -e '/\/xiaoji235\/airport-free/d' \
       -e '/^http:\/\/174\.137\.58\.32:12580\/clash\/proxies/d' \
       -e '/^http:\/\/104\.168\.244\.47:12580\/clash\/proxies/d' \
       -e '/^http:\/\/beetle\.lander\.work\/clash\/proxies/d' \
       -e '/^https:\/\/proxy\.fldhhhhhh\.top\/clash\/proxies/d' \
       -e '/banyunxiaoxi\.icu/d' \
       -e '/^https:\/\/raw\.gitmirror\.com\/Memory2314/d' \
       -e '/^https:\/\/hiddify-freevpnhomes-subscription\.meshkintaj\.homes/d' \
       -e '/^https:\/\/dy9\.baipiaoyes\.com\/api\/v1\/client\/subscribe/d' \
       -e '/^https:\/\/raw\.githubusercontent\.com\/Memory2314\/VMesslinks\/refs\/heads\/main\/links\/vmess/d' \
       -e '/\/mai19950/d' \
       -e '/zhlx2835/d' \
       -e '/Roywaller/d' \
       -e '/Ruk1ng001/d' \
       -e '/shahidbhutta/d' \
       -e '/Ruk1ng001/d' \
       -e '/\/leetomlee123/d' \
       -e '/\/snakem982\/proxypool\/refs\/heads\/main\/source\/v2ray\.txt/d' \
       -e '/airport/d' \
       -e '/aiboboxx/d' \
       -e '/a2470982985/d' \
       -e '/space-00/d' \
       -e '/crossxx/d' \
       -e '/yudou66\.top/d' \
       -e '/mxlsub\.me\/newfull/d' \
       -e '/barry-far/d' \
       -e '/http:\/\/175\.178\.182\.178:12580/d' \
       -e '/anaer\/Sub\/main\/clash\.yaml/d'  \
       -e '/155\.248\.172\.106:12580\/clash\/proxies/d'  \
       -e '/\/v2tel_links[0-9]\+.txt/d'  \
       -e '/SoliSpirit\/v2ray-configs\/main\/all_configs\.txt/d' \
       -e '/\/[A-Za-z]\+_file_vpn\.txt/d' \
       -e '/Flikify\/getNode\/refs\/heads\/main\/clash\.yaml/d'  localurl.txt

# 使用命令组合提取指定行，并用 mapfile 读入数组
filename="localurl.txt"
mapfile -t urls < <(
  sed -n  '1p;4p;32p;33p' "$filename"
  tail -n 70 "$filename"
)

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

