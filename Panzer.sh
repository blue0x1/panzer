#!/bin/bash

echo ""
echo "                                 
                                 
  _ __   __ _ _ __  _______ _ __ 
 | '_ \ / _\` | '_ \|_  / _ \ '__|
 | |_) | (_| | | | |/ /  __/ |   
 | .__/ \__,_|_| |_/___\___|_|   
 | |                              ProxyFinder v1"
echo ""
echo "The Proxies found:"
echo ""
U=('https://free-proxy-list.net/' 'https://www.us-proxy.org/')
for U in "${U[@]}"; do
    IP=$(curl -s "$U" | grep -E -o '<td>[0-9]+(\.[0-9]+){3}</td>\s*<td>[0-9]+</td>')
    while IFS= read -r L; do
        if [[ $L =~ ([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+):([0-9]+) ]]; then
            I="${BASH_REMATCH[1]}"
            P="${BASH_REMATCH[2]}"
            if curl -s --connect-timeout 3 -m 5 -x "http://${I}:${P}" 'http://httpbin.org/ip' >/dev/null 2>&1; then
                P+=(http://${I}:${P})
                echo "http://${I}:${P}"
                echo "http://${I}:${P}" >> proxies.txt
            fi
        fi
    done < <(echo "$IP" | awk -v RS='<\\/td>' -v FS='>' '{print $2}' | paste -d: - -)
done
