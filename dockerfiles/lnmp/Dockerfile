# mynginx + mariadb(mysql) + php + (fcgi+cgit+git+ssh)
#
# Use monit to manage multiple processes
#
# py3 docutils, pygments, markdown for cgit
#
# docker build --force-rm --no-cache --rm -t shmilee/lnmp:$(date +%y%m%d) .
# docker tag shmilee/lnmp:$(date +%y%m%d) shmilee/lnmp:using
#
# etc/{monitrc,nginx.conf,cgitrc,php.ini,php-fpm.conf}: /srv/etc ro
# http_files: /srv/http rw
# log: /srv/log rw
# docker run --rm -p 80:80 -p 443:443 -v $PWD/etc:/srv/etc:ro -v $PWD/http_files:/srv/http:rw \
#   -v $PWD/log:/srv/log:rw shmilee/lnmp:$(date +%y%m%d)
#

FROM alpine:3.5
MAINTAINER shmilee <shmilee.zju@gmail.com>

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    CGIT_CONFIG=/srv/etc/cgit/cgitrc \
    TERM=xterm-color

ADD ./monit_init.sh /usr/bin/monit_init.sh

# Add my repository
COPY ./*@*.rsa.pub /etc/apk/keys/
RUN echo http://shmilee.io/repo-shmilee/alpine-v3.5/shmilee > /etc/apk/repositories

RUN echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.5/main >> /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.5/community >> /etc/apk/repositories \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -h /srv/http -G www-data -g www-data www-data \
 && echo "==> tini monit nginx mariadb php ..." \
 && apk --no-cache add coreutils bash nano tzdata ca-certificates openssl \
        tini monit iproute2 \
        mynginx mynginx-meta-small-modules \
        mariadb mariadb-client \
        php7-apcu php7-bcmath php7-bz2 php7-ctype php7-curl php7-dom php7-fpm \
        php7-gd php7-gettext php7-iconv php7-imap php7-intl php7-json \
        php7-mbstring php7-mcrypt php7-memcached php7-mysqli php7-openssl \
        php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-soap php7-sqlite3 \
        php7-xmlreader php7-xmlrpc php7-zip php7-zlib \
 && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && echo "${TIMEZONE}" > /etc/timezone \
 && install -d -m755 /run/php-fpm \
 && echo "==> fcgi cgit git ssh ..." \
 && adduser -D -s /usr/bin/git-shell -H -h /srv/project -G users -g users -u 1000 git \
 && echo git:1234567890 | chpasswd \
 && apk --no-cache add spawn-fcgi fcgiwrap \
        cgit py3-docutils py3-pygments py3-markdown \
        git openssh \
 && echo "==> clean ..." \
 && find /usr/share/terminfo/ -type f -not \( -name 'ansi' -o -name 'dumb' -o -name 'linux' \
        -o -name 'vt100' -o -name 'vt220' -o -name 'xterm' \) -exec rm {} \; \
 && chmod +x /usr/bin/monit_init.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["monit_init.sh", "5"]
