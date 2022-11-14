# mynginx + mariadb(mysql) + php + (fcgi+cgit+git+ssh)
#
# Use monit to manage multiple processes
#
# py3 docutils, pygments, markdown for cgit
#
# docker build --network=host --force-rm --no-cache --rm -t shmilee/lnmp:$(date +%y%m%d) .
# docker tag shmilee/lnmp:$(date +%y%m%d) shmilee/lnmp:using
#
# etc/{monitrc,nginx.conf,cgitrc,php.ini,php-fpm.conf}: /srv/etc ro
# http_files: /srv/http rw
# log: /srv/log rw
# docker run --rm -p 80:80 -p 443:443 -v $PWD/etc:/srv/etc:ro -v $PWD/http_files:/srv/http:rw \
#   -v $PWD/log:/srv/log:rw shmilee/lnmp:$(date +%y%m%d)
#

FROM alpine:3.16

LABEL maintainer="shmilee <shmilee.zju@gmail.com>" version="1.0"

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    CGIT_CONFIG=/srv/etc/cgit/cgitrc \
    TERM=xterm-color

ADD ./monit_init.sh /usr/bin/monit_init.sh

# Add my repository
COPY ./*@*.rsa.pub /etc/apk/keys/
RUN echo http://shmilee.io/repo-shmilee/alpine-v3.16/shmilee > /etc/apk/repositories

RUN echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.16/main >> /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.16/community >> /etc/apk/repositories \
 && adduser -u 88 -D -S -h /srv/http -G www-data -g www-data www-data \
 && echo "==> tini monit nginx mariadb php ..." \
 && apk --no-cache add coreutils bash nano tzdata ca-certificates openssl \
        tini monit iproute2 \
        mynginx mynginx-meta-small-modules \
        mariadb mariadb-client \
        php8-pecl-apcu php8-bcmath php8-bz2 php8-ctype php8-curl php8-dom php8-fpm \
        php8-gd php8-gettext php8-iconv php8-imap php8-intl \
        php8-mbstring php8-pecl-mcrypt php8-pecl-memcached php8-mysqli php8-openssl \
        php8-pdo php8-pdo_mysql php8-pdo_sqlite php8-soap php8-sqlite3 \
        php8-xmlreader php8-zip \
 && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && echo "${TIMEZONE}" > /etc/timezone \
 && install -d -m755 /run/php-fpm \
 && echo "==> fcgi cgit git ssh ..." \
 && adduser -D -s /usr/bin/git-shell -H -h /srv/project -G users -g users -u 1000 git \
 && echo git:1234567890 | chpasswd \
 && apk --no-cache add spawn-fcgi fcgiwrap \
        cgit py3-docutils py3-pygments py3-markdown \
        git openssh \
 && chmod +x /usr/bin/monit_init.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["monit_init.sh", "5"]
