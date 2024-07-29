#!/bin/bash

urls=(
    "http://141.147.161.50:12580/clash/proxies"
    "http://150.230.195.209:12580/clash/proxies"
    "http://155.248.172.106:12580/clash/proxies"
    "http://174.137.58.32:12580/clash/proxies"
    "http://175.178.182.178:12580/clash/proxies"
    "http://66.42.50.118:12580/clash/proxies"
    "http://104.168.244.47:12580/clash/proxies"
    "http://beetle.lander.work/clash/proxies"
    "https://clashe.eu.org/clash/proxies"
    "https://laxcity.pages.dev/clash/proxies"
    "https://proxy.crazygeeky.com/clash/proxies"
    "https://proxy.fldhhhhhh.top/clash/proxies"
    "https://proxypool.link/clash/proxies"
    "https://proxypool1999.banyunxiaoxi.icu/clash/proxies"
    "https://timell.pages.dev/clash/proxies"
    "https://raw.githubusercontent.com/aiboboxx/clashfree/main/clash.yml"
    "https://raw.githubusercontent.com/anaer/Sub/main/clash.yaml"
    "https://raw.githubusercontent.com/chengaopan/AutoMergePublicNodes/master/list.yml"
    "https://raw.githubusercontent.com/mahdibland/V2RayAggregator/master/sub/sub_merge_yaml.yml"
    "https://raw.githubusercontent.com/mheidari98/.proxy/main/all"
    "https://raw.githubusercontent.com/NiceVPN123/NiceVPN/main/Clash.yaml"
    "https://raw.githubusercontent.com/ronghuaxueleng/get_v2/main/pub/combine.yaml"
    "https://raw.githubusercontent.com/ts-sf/fly/main/clash"
    "https://raw.githubusercontent.com/PangTouY00/Auto_proxy/main/Long_term_subscription_num"
    "https://raw.githubusercontent.com/yaney01/Yaney01/main/temporary"
    "https://raw.githubusercontent.com/zhangkaiitugithub/passcro/main/speednodes.yaml"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/hysteria"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/vmess"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/vless"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/trojan"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/shadowsocks"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/reality"
    "https://raw.githubusercontent.com/yebekhe/TelegramV2rayCollector/main/sub/base64/mix"
    "https://raw.githubusercontent.com/peasoft/NoMoreWalls/master/list.yml"
    "https://raw.githubusercontent.com/Vauth/node/main/Main"
    "https://raw.githubusercontent.com/Vauth/node/main/Master"
    "https://raw.githubusercontent.com/WilliamStar007/ClashX-V2Ray-TopFreeProxy/main/combine/clash.config.yaml"
    "https://raw.githubusercontent.com/Epodonios/v2ray-configs/main/All_Configs_base64_Sub.txt"
    "https://raw.githubusercontent.com/lagzian/SS-Collector/main/mix_clash.yaml"
    "https://raw.githubusercontent.com/ALIILAPRO/v2rayNG-Config/main/sub.txt"
    "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/clash-meta/all.yaml"
    "https://raw.githubusercontent.com/Misaka-blog/chromego_merge/main/sub/merged_proxies_new.yaml"
    "https://raw.githubusercontent.com/linzjian666/chromego_extractor/main/outputs/proxy_urls.txt"
    "https://raw.githubusercontent.com/linzjian666/chromego_extractor/main/outputs/base64.txt"
    "https://raw.githubusercontent.com/Misaka-blog/chromego_merge/main/sub/base64.txt"
    "https://raw.githubusercontent.com/MrMohebi/xray-proxy-grabber-telegram/master/collected-proxies/row-url/actives.txt"
    "https://raw.githubusercontent.com/soroushmirzaei/telegram-configs-collector/main/protocols/hysteria"    
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
