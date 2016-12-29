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
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0   4188   640 ?        Ss   Jul02   0:01 /usr/bin/tini -
root         6  0.1  0.1 104960  6496 ?        Sl   Jul02   0:57 /usr/bin/monit 
root        15  0.0  0.0  47912  1332 ?        Ss   Jul02   0:00 nginx: master p
http        16  0.0  0.2  50500  9500 ?        S    Jul02   0:30 nginx: worker p
http        17  0.0  0.3  55960 14956 ?        S    Jul02   0:32 nginx: worker p
root        19  0.0  0.2 240860 11324 ?        Ss   Jul02   0:01 php-fpm: master
http        20  0.0  0.3 241052 15840 ?        S    Jul02   0:00 php-fpm: pool w
http        21  0.0  0.3 241052 15840 ?        S    Jul02   0:00 php-fpm: pool w
http        23  0.0  0.0  30108  2408 ?        Ss   Jul02   0:00 /bin/fcgiwrap
nbviewer    25  0.0  1.0 168136 42396 ?        S    Jul02   0:14 python -m nbvie
root       151  0.0  0.0  36360  3236 ?        Rs+  14:25   0:00 ps aux

$ docker exec -t lnmp_server pstree -p                                          :) 0
tini(1)─┬─fcgiwrap(23)
        ├─monit(6)───{monit}(135)
        ├─nginx(15)─┬─nginx(16)
        │           └─nginx(17)
        ├─php-fpm(19)─┬─php-fpm(20)
        │             └─php-fpm(21)
        └─python(25)

$ docker exec -t lnmp_server monit -c /srv/etc/monitrc summary                  :) 0
Monit uptime: 16h 0m
 Service Name                     Status                      Type          
 d64b2b871998                     Running                     System        
 nginx                            Running                     Process       
 php-fpm                          Running                     Process       
 fcgiwrap                         Running                     Process       
 nbviewer                         Running                     Process       
 server_key                       Accessible                  File          
 shadow                           Accessible                  File          
 srv                              Accessible                  Filesystem    
 9201z                            Online with all services    Remote Host   
 openwrt                          Online with all services    Remote Host   
 ap0                              Online with all services    Remote Host   
 eth0                             UP                          Network       
```

NGINX PKGBUILD
==============

In Arch Linux, build package:

```shell
cd ./mynginx/
yaourt -S libmaxminddb sregex-git
makepkg -s
```
The packages:

```
mynginx/1.10.2-5:mynginx-1.10.2-5-i686.pkg.tar.xz
mynginx/1.10.2-5:mynginx-1.10.2-5-x86_64.pkg.tar.xz
mynginx/1.10.2-5:mynginx-pagespeed-1.10.2_1.11.33.2-5-i686.pkg.tar.xz
mynginx/1.10.2-5:mynginx-pagespeed-1.10.2_1.11.33.2-5-x86_64.pkg.tar.xz
mynginx/1.10.2-5:mynginx-passenger-1.10.2_5.0.30-5-i686.pkg.tar.xz
mynginx/1.10.2-5:mynginx-passenger-1.10.2_5.0.30-5-x86_64.pkg.tar.xz
```

The nginx dynamic modules:

```shell
$ ls /usr/lib/nginx/modules                                                           :) 0
ndk_http_module.so                      ngx_http_push_stream_module.so
ngx_dynamic_upstream_module.so          ngx_http_rdns_module.so
ngx_http_accounting_module.so           ngx_http_redis2_module.so
ngx_http_array_var_module.so            ngx_http_replace_filter_module.so
ngx_http_auth_pam_module.so             ngx_http_set_misc_module.so
ngx_http_auth_spnego_module.so          ngx_http_shibboleth_module.so
ngx_http_cache_purge_module.so          ngx_http_small_light_module.so
ngx_http_concat_module.so               ngx_http_sorted_querystring_module.so
ngx_http_echo_module.so                 ngx_http_srcache_filter_module.so
ngx_http_encrypted_session_module.so    ngx_http_ssl_ct_module.so
ngx_http_enhanced_memcached_module.so   ngx_http_subs_filter_module.so
ngx_http_eval_module.so                 ngx_http_testcookie_access_module.so
ngx_http_fancyindex_module.so           ngx_http_uploadprogress_module.so
ngx_http_form_input_module.so           ngx_http_upstream_fair_module.so
ngx_http_geoip2_module.so               ngx_http_upsync_module.so
ngx_http_geoip_module.so                ngx_http_vhost_traffic_status_module.so
ngx_http_google_filter_module.so        ngx_http_xslt_filter_module.so
ngx_http_headers_more_filter_module.so  ngx_mail_ssl_ct_module.so
ngx_http_iconv_module.so                ngx_nchan_module.so
ngx_http_image_filter_module.so         ngx_pagespeed.so
ngx_http_lua_module.so                  ngx_rtmp_module.so
ngx_http_lua_upstream_module.so         ngx_rtmpt_proxy_module.so
ngx_http_memc_module.so                 ngx_ssl_ct_module.so
ngx_http_naxsi_module.so                ngx_stream_ssl_ct_module.so
ngx_http_passenger_module.so            ngx_stream_upsync_module.so

