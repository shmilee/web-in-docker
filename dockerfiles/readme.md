Build Docker image
==================

shmilee/abuild:3.5 (190M)
-------------------------

Alpine Docker image for building Alpine Linux packages.

Generate a public/private rsa key pair placed in `abuild/abuild-key/`,
edit `PACKAGER_PRIVKEY` in `abuild/abuild-key/abuild.conf`.

```
privkey=./abuild/abuild-key/youremail@gmail.com.rsa
pubkey="$privkey.pub"
# generate the private key in a subshell with stricter umask
(
umask 0007
openssl genrsa -out "$privkey" 2048
)
openssl rsa -in "$privkey" -pubout -out "$pubkey"
```

### build image

This will add public rsa key to the image `/etc/apk/keys/`.

```
cd ./abuild/
docker build --force-rm --no-cache --rm -t shmilee/abuild:3.5 .
cd ../
```

### build packages

Change `REPODEST_DIR` to yours.
For mine, it's URL is `http://shmilee.io/repo-shmilee/alpine-v3.5/`

```
KEY_DIR=$PWD/abuild/abuild-key
APORTS_DIR=$PWD/abuild/aports
REPODEST_DIR=/home/WebData/repo-shmilee/alpine-v3.5
docker run --rm -t -i \
    -v ${KEY_DIR}:/home/builder/.abuild \
    -v ${APORTS_DIR}:/home/builder/aports \
    -v ${REPODEST_DIR}:/home/builder/packages \
    shmilee/abuild:3.5
```

__The following COMMANDs is in docker CONTAINER!__

```
sudo apk update
cd /home/builder/aports/shmilee/php7-memcached/
abuild -r
cd /home/builder/aports/shmilee/sregex/
abuild -r
sudo apk update
cd /home/builder/aports/shmilee/mynginx/
abuild -r
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


__OLD__

arch base
----------

```
cd arch/
sudo ./mktar-miniarch.sh
cat arch-$(date +%y%m).tar.xz | docker import - shmilee/arch:$(date +%y%m)
```
