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

echo "==> v2ray-deploy/{test.sh,run.sh}"

cat <<'EOF' | sed "s|{{port1}}|$port|g" > v2ray-deploy/test.sh
#!/bin/bash
docker run --rm --name nginx_v2ray \
    -p 80:80 -p 443:443 -p {{port1}}:{{port1}} \
    -v $PWD/etc:/srv/etc:ro \
    -v $PWD/v2ray-server-config.json:/etc/v2ray/config.json:ro \
    -v $PWD/log:/srv/log:rw \
    shmilee/v2ray:${1:-using}
EOF
sed 's|--rm|--detach --restart=always|'  v2ray-deploy/test.sh > v2ray-deploy/run.sh
chmod +x v2ray-deploy/{test.sh,run.sh}

echo "==> Done."
cat <<'EOF'

1. Put dhparam.pem server-v2ray.{crt,key} in v2ray-deploy/etc/ssl-certs
   Test nginx and v2ray
   $ cd  v2ray-deploy/
   $ ./test.sh [v2ray-image-tag]

2. If containers run scucessfully, Run './run.sh [v2ray-image-tag]'
EOF