$ ls /etc/nginx/modules/available                                                     :) 0
0-accounting.conf           0-naxsi.conf               0-stream_upsync.conf
0-auth_pam.conf             0-nchan.conf               0-subs_filter.conf
0-auth_spnego.conf          0-ndk.conf                 0-testcookie_access.conf
0-cache_purge.conf          0-pagespeed.conf           0-uploadprogress.conf
0-concat.conf               0-passenger.conf           0-upstream_fair.conf
0-dynamic_upstream.conf     0-push_stream.conf         0-vhost_traffic_status.conf
0-echo.conf                 0-rdns.conf                0-xslt_filter.conf
0-enhanced_memcached.conf   0-redis2.conf              1-ndk-array_var.conf
0-eval.conf                 0-replace_filter.conf      1-ndk-encrypted_session.conf
0-fancyindex.conf           0-rtmp.conf                1-ndk-form_input.conf
0-geoip2.conf               0-rtmpt_proxy.conf         1-ndk-iconv.conf
0-geoip.conf                0-shibboleth.conf          1-ndk-lua.conf
0-headers_more_filter.conf  0-small_light.conf         1-ndk-lua_upstream.conf
0-http_upsync.conf          0-sorted_querystring.conf  1-ndk-set_misc.conf
0-image_filter.conf         0-srcache_filter.conf      1-subs_filter-google_filter.conf
0-memc.conf                 0-ssl_ct.conf
```

Notes:

1. `1-ndk-lua.conf` means module `lua` depends on module `ndk`.

2. `passenger` demos config: `./mynginx/passenger-demos`

3. Now `ngx_cache_purge` honors `server_tokens off;`.


Docker image
============

./dockerfiles/readme.md

Build lnmp image, matplothub image.

```shell
$ docker images                                                                       :) 0
REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
shmilee/matplothub   161229              f756e139bc6d        2 hours ago         683.8 MB
shmilee/matplothub   using               f756e139bc6d        2 hours ago         683.8 MB
shmilee/lnmp         161229              4ac8c4ac7331        2 hours ago         671.2 MB
shmilee/lnmp         using               4ac8c4ac7331        2 hours ago         671.2 MB
shmilee/arch         1612                1b5aceb3ef3f        3 hours ago         252.2 MB
```

TODO: Arch Linux -> Alpine Linux

owncloud
========

* `other_tools/oc-perms.sh <owncloud-path>`

* etc/sites-disabled/nginx-owncloud.vhost

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
* service/lnmp.service
* service/lnmpssh.service

Deploy
======

```
sh ./deploy.sh
```
