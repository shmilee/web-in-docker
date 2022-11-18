Sites enabled
==============

* nginx-main.vhost, include jupyterhub
* nginx-monit.vhost, include verynginx
* nginx-google.vhost, google mirror
* nginx-wikipedia.vhost, wikipedia mirror
* nginx-hactar.vhost, Arch Catalyst's unofficial repository mirror
* nginx-gogs.vhost, proxy gogs service

Status preview
==============

Monit's web interface:

![monit](monit-works.png)

```shell
$ docker exec -t lnmp_server ps aux
PID   USER     TIME   COMMAND
    1 root       0:01 /sbin/tini -- monit_init.sh 5
    7 root       0:17 /usr/bin/monit -c /srv/etc/monitrc
   23 root       0:01 {php-fpm8} php-fpm: master process (/srv/etc/php-fpm8.conf
   24 nobody     0:00 {php-fpm8} php-fpm: pool www
   25 nobody     0:00 {php-fpm8} php-fpm: pool www
   27 mynginx    0:00 /usr/bin/fcgiwrap
   29 root       0:00 /usr/sbin/sshd -f /srv/etc/ssh/sshd_config -E /srv/log/ss
  331 mysql      0:01 /usr/bin/mysqld --basedir=/usr --datadir=/var/lib/mysql -
  365 root       0:00 {mynginx} nginx: master process /usr/bin/mynginx -c /srv/
  366 mynginx    0:01 {mynginx} nginx: worker process
  367 mynginx    0:00 {mynginx} nginx: worker process
  368 mynginx    0:00 {mynginx} nginx: cache manager process
  459 root       0:00 bash
  519 root       0:00 ps aux

$ docker exec -t lnmp_server pstree -p                                          :) 0
tini(1)-+-fcgiwrap(27)
        |-monit(7)
        |-mynginx(365)-+-mynginx(366)
        |              |-mynginx(367)
        |              `-mynginx(368)
        |-mysqld(331)
        |-php-fpm8(23)-+-php-fpm8(24)
        |              `-php-fpm8(25)
        `-sshd(29)

