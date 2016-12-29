Build Docker image
==================

arch base
----------

```
cd arch/
sudo ./mktar-miniarch.sh
cat arch-$(date +%y%m).tar.xz | docker import - shmilee/arch:$(date +%y%m)
```

shmilee/lnmp
------------

```
cd lnmp/
sed -i "s|FROM shmilee/arch:....|FROM shmilee/arch:$(date +%y%m)|" Dockerfile
docker build --force-rm --no-cache --rm -t shmilee/lnmp:$(date +%y%m%d) .
docker tag shmilee/lnmp:$(date +%y%m%d) shmilee/lnmp:using

#initialize the MariaDB data directory
docker run --rm -v <host-data-dir>/mysql:/var/lib/mysql:rw shmilee/lnmp:using bash -c \
    'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
container_id=$(docker run -u mysql -d -v <host-data-dir>/mysql:/var/lib/mysql:rw \
    shmilee/lnmp:using bash -c 'mysqld --pid-file=/run/mysqld/mysqld.pid;')
docker exec -u root -i -t $container_id mysql_secure_installation
docker stop $container_id
docker rm $container_id

docker run --rm -p 80:80 -p 443:443 -v <host-data-dir>/etc:/srv/etc:ro \
    -v <host-data-dir>/http_files:/srv/http:rw \
    -v <host-data-dir>/mysql:/var/lib/mysql:rw \
    -v <host-data-dir>/log:/srv/log:rw shmilee/lnmp:using
```

shmilee/matplothub
------------------

jupyterhub notebook image (numpy scipy pandas sympy matplotlib pandoc mathjax)

```
cd matplothub/
sed -i "s|FROM shmilee/arch:....|FROM shmilee/arch:$(date +%y%m)|" Dockerfile
docker build --force-rm --no-cache --rm -t shmilee/matplothub:$(date +%y%m%d) .
docker tag shmilee/matplothub:$(date +%y%m%d) shmilee/matplothub:using
# prepare a password in jupyterhub_config.py
```

