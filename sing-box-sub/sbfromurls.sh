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
#cat url3.txt>>localurl.txt
echo "" >> localurl.txt
# 添加一些
echo "https://github.com/barry-far/V2ray-Configs/raw/main/Splitted-By-Protocol/ss.txt">> localurl.txt
echo "https://github.com/barry-far/V2ray-Configs/raw/main/Splitted-By-Protocol/vless.txt">> localurl.txt
echo "https://github.com/barry-far/V2ray-Configs/raw/main/Splitted-By-Protocol/vmess.txt">> localurl.txt
echo "https://raw.githubusercontent.com/jikelonglie/meskell/main/meskell">> localurl.txt
echo "https://raw.githubusercontent.com/iwxf/free-v2ray/master/index.html">> localurl.txt
echo "https://raw.githubusercontent.com/ripaojiedian/freenode/main/sub">> localurl.txt
echo "https://raw.githubusercontent.com/zhangkaiitugithub/passcro/main/speednodes.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/ReaJason/Clash-Butler/master/clash.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/Loon/main/node">> localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/Loon/main/node%202">> localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/QX/refs/heads/main/Nodes">> localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/Loon/refs/heads/main/all.nodes.txt">> localurl.txt
echo "https://raw.gitmirror.com/Memory2314/VMesslinks/main/links/vmess" >> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml" >> localurl.txt
\echo "https://raw.githubusercontent.com/lagzian/SS-Collector/refs/heads/main/VLESS/VL100.txt" >> localurl.txt
echo "https://raw.githubusercontent.com/lagzian/SS-Collector/refs/heads/main/SS/Trinity.txt">>localurl.txt
echo "https://raw.githubusercontent.com/zhangkaiitugithub/passcro/main/speednodes.txt">>localurl.txt
echo "https://raw.githubusercontent.com/vxiaov/free_proxies/refs/heads/main/clash/clash.provider.yaml">>localurl.txt
echo "https://raw.githubusercontent.com/4n0nymou3/multi-proxy-config-fetcher/refs/heads/main/configs/proxy_configs.txt">>localurl.txt
echo "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/refs/heads/main/subscription%20links.json">>localurl.txt
echo "https://raw.githubusercontent.com/mermeroo/V2RAY-CLASH-BASE64-Subscription.Links/refs/heads/main/SUB%20LINKS">>localurl.txt
echo "https://raw.githubusercontent.com/ermaozi/get_subscribe/main/subscribe/v2ray.txt">>localurl.txt
echo "https://raw.githubusercontent.com/snakem982/proxypool/refs/heads/main/source/clash-meta.yaml">>localurl.txt
echo "https://raw.githubusercontent.com/ermaozi/get_subscribe/main/subscribe/clash.yml">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/yudou66.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/nodefree.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/nodev2ray.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/ndnode.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/clashmeta.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/v2rayshare.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Barabama/FreeNodes/main/nodes/wenode.txt">> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/anaer/Sub/refs/heads/main/clash.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/All_Configs_Sub.txt">> localurl.txt
echo "https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml">> localurl.txt
echo "https://raw.githubusercontent.com/mfuu/v2ray/master/clash.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/mgit0001/test_clash/main/heima.txt">> localurl.txt
echo "https://raw.githubusercontent.com/mgit0001/test_clash/refs/heads/main/heima.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Pawdroid/Free-servers/refs/heads/main/sub">> localurl.txt
echo "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.yml">> localurl.txt
echo "https://raw.githubusercontent.com/ripaojiedian/freenode/main/clash">> localurl.txt
echo "https://raw.githubusercontent.com/vxiaov/free_proxies/main/clash/clash.provider.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/xiaoji235/airport-free/main/clash/naidounode.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/main/sub/France/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/main/sub/Germany/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/main/sub/Singapore/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/main/sub/Japan/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/refs/heads/main/sub/United%20States/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Epodonios/bulk-xray-v2ray-vless-vmess-...-configs/refs/heads/main/sub/Hong%20Kong/config.txt">>localurls.txt
echo "https://raw.githubusercontent.com/Kwinshadow/TelegramV2rayCollector/refs/heads/main/sublinks/b64ss.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Kwinshadow/TelegramV2rayCollector/refs/heads/main/sublinks/b64vless.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Kwinshadow/TelegramV2rayCollector/refs/heads/main/sublinks/b64vmess.txt">> localurl.txt
echo "https://raw.githubusercontent.com/Kwinshadow/TelegramV2rayCollector/refs/heads/main/sublinks/b64trojan.txt">> localurl.txt
echo "https://mxlsub.me/newfull">> localurl.txt
echo "https://proxypool.link/vmess/sub">> localurl.txt
echo "https://raw.githubusercontent.com/ts-sf/fly/main/v2">> localurl.txt
echo "https://raw.githubusercontent.com/xiaoji235/airport-free/main/clash/naidounode.txt">> localurl.txt
echo "https://raw.githubusercontent.com/xiaoji235/airport-free/main/v2ray.txt">> localurl.txt
echo "https://raw.githubusercontent.com/xiaoji235/airport-free/main/v2ray/v2rayshare.txt">> localurl.txt
echo "https://raw.githubusercontent.com/xiaoji235/airport-free/refs/heads/main/clash/naidounode.txt">> localurl.txt
echo "https://raw.githubusercontent.com/anaer/Sub/refs/heads/main/proxies.yaml">> localurl.txt
echo "https://raw.githubusercontent.com/free-nodes/v2rayfree/main/v2">> localurl.txt
echo "https://raw.githubusercontent.com/a2470982985/getNode/main/clash.yaml">>localurl.txt
echo "https://raw.githubusercontent.com/Leon406/SubCrawler/refs/heads/main/sub/share/hysteria2" >>localurl.txt
echo "https://raw.githubusercontent.com/Leon406/SubCrawler/refs/heads/main/sub/share/vless" >>localurl.txt
echo "https://raw.githubusercontent.com/roosterkid/openproxylist/refs/heads/main/V2RAY.txt">>localurl.txt
echo "https://raw.githubusercontent.com/Surfboardv2ray/TGParse/main/splitted/mixed">>localurl.txt
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
       -e '/4n0nymou3/d' \
       -e '/zhlx2835/d' \
       -e '/soroushmirzaei/d' \
       -e '/Roywaller/d' \
       -e '/Ruk1ng001/d' \
       -e '/shahidbhutta/d' \
       -e '/Ruk1ng001/d' \
       -e '/\/leetomlee123/d' \
       -e '/airport/d' \
       -e '/a2470982985/d' \
       -e '/space-00/d' \
       -e '/crossxx/d' \
       -e '/yudou66\.top/d' \
       -e '/mxlsub\.me\/newfull/d' \
       -e '/barry-far/d' \
       -e '/http:\/\/175\.178\.182\.178:12580/d' \
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