$ docker exec -t lnmp_server monit -c /srv/etc/monitrc summary                  :) 0
Monit 5.22.0 uptime: 15h 20m
┌─────────────────────────────────┬────────────────────────────┬───────────────┐
│ Service Name                    │ Status                     │ Type          │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ 2677377ac807                    │ Running                    │ System        │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ mynginx                         │ Running                    │ Process       │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ php-fpm8                        │ Running                    │ Process       │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ fcgiwrap                        │ Running                    │ Process       │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ mysqld                          │ Running                    │ Process       │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ sshd                            │ Running                    │ Process       │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ server_key                      │ Accessible                 │ File          │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ shadow                          │ Accessible                 │ File          │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ srv                             │ Accessible                 │ Filesystem    │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ 9201z                           │ Online with all services   │ Remote Host   │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ ap0                             │ Online with all services   │ Remote Host   │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ eth0                            │ UP                         │ Network       │
└─────────────────────────────────┴────────────────────────────┴───────────────┘
```

MyNGINX APKBUILD
================

In Alpine Docker image `shmilee/abuild:3.16`,
[build package](./dockerfiles/readme.md#build-packages):

The packages:

```
mynginx-1.22.1-r0.apk
mynginx-doc-1.22.1-r0.apk
mynginx-meta-buildin-modules-1.22.1-r0.apk
mynginx-meta-github-modules-1.22.1-r0.apk
mynginx-meta-small-modules-1.22.1-r0.apk
mynginx-mod-accounting-1.22.1_2.0-r0.apk
mynginx-mod-array-var-1.22.1_0.05-r0.apk
mynginx-mod-auth-pam-1.22.1_1.5.3-r0.apk
mynginx-mod-auth-spnego-1.22.1_1.1.1-r0.apk
mynginx-mod-cache-purge-1.22.1_2.3-r0.apk
mynginx-mod-concat-1.22.1_b8d3e7e-r0.apk
mynginx-mod-devel-kit-1.22.1_0.3.2-r0.apk
mynginx-mod-dynamic-upstream-1.22.1_0.1.6-r0.apk
mynginx-mod-echo-1.22.1_0.63-r0.apk
mynginx-mod-encrypted-session-1.22.1_0.09-r0.apk
mynginx-mod-enhanced-memcached-1.22.1_b58a450-r0.apk
mynginx-mod-eval-1.22.1_2016.06.10-r0.apk
mynginx-mod-fancyindex-1.22.1_0.5.2-r0.apk
mynginx-mod-form-input-1.22.1_0.12-r0.apk
mynginx-mod-geoip-1.22.1-r0.apk
mynginx-mod-geoip2-1.22.1_3.4-r0.apk
mynginx-mod-google-filter-1.22.1_0.2.0-r0.apk
mynginx-mod-headers-more-filter-1.22.1_0.34-r0.apk
mynginx-mod-http-upsync-1.22.1_2.1.3-r0.apk
mynginx-mod-iconv-1.22.1_0.14-r0.apk
mynginx-mod-image-filter-1.22.1-r0.apk
mynginx-mod-lua-1.22.1_0.10.14-r0.apk
mynginx-mod-lua-upstream-1.22.1_0.07-r0.apk
mynginx-mod-mail-1.22.1-r0.apk
mynginx-mod-memc-1.22.1_0.19-r0.apk
mynginx-mod-naxsi-1.22.1_1.3-r0.apk
mynginx-mod-nchan-1.22.1_1.3.5-r0.apk
mynginx-mod-passenger-1.22.1_5.3.7-r0.apk
mynginx-mod-perl-1.22.1-r0.apk
mynginx-mod-push-stream-1.22.1_0.5.5-r0.apk
mynginx-mod-rdns-1.22.1_f1d00ad-r0.apk
mynginx-mod-redis2-1.22.1_0.15-r0.apk
mynginx-mod-replace-filter-1.22.1_a93c665-r0.apk
mynginx-mod-rtmp-1.22.1_8e344d7-r0.apk
mynginx-mod-set-misc-1.22.1_0.33-r0.apk
mynginx-mod-shibboleth-1.22.1_2.0.1-r0.apk
mynginx-mod-sorted-querystring-1.22.1_0.3-r0.apk
mynginx-mod-srcache-filter-1.22.1_0.32-r0.apk
mynginx-mod-stream-1.22.1-r0.apk
mynginx-mod-stream-upsync-1.22.1_1.2.2-r0.apk
mynginx-mod-subs-filter-1.22.1_e12e965-r0.apk
mynginx-mod-testcookie-access-1.22.1_64137c2-r0.apk
mynginx-mod-uploadprogress-1.22.1_68b3ab3-r0.apk
mynginx-mod-upstream-fair-1.22.1_a18b409-r0.apk
mynginx-mod-vhost-traffic-status-1.22.1_0.2.1-r0.apk
mynginx-mod-xslt-filter-1.22.1-r0.apk
mynginx-vim-1.22.1-r0.apk
```

The nginx dynamic modules:

```shell
$ ls /etc/mynginx/modules/available                                                     :) 0
0-accounting.conf	    0-replace-filter.conf
0-auth-pam.conf		    0-rtmp.conf
0-cache-purge.conf
0-concat.conf		    0-shibboleth.conf
0-devel-kit.conf	    0-sorted-querystring.conf
0-dynamic-upstream.conf     0-srcache-filter.conf
0-echo.conf		    0-stream-upsync.conf
0-enhanced-memcached.conf   0-stream.conf
0-eval.conf		    0-subs-filter.conf
0-fancyindex.conf	    0-testcookie-access.conf
0-geoip.conf		    0-uploadprogress.conf
0-geoip2.conf		    0-upstream-fair.conf
0-headers-more-filter.conf  0-vhost-traffic-status.conf
0-http-upsync.conf	    1-devel-kit_array-var.conf
0-mail.conf		    1-devel-kit_encrypted-session.conf
0-memc.conf		    1-devel-kit_form-input.conf
0-naxsi.conf		    1-devel-kit_iconv.conf
0-nchan.conf		    1-devel-kit_lua-upstream.conf
0-push-stream.conf	    1-devel-kit_lua.conf
0-rdns.conf		    1-devel-kit_set-misc.conf
0-redis2.conf		    1-subs-filter_google-filter.conf
```

Notes:

1. `1-devel-kit_lua.conf` means module `lua` depends on module `devel-kit`.

2. `passenger` demos config: `./etc/passenger-demos`

3. Now `ngx_cache_purge` honors `server_tokens off;`.


Docker image
============

./dockerfiles/readme.md

Build lnmp image, matplothub image.

```shell
$ docker images                                                                       :) 0
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
shmilee/jupyterhub   xxxxxx              5e49f5c21f04        4 days ago          628MB
shmilee/jupyterhub   using               5e49f5c21f04        4 days ago          628MB
shmilee/lnmp         xxxxxx              e94b2c17e63f        4 days ago          312MB
shmilee/lnmp         using               e94b2c17e63f        4 days ago          312MB
shmilee/abuild       x.x                 0f88e4cd7228        4 days ago          215MB
alpine               x.x                 bfe296a52501        6 days ago          5.54MB
```

owncloud
========

* `other_tools/oc-perms.sh <owncloud-path>`

* etc/sites-disabled/nginx-owncloud.vhost

* create database in MariaDB

ssl certificate
===============

```
cd ./other_tools/gen-CA-crt
sh ./gen-crt.sh [server|subCA] [outname]
```

configurations
==============

* etc/
    - monitrc
    - nginx.conf
    - cgitrc     
    - cgitrepos
    - php.ini
    - php-fpm8.conf
* log/
* root_files
* ...

systemd service
================

examples:

* service/matplothub.service
* service/lnmp.service
* service/lnmpssh.service
