Build Docker image
==================

shmilee/abuild:3.5 (190M)
-------------------------

Alpine Docker image for building Alpine Linux packages. Based on `alpine:3.5`.

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

shmilee/lnmp (319 MB)
---------------------

Based on `alpine:3.5`.

Packages:

```
# mynginx + mariadb(mysql) + php + (fcgi+cgit)
coreutils bash nano tzdata ca-certificates openssl \
tini monit iproute2 \
mynginx mynginx-meta-small-modules \
mariadb mariadb-client \
php7-apcu php7-bcmath php7-bz2 php7-ctype php7-curl php7-dom php7-fpm \
php7-gd php7-gettext php7-iconv php7-imap php7-intl php7-json \
php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-openssl \
php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-soap php7-sqlite3 \
php7-xmlreader php7-xmlrpc php7-zip php7-zlib \
cgit spawn-fcgi fcgiwrap py3-docutils py3-pygments py3-markdown
```

### build image

Create a hard link to `./abuild/abuild-key/youremail@gmail.com.rsa.pub`
in `./lnmp/youremail@gmail.com.rsa.pub`.

```
cd ./lnmp/
ln ../abuild/abuild-key/youremail@gmail.com.rsa.pub youremail@gmail.com.rsa.pub
docker build --force-rm --no-cache --rm -t shmilee/lnmp:$(date +%y%m%d) .
docker tag shmilee/lnmp:$(date +%y%m%d) shmilee/lnmp:using
```

### initialize the MariaDB data directory

```
HOST_MYSQL_DIR=/home/WebData/mysql
mkdir $HOST_MYSQL_DIR
docker run --rm -v $HOST_MYSQL_DIR:/var/lib/mysql:rw shmilee/lnmp:using bash -c \
    'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
container_id=$(docker run -d -v $HOST_MYSQL_DIR:/var/lib/mysql:rw \
    shmilee/lnmp:using bash -c 'mysqld_safe --pid-file=/run/mysqld/mysqld.pid;')
docker exec -i -t $container_id mysql_secure_installation
docker stop $container_id
docker rm $container_id
```

### run lnmp, an example

```
WebData=/home/WebData
docker run --rm -p 80:80 -p 443:443 \
    -v ${WebData}/etc:/srv/etc:ro \
    -v ${WebData}/log:/srv/log:rw \
    -v ${WebData}/root_files:/srv/http:rw \
    -v ${WebData}/mysql:/var/lib/mysql:rw \
    --name lnmp_server shmilee/lnmp:using
```


shmilee/jupyterhub
------------------

jupyterhub notebook image based on alpine.

(numpy scipy pandas sympy matplotlib plotly)

```
cd ./jupyterhub/
docker build --force-rm --no-cache --rm -t shmilee/jupyterhub:$(date +%y%m%d) .
```

shmilee/matplothub
------------------

jupyterhub notebook image based on archlinux.

* (numpy scipy pandas sympy matplotlib plotly pandoc mathjax)
* iruby kernel
* matlab kernel (matlab2010a, matlab2014b)

build arch base image:

```
cd ./arch/
sudo ./mktar-miniarch.sh
cat arch-$(date +%y%m).tar.xz | docker import - shmilee/arch:$(date +%y%m)
```

builad matplothub image:

```
cd ../matplothub/
sed -i "s|FROM shmilee/arch:....|FROM shmilee/arch:$(date +%y%m)|" Dockerfile
docker build --force-rm --no-cache --rm -t shmilee/matplothub:$(date +%y%m%d) .
docker tag shmilee/matplothub:$(date +%y%m%d) shmilee/matplothub:using
# prepare a password in $PWD/jupyterhub/jupyterhub_config.py

docker run --rm -v $PWD/jupyterhub:/srv/jupyterhub \
   -v /usr/local/matlab2010a:/opt/matlab -p 8000:8000 shmilee/matplothub:$(date +%y%m%d)
```

