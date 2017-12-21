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
   23 root       0:01 {php-fpm7} php-fpm: master process (/srv/etc/php-fpm7.con
   24 nobody     0:00 {php-fpm7} php-fpm: pool www
   25 nobody     0:00 {php-fpm7} php-fpm: pool www
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
        |-php-fpm7(23)-+-php-fpm7(24)
        |              `-php-fpm7(25)
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
│ php-fpm7                        │ Running                    │ Process       │
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
│ openwrt                         │ Online with all services   │ Remote Host   │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ ap0                             │ Online with all services   │ Remote Host   │
├─────────────────────────────────┼────────────────────────────┼───────────────┤
│ eth0                            │ UP                         │ Network       │
└─────────────────────────────────┴────────────────────────────┴───────────────┘
```

MyNGINX APKBUILD
================

In Alpine Docker image `shmilee/abuild:3.7`,
[build package](./dockerfiles/readme.md#build-packages):

The packages:

```
mynginx-1.12.2-r0.apk
mynginx-doc-1.12.2-r0.apk
mynginx-meta-buildin-modules-1.12.2-r0.apk
mynginx-meta-github-modules-1.12.2-r0.apk
mynginx-meta-small-modules-1.12.2-r0.apk
mynginx-mod-accounting-1.12.2_3c13f62-r0.apk
mynginx-mod-array-var-1.12.2_0.05-r0.apk
mynginx-mod-auth-pam-1.12.2_1.5.1-r0.apk
mynginx-mod-auth-spnego-1.12.2_7e028a5-r0.apk
mynginx-mod-cache-purge-1.12.2_2.3-r0.apk
mynginx-mod-concat-1.12.2_b8d3e7e-r0.apk
mynginx-mod-devel-kit-1.12.2_0.3.0-r0.apk
mynginx-mod-dynamic-upstream-1.12.2_0.1.6-r0.apk
mynginx-mod-echo-1.12.2_0.61-r0.apk
mynginx-mod-encrypted-session-1.12.2_0.07-r0.apk
mynginx-mod-enhanced-memcached-1.12.2_a9b76b6-r0.apk
mynginx-mod-eval-1.12.2_2016.06.10-r0.apk
mynginx-mod-fancyindex-1.12.2_0.4.2-r0.apk
mynginx-mod-form-input-1.12.2_0.12-r0.apk
mynginx-mod-geoip-1.12.2-r0.apk
mynginx-mod-geoip2-1.12.2_2.0-r0.apk
mynginx-mod-google-filter-1.12.2_0.2.0-r0.apk
mynginx-mod-headers-more-filter-1.12.2_0.33-r0.apk
mynginx-mod-http-upsync-1.12.2_586f878-r0.apk
mynginx-mod-iconv-1.12.2_0.14-r0.apk
mynginx-mod-image-filter-1.12.2-r0.apk
mynginx-mod-lua-1.12.2_0.10.12rc1-r0.apk
mynginx-mod-lua-upstream-1.12.2_0.07-r0.apk
mynginx-mod-mail-1.12.2-r0.apk
mynginx-mod-memc-1.12.2_0.18-r0.apk
mynginx-mod-naxsi-1.12.2_0.55.3-r0.apk
mynginx-mod-nchan-1.12.2_1.1.13-r0.apk
mynginx-mod-passenger-1.12.2_5.1.12-r0.apk
mynginx-mod-perl-1.12.2-r0.apk
mynginx-mod-push-stream-1.12.2_0.5.4-r0.apk
mynginx-mod-rdns-1.12.2_a32deec-r0.apk
mynginx-mod-redis2-1.12.2_0.14-r0.apk
mynginx-mod-replace-filter-1.12.2_99b7fa6-r0.apk
mynginx-mod-rtmp-1.12.2_21db986-r0.apk
mynginx-mod-rtmpt-proxy-1.12.2_5f3bb0c-r0.apk
mynginx-mod-set-misc-1.12.2_0.31-r0.apk
mynginx-mod-shibboleth-1.12.2_2.0.1-r0.apk
mynginx-mod-sorted-querystring-1.12.2_0.3-r0.apk
mynginx-mod-srcache-filter-1.12.2_0.31-r0.apk
mynginx-mod-stream-1.12.2-r0.apk
mynginx-mod-stream-upsync-1.12.2_c4fed88-r0.apk
mynginx-mod-subs-filter-1.12.2_bc58cb1-r0.apk
mynginx-mod-testcookie-access-1.12.2_fa4ecc7-r0.apk
mynginx-mod-uploadprogress-1.12.2_afb2d31-r0.apk
mynginx-mod-upstream-fair-1.12.2_a18b409-r0.apk
mynginx-mod-vhost-traffic-status-1.12.2_0.1.15-r0.apk
mynginx-mod-xslt-filter-1.12.2-r0.apk
mynginx-vim-1.12.2-r0.apk
```

The nginx dynamic modules:

```shell
$ ls /usr/lib/mynginx/modules                                                           :) 0
ndk_http_module.so			ngx_http_push_stream_module.so
ngx_dynamic_upstream_module.so		ngx_http_rdns_module.so
ngx_http_accounting_module.so		ngx_http_redis2_module.so
ngx_http_array_var_module.so		ngx_http_replace_filter_module.so
ngx_http_auth_pam_module.so		ngx_http_set_misc_module.so
ngx_http_cache_purge_module.so		ngx_http_shibboleth_module.so
ngx_http_concat_module.so		ngx_http_sorted_querystring_module.so
ngx_http_echo_module.so			ngx_http_srcache_filter_module.so
ngx_http_encrypted_session_module.so	ngx_http_subs_filter_module.so
ngx_http_enhanced_memcached_module.so	ngx_http_testcookie_access_module.so
ngx_http_eval_module.so			ngx_http_uploadprogress_module.so
ngx_http_fancyindex_module.so		ngx_http_upstream_fair_module.so
ngx_http_form_input_module.so		ngx_http_upsync_module.so
ngx_http_geoip2_module.so		ngx_http_vhost_traffic_status_module.so
ngx_http_geoip_module.so		ngx_mail_module.so
ngx_http_google_filter_module.so	ngx_nchan_module.so
ngx_http_headers_more_filter_module.so	ngx_rtmp_module.so
ngx_http_iconv_module.so		ngx_rtmpt_proxy_module.so
ngx_http_lua_module.so			ngx_stream_geoip2_module.so
ngx_http_lua_upstream_module.so		ngx_stream_module.so
ngx_http_memc_module.so			ngx_stream_upsync_module.so
ngx_http_naxsi_module.so

$ ls /etc/mynginx/modules/available                                                     :) 0
0-accounting.conf	    0-replace-filter.conf
0-auth-pam.conf		    0-rtmp.conf
0-cache-purge.conf	    0-rtmpt-proxy.conf
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
shmilee/jupyterhub   171221              f77c62b8c5b8        20 minutes ago      384MB
shmilee/jupyterhub   using               f77c62b8c5b8        20 minutes ago      384MB
shmilee/lnmp         171221              840e22c79a94        2 hours ago         353MB
shmilee/lnmp         using               840e22c79a94        2 hours ago         353MB
shmilee/abuild       3.7                 e3da3f7eba06        9 hours ago         187MB
alpine               3.7                 e21c333399e0        2 weeks ago         4.14MB
```

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
    - php-fpm7.conf
* log/
* root_files
* ...

systemd service
================

examples:

* service/matplothub.service
* service/lnmp.service
* service/lnmpssh.service

