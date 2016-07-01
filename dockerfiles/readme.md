BuildDocker image
=================

arch base
----------

```
git clone https://github.com/shmilee/dockerfile-for-arch.git
cd dockerfile-for-arch
sudo ./mktar-miniarch.sh
cat arch-$(date +%y%m).tar.xz | docker import - arch:$(date +%y%m)
```

nikola
--------

```
sed -i "s/FROM arch:1605/FROM arch:$(date +%y%m)/" Dockerfile-nikola
nkl_Ver=?.?.?
docker build --force-rm --no-cache --rm -f Dockerfile-nikola -t nikola:$nkl_Ver .
docker run -u 1000 --rm -p 8000:8000 -v $(pwd):/blog -w /blog -t -i nikola:$nkl_Ver /usr/bin/bash
```

mynginx
--------

```
sed -i "s/FROM arch:1605/FROM arch:$(date +%y%m)/" Dockerfile-mynginx
docker build --force-rm --no-cache --rm -f Dockerfile-mynginx -t mynginx:$(date +%y%m%d) .
docker tag mynginx:$(date +%y%m%d) nginx:using
#initialize the MariaDB data directory
docker run --rm -v <host-data-dir>/mysql:/var/lib/mysql:rw mynginx:$(date +%y%m%d) bash -c \
    'mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql'
docker run --rm -p 80:80 -p 808:808 -v $PWD/etc:/srv/etc:ro -v $PWD/http_files:/srv/http:rw \
   -v $PWD/log:/srv/log:rw mynginx:$(date +%y%m%d)
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

