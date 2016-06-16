#!/bin/bash

CA_dir=./CA
CA_cnf=$CA_dir/openssl.cnf
bonus=${1:-subCA}

gen_CA () {
    #CA 证书请求生成及签名
    openssl req -new -x509 -days 3650 -config $CA_cnf -keyout $CA_dir/CA.key -out $CA_dir/CA.crt
    rm -rf $CA_dir/newcerts $CA_dir/index.* $CA_dir/serial*
    mkdir -p $CA_dir/newcerts
    > $CA_dir/index.txt
    echo '01' > $CA_dir/serial
}

gen_subCA () {
    #sub CA key + req, 无需 pass phrase
    openssl genrsa -out ./$bonus.key #-des3
    openssl req -new -sha256 -config $CA_cnf -key ./$bonus.key -out ./$bonus.csr
}
sign_subCA () {
    openssl ca -policy policy_anything -days 1950 -config $CA_cnf\
        -cert $CA_dir/CA.crt -keyfile $CA_dir/CA.key -extensions v3_ca\
        -in ./$bonus.csr -out ./$bonus.crt
    cat ./$bonus.crt ./$bonus.key > ./${bonus}-all.crt
    #openssl rsa -in ./$bonus.key >> ./${bonus}-all.crt
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
    #[ -d $CA_dir/newcerts ]  || mkdir -p $CA_dir/newcerts
    #[ -f $CA_dir/index.txt ] || > $CA_dir/index.txt
    #[ -f $CA_dir/serial ]    || echo '01' > $CA_dir/serial
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

if [ $bonus != subCA ]; then
    echo "==> Generating Subordinate CA $bonus ..."
    gen_subCA
    echo "==> Sign ./$bonus.csr with Root CA ..."
    sign_subCA
fi

if [ ! -f server.key -o ! -f server.csr -o ! -f server.crt ]; then
    echo "==> Generating server.key server.csr ..."
    gen_server
    echo "==> Sign server.csr with CA ..."
    sign_by_CA
fi
