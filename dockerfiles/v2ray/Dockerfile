# mynginx + v2ray
# Use monit to manage multiple processes
#
# docker build --force-rm --no-cache --rm -t shmilee/v2ray:$(date +%y%m%d) .
#

FROM alpine:3.9

LABEL maintainer="shmilee <shmilee.zju@gmail.com>" version="1.0"

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    TERM=xterm-color \
    V2RAY_LOCATION_ASSET=/etc/v2ray \
    V2RAY_VERSION=4.19.1 \
    V2RAY_ZIP_URL=https://github.com/v2ray/v2ray-core/releases/download/v%s/v2ray-linux-64.zip

ADD ./monit_init.sh /usr/bin/monit_init.sh

# Add my repository
COPY ./*@*.rsa.pub /etc/apk/keys/
RUN echo http://shmilee.io/repo-shmilee/alpine-v3.9/shmilee > /etc/apk/repositories

RUN echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.9/main >> /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.9/community >> /etc/apk/repositories \
 && addgroup -g 82 -S www-data \
 && adduser -u 82 -D -S -h /srv/http -G www-data -g www-data www-data \
 && echo "==> tini monit mynginx ..." \
 && apk --no-cache add coreutils bash nano tzdata ca-certificates openssl \
        tini monit iproute2 \
        mynginx mynginx-meta-small-modules \
 && cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
 && echo "${TIMEZONE}" > /etc/timezone \
 && echo "==> v2ray ..." \
 && mkdir /var/log/v2ray /tmp/v2r \
 && wget -P /tmp/v2r -O /tmp/v2r/v2r.zip `printf "${V2RAY_ZIP_URL}" ${V2RAY_VERSION}` \
 && unzip /tmp/v2r/v2r.zip -d /tmp/v2r/ \
 && install -Dm755 /tmp/v2r/v2ray /usr/bin/v2ray \
 && install -Dm755 /tmp/v2r/v2ctl /usr/bin/v2ctl \
 && install -Dm755 /tmp/v2r/geoip.dat ${V2RAY_LOCATION_ASSET}/geoip.dat \
 && install -Dm644 /tmp/v2r/geosite.dat ${V2RAY_LOCATION_ASSET}/geosite.dat \
 && install -Dm644 /tmp/v2r/config.json ${V2RAY_LOCATION_ASSET}/config.json \
 && echo "==> clean ..." \
 && rm -rf /tmp/v2r \
 && find /usr/share/terminfo/ -type f -not \( -name 'ansi' -o -name 'dumb' -o -name 'linux' \
        -o -name 'vt100' -o -name 'vt220' -o -name 'xterm' \) -exec rm {} \; \
 && chmod +x /usr/bin/monit_init.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["monit_init.sh", "5"]
