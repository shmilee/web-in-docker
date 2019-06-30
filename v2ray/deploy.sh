#!/bin/bash

ipaddr=${1}
port=${2:-12345}
domain=${3:-$ipaddr}
v2raypath=${4:-v2rayv2ray}

if [ -z $ipaddr ];then
    cat <<EOF
usage: $0 ip-addr [port] [domain] [v2raypath]
default:
  port       12345
  domain     ip-addr
  v2raypath  'v2rayv2ray'
EOF
    exit 1
fi

[ -d v2ray-deploy ] && rm -r v2ray-deploy/
mkdir -pv v2ray-deploy/etc

echo "==> copy etc files ..."
cp -r modules-enabled sites-enabled monitrc ../etc/nginx.conf v2ray-deploy/etc/
chmod 600 v2ray-deploy/etc/monitrc
sudo chown -v 0:0 v2ray-deploy/etc/monitrc
sed -i -e "s|{{domain-name}}|$domain|" -e "s|{{v2raypath}}|$v2raypath|" v2ray-deploy/etc/sites-enabled/nginx-*.vhost
mkdir v2ray-deploy/etc/ssl-certs

echo "==> log dir ..."
mkdir v2ray-deploy/log

echo "==> v2ray config ..."
uuid1=$(uuidgen)
uuid2=$(uuidgen)
#uuid1='x-x-x-x-x' # test
#uuid2='x-x-x-x-x'
cp v2ray-server.config v2ray-client.config v2ray-deploy/
sed -i -e "s|{{UUID1}}|${uuid1}|" -e "s|{{UUID2}}|${uuid2}|" \
    -e "s|{{port1}}|$port|" \
    -e "s|{{v2raypath}}|$v2raypath|" \
    v2ray-deploy/v2ray-server.config
sed -i -e "s|{{UUID1}}|${uuid1}|" -e "s|{{UUID2}}|${uuid2}|" \
    -e "s|{{ip-addr}}|$ipaddr|" -e "s|{{port1}}|$port|" \
    -e "s|{{domain-name}}|$domain|" -e "s|{{v2raypath}}|$v2raypath|" \
    v2ray-deploy/v2ray-client.config


echo "==> Done."
cat <<'EOF' | sed "s|{{port1}}|$port|g" 

1. Run v2ray
docker run -d --name v2ray -p {{port1}}:{{port1}} \
    -v $PWD/v2ray-deploy/v2ray-server.config:/etc/v2ray/config.json \
    -v $PWD/v2ray-deploy/log:/var/log/v2ray:rw \
    v2ray/official

2. Put dhparam.pem server-v2ray.{crt,key} in v2ray-deploy/etc/ssl-certs
   Run nginx
docker run --rm -d --name nginx --link v2ray -p 80:80 -p 443:443 \
    -v $PWD/v2ray-deploy/etc:/srv/etc:ro \
    -v $PWD/v2ray-deploy/log:/srv/log:rw \
    shmilee/lnmp:using
EOF
