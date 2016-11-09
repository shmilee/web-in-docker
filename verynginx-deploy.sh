#!/bin/bash
dist=${1:-/srv/http/verynginx}
[ -d ./src-VeryNginx ] || git clone --depth=1 https://github.com/alexazhou/VeryNginx.git ./src-VeryNginx
[ -d ./deploy-verynginx ] && rm -r ./deploy-verynginx
cp -r ./src-VeryNginx/verynginx ./deploy-verynginx
sed -i "s|/opt/verynginx/verynginx|$dist|g" ./deploy-verynginx/nginx_conf/*block.conf
echo "=> OK!"
echo "=> please move ./deploy-verynginx to $dist, and edit your nginx.conf with 'nginx_conf/*block.conf'."
echo "=> Make sure lua-nginx-module, http_stub_status_module, http_ssl_module are complied and loaded in your 'nginx'."
