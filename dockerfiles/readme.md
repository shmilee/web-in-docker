Build Docker image
==================

arch base
----------

```
cd dockerfiles/
sudo ./mktar-miniarch.sh
cat arch-$(date +%y%m).tar.xz | docker import - arch:$(date +%y%m)
```

nikola
--------

```
sed -i "s/FROM arch:1607/FROM arch:$(date +%y%m)/" Dockerfile-nikola
nkl_Ver=?.?.?
docker build --force-rm --no-cache --rm -f Dockerfile-nikola -t nikola:$nkl_Ver .
docker run -u 1000 --rm -p 8000:8000 -v $PWD:/blog -w /blog -t -i nikola:$nkl_Ver /usr/bin/bash
```

mynginx
--------

```
sed -i "s/FROM arch:1607/FROM arch:$(date +%y%m)/" Dockerfile-mynginx
docker build --force-rm --no-cache --rm -f Dockerfile-mynginx -t mynginx:$(date +%y%m%d) .
docker tag mynginx:$(date +%y%m%d) nginx:using

#initialize the MariaDB data directory
docker run --rm -v <host-data-dir>/mysql:/var/lib/mysql:rw nginx:using bash -c \
    'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
container_id=$(docker run -u mysql -d -v <host-data-dir>/mysql:/var/lib/mysql:rw \
    nginx:using bash -c 'mysqld --pid-file=/run/mysqld/mysqld.pid;')
docker exec -u root -i -t $container_id mysql_secure_installation
docker stop $container_id
docker rm $container_id

docker run --rm -p 80:80 -p 443:443 -v <host-data-dir>/etc:/srv/etc:ro \
    -v <host-data-dir>/http_files:/srv/http:rw \
    -v <host-data-dir>/mysql:/var/lib/mysql:rw \
    -v <host-data-dir>/log:/srv/log:rw nginx:using
```

jupyterhub notebook
-------------------

jupyterhub notebook image (numpy scipy pandas sympy matplotlib pandoc mathjax)

```
sed -i "s/FROM arch:1607/FROM arch:$(date +%y%m)/" Dockerfile-matplot-jupyterhub
docker build --force-rm --no-cache --rm -f Dockerfile-matplot-jupyterhub -t matplothub:$(date +%y%m%d) .
docker tag matplothub:$(date +%y%m%d) matplothub:using
# prepare a password in jupyterhub_config.py
```

