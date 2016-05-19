Docker image
============

https://github.com/shmilee/dockerfile-for-arch.git

Build mynginx(lnmp+cgit), initialize the MariaDB data directory and set mysql root passwd.

Build matplot(jupyter-notebook).

nbviewer
========

```
nbviewer_commit='0bf9258c078c4b09eec914172d10524e644cdb4e'
sh ./build_nbviewer.sh ${nbviewer_commit}
```

Other configurations
====================

* etc/
    - supervisord.conf
    - nginx.conf
    - nginx- .conf
    - cgitrc     
    - cgitrepos
    - php.ini
    - php-fpm.conf
* log/
* root_files
* project
* repo-shmilee
* IFTS_shmilee
* ...

Deploy
======

deploy.sh

systemd service
================

mynginx:

```
Environment='WebData=/my/WebData'
ExecStart=/usr/bin/docker run --rm -p 80:80 -p 808:808 \
    -v ${WebData}/etc:/srv/etc:ro \
    -v ${WebData}/log:/srv/log:rw \
    -v ${WebData}/mysql:/var/lib/mysql:rw \
    -v ${WebData}/root_files:/srv/http:rw \
    -v ${WebData}/project:/srv/project:ro \
    -v ${WebData}/repo-shmilee:/srv/repo-shmilee:ro \
    -v /home/IFTS_shmilee:/srv/http/upload/IFTS_shmilee:ro \
    --name mynginx_server nginx:using
```

matplot:

```
Environment='WebData=/home/WebData'
ExecStart=/usr/bin/docker run -d -p 8888:8888 \
    -v ${WebData}/etc/jupyter:/workdir/config \
    -v /home/IFTS_shmilee/notebook:/workdir/notebook \
    --name matplot_server matplot:using
```

kiwix-serve: `pacman -S kiwix-bin`

```
ExecStart=/usr/lib/kiwix/bin/kiwix-serve --library --port=8080 /home/WebData/kiwix-data/library.xml
User=nobody
```

owncloud
========

* `oc-perms.sh <owncloud-path>`

* etc/nginx-owncloud.conf

* create database in MariaDB
