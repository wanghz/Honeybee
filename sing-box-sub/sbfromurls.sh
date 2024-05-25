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
    "https://timell.pages.dev/clash/proxies"
    "https://raw.githubusercontent.com/linzjian666/chromego_extractor/main/outputs/proxy_urls.txt"
    "https://raw.githubusercontent.com/mheidari98/.proxy/main/all"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub1.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub2.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub3.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub4.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub5.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub6.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub7.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub8.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub9.txt"
    "https://raw.githubusercontent.com/barry-far/V2ray-Configs/main/Sub10.txt"
    "https://proxypool.link/clash/proxies"
    "https://pp.dcd.one/clash/proxies?speed=15,50&type=ss"
    "https://pp.dcd.one/clash/proxies?speed=15,50&type=vmess"
    "https://pp.dcd.one/clash/proxies?speed=15,50&type=trojan"
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
