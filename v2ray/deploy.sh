#!/bin/bash

ipaddr=${1}
port=${2:-$RANDOM}
domain=${3:-$ipaddr}
v2raypath=$(mktemp -p download/huge -t 'dataid=XXXXXXXXXX' -u)

if [ -z $ipaddr ];then
    cat <<EOF
usage: $0 ip-addr [port] [domain]
default:
  port       \$RANDOM
  domain     ip-addr
EOF
    exit 1
fi

[ -d v2ray-deploy ] && rm -r v2ray-deploy/

echo "==> copy etc files ..."
mkdir -pv v2ray-deploy/etc/ssl-certs
cp -r modules-enabled sites-enabled monitrc ../etc/nginx.conf v2ray-deploy/etc/
chmod 600 v2ray-deploy/etc/monitrc
#sudo chown -v 0:0 v2ray-deploy/etc/monitrc
sed -i -e "s|{{domain-name}}|$domain|" -e "s|{{v2raypath}}|$v2raypath|" v2ray-deploy/etc/sites-enabled/nginx-*.vhost

echo "==> log dir ..."
mkdir v2ray-deploy/log

echo "==> v2ray config ..."
uuid1=$(cat /proc/sys/kernel/random/uuid)
uuid2=$(cat /proc/sys/kernel/random/uuid)
#uuid1='x-x-x-x-x' # test
#uuid2='x-x-x-x-x'
sed -e "s|{{UUID1}}|${uuid1}|" -e "s|{{UUID2}}|${uuid2}|" \
    -e "s|{{port1}}|$port|" \
    -e "s|{{v2raypath}}|$v2raypath|" \
    v2ray-server-config.json > v2ray-deploy/v2ray-server-config.json
sed -e "s|{{UUID1}}|${uuid1}|" -e "s|{{UUID2}}|${uuid2}|" \
    -e "s|{{ip-addr}}|$ipaddr|" -e "s|{{port1}}|$port|" \
    -e "s|{{domain-name}}|$domain|" -e "s|{{v2raypath}}|$v2raypath|" \
    v2ray-client-config.json > v2ray-deploy/v2ray-client-config.json


echo "==> Done."
cat <<'EOF' | sed "s|{{port1}}|$port|g" 

1. Put dhparam.pem server-v2ray.{crt,key} in v2ray-deploy/etc/ssl-certs
   Run nginx and v2ray
docker run --rm --name nginx_v2ray \
    -p 80:80 -p 443:443 -p {{port1}}:{{port1}} \
    -v $PWD/v2ray-deploy/etc:/srv/etc:ro \
    -v $PWD/v2ray-deploy/v2ray-server-config.json:/etc/v2ray/config.json:ro \
    -v $PWD/v2ray-deploy/log:/srv/log:rw \
    shmilee/v2ray

2. If containers run scucessfully, the option '--rm' can be replaced by '--detach --restart=always'
EOF
