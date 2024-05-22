#                             Online Bash Shell.
#                 Code, Compile, Run and Debug Bash script online.
# Write your code in this editor and press "Run" button to execute it.

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
)

counter=1
for url in "${urls[@]}"; do
    echo "Extracting from URL: $url"
    # 在这里添加您的提取逻辑
    # 例如:
    # curl "$url" | jq -r '.proxies[]'
    filename="k${counter}.json"
    echo "Saving to file: $filename"
    jq '.subscribes[0].url = "$url"' provx.json > tmpfile && mv tmpfile provx.json
    jq '.save_config_path = "$filename"' provx.json > tmpfile && mv tmpfile provx.json
    python ./newmain.py -c provx.json
    ((counter++))
done

