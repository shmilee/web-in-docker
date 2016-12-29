# nginx + mariadb(mysql) + php + (fcgi+cgit) + ssh + mathjax
#
# Use community/monit to manage multiple processes
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

FROM shmilee/arch:1612
MAINTAINER shmilee <shmilee.zju@gmail.com>

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 CGIT_CONFIG=/srv/etc/cgitrc

ADD ./monit_init.sh /usr/bin/monit_init.sh
RUN echo "==> tini monit nginx mariadb php cgit fcgi ssh ..." \
    && packages=(tini monit iproute2 \
        mynginx gd sregex luajit\
        mynginx-passenger \
        mariadb \
        php-fpm php-intl php-mcrypt php-gd php-sqlite php-imap php-apcu php-memcached \
        cgit spawn-fcgi fcgiwrap python-docutils python-pygments python-markdown mime-types \
        openssh \
        mathjax) \
    && pacman -Sy --noconfirm --assume-installed systemd ${packages[@]} \
    && install -d -m755 /run/php-fpm \
    && echo "==> clean ..." \
    && find /usr/lib/python3* \
		    \( -type d -a -name test -o -name tests \) \
		    -exec rm -rf '{}' + ; \
    rm -rf /usr/share/{man/*,doc/*,gtk-doc/,info/} /{root/,tmp/} \
    && rm -rf /etc/udev/ /usr/lib/udev/ \
    && rm -rf /etc/systemd/ /usr/lib/systemd/ /usr/bin/system* \
    && rm -rf /usr/share/zsh/ /usr/share/X11/locale/ \
    && install -d -m1777 /tmp \
    && install -d -m0750 /root \
    && rm -r /var/cache/pacman/pkg/* \
    && rm -r /var/lib/pacman/sync/* \
    && chmod +x /usr/bin/monit_init.sh

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["monit_init.sh", "5"]
