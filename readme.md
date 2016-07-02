Status preview
==============

Monit's web interface:

![monit](https://raw.githubusercontent.com/shmilee/web-in-docker/master/monit-works.png)


Docker image
============

./dockerfiles/readme.md

Build mynginx image, matplothub image.

nbviewer
========

```
nbviewer_commit='0bf9258c078c4b09eec914172d10524e644cdb4e'
sh ./build_nbviewer.sh ${nbviewer_commit}
```

owncloud
========

* `oc-perms.sh <owncloud-path>`

* etc/nginx-owncloud.conf

* create database in MariaDB

ssl certificate
===============

```
sh ./gen-crt.sh
```

configurations
==============

* etc/
    - monitrc
    - nginx.conf
    - cgitrc     
    - cgitrepos
    - php.ini
    - php-fpm.conf
* log/
* root_files
* ...

systemd service
================

examples:

* service/matplothub.service
* service/mynginx.service
* service/kiwix-serve.service

Deploy
======

```
sh ./deploy.sh
```
