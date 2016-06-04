#!/bin/bash

CA_dir=./CA
CA_cnf=$CA_dir/openssl.cnf

gen_CA () {
    #CA 证书请求生成及签名
    openssl req -new -x509 -days 3650 -config $CA_cnf -keyout $CA_dir/CA.key -out $CA_dir/CA.crt
    rm -rf $CA_dir/newcerts $CA_dir/index.* $CA_dir/serial*
}

gen_server () {
    #网站证书
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out server.key
    chmod 400 server.key
    echo "==> Attention to:"
    echo " -> Organization Name"
    echo " -> Common Name"
    echo " -> Other Common Name"
    openssl req -new -sha256 -config $CA_cnf -key server.key -out server.csr
}

sign_by_CA () {
    #如果在执行签名命令时，出现“I am unable to access the ./CA/newcerts directory”
    #修改./CA/openssl.cnf中“dir = ./CA”
    #然后：
    [ -d $CA_dir/newcerts ]  || mkdir -p $CA_dir/newcerts
    [ -f $CA_dir/index.txt ] || > $CA_dir/index.txt
    [ -f $CA_dir/serial ]    || echo '01' > $CA_dir/serial
    #再重新签名
    openssl ca -policy policy_anything -days 1950 -config $CA_cnf\
        -cert $CA_dir/CA.crt -keyfile $CA_dir/CA.key \
        -in server.csr -out server.crt
    #policy参数允许签名的CA和网站证书可以有不同的国家、地名等信息
    echo "==> Done."
}

if [ ! -f $CA_dir/CA.key -o ! -f $CA_dir/CA.crt ]; then
    echo "==> No CA.key CA.crt. Generating new one ..."
    gen_CA
fi
if [ ! -f server.key -o ! -f server.csr ]; then
    echo "==> Generating server.key server.csr ..."
    gen_server
fi
echo "==> Sign server.csr with CA ..."
sign_by_CA
