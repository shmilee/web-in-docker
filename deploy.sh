#!/bin/bash

[ -d deploy ] && rm -r deploy/

mkdir deploy

echo "==> copy files ..."
cp -r etc root_files deploy/
chmod 600 deploy/etc/monitrc
sudo chown 0:0 deploy/etc/monitrc
chmod 777 -R deploy/root_files/upload/

read -p "==> initialize the MariaDB data directory? [y/n]" ANSW
if [[ x$ANSW == xy ]]; then
    mkdir deploy/mysql
    sudo chown mysql:mysql deploy/mysql
    docker run --rm -v $PWD/deploy/mysql:/var/lib/mysql:rw nginx:using \
        bash -c 'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
    container_id=$(docker run -u mysql -d -v $PWD/deploy/mysql:/var/lib/mysql:rw \
        nginx:using bash -c 'mysqld --pid-file=/run/mysqld/mysqld.pid;')
    docker exec -u root -i -t $container_id mysql_secure_installation
    docker stop $container_id
    docker rm $container_id
fi

echo "==> build nbviewer ..."
nbviewer_commit=$(sed -n "/^nbviewer_commit=/ s/.*_commit='\(.*\)'/\1/ p" readme.md)
if [ ! -f ./build_nbviewer/nbviewer-${nbviewer_commit:0:7}.tar.gz ]; then
    sh ./build_nbviewer.sh ${nbviewer_commit}
fi
tar zxf ./build_nbviewer/nbviewer-${nbviewer_commit:0:7}.tar.gz -C deploy/root_files/

echo "==> log dir ..."
mkdir deploy/log

echo "==> Done."
