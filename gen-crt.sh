#!/bin/bash

gen_CA () {
    #CA 证书请求生成及签名
    openssl req -new -x509 -days 3650 -keyout ca.key -out ca.crt
}

gen_server () {
    #网站证书
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out server.key
    chmod 400 server.key
    openssl req -new -sha256 -key server.key -out server.csr
}

sign_by_CA () {
    #policy参数允许签名的CA和网站证书可以有不同的国家、地名等信息
    if openssl ca -policy policy_anything -days 1950 -cert ca.crt -keyfile ca.key -in server.csr -out server.crt; then
        echo "==> Done."
    else
        #如果在执行签名命令时，出现“I am unable to access the xx/newcerts directory”
        #修改/etc/ssl/openssl.cnf中“dir = ./CA”
        #然后：
        #  mkdir -p CA/newcerts
        #  touch CA/index.txt
        #  touch CA/serial
        #  echo “01″ > CA/serial
        #再重新签名
        sudo mkdir -pv /etc/ssl/newcerts
        sudo touch /etc/ssl/{index.txt,serial}
        sudo sh -c "echo '01' >/etc/ssl/serial"
        sudo openssl ca -policy policy_anything -days 1950 -cert ca.crt -keyfile ca.key -in server.csr -out server.crt
    fi
}

if [ ! -f ca.key -o ! -f ca.crt ]; then
    echo "==> No ca.key ca.crt. Generating new one ..."
    gen_CA
fi
if [ ! -f server.key -o ! -f server.csr ]; then
    echo "==> Generating server.key server.csr ..."
    gen_server
fi
echo "==> Sign server.csr with CA ..."
sign_by_CA
