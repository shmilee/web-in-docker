Docker image
============

https://github.com/shmilee/dockerfile-for-arch.git

Build mynginx(lnmp+cgit), initialize the MariaDB data directory and set mysql root passwd.

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

configure systemd service
==========================

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
