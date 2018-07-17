#
# Alpine Docker image for building Alpine Linux packages.
# docker build --force-rm --no-cache --rm -t shmilee/abuild:3.8 .
# docker run --rm -t -i \
#   -v <package-key-dir>:/home/builder/.abuild \
#   -v <aports-dir>:/home/builder/aports \
#   -v <REPODEST-dir>:/home/builder/packages \
#   shmilee/abuild:3.8

FROM alpine:3.8

LABEL maintainer="shmilee <shmilee.zju@gmail.com>" version="1.0"

# Set environment variables.
ENV \
    REPODEST=/home/builder/packages \
    TERM=xterm-color

# Install packages.
RUN \
    echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.8/main > /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.8/community >> /etc/apk/repositories \
 && apk --no-cache add alpine-sdk coreutils bash nano wget \
 && adduser -s /bin/bash -G abuild -g "Alpine Package Builder" -u 1000 -D builder \
 && echo 'builder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && mkdir $REPODEST \
 && chown builder:abuild $REPODEST

# Add my repository
COPY ./abuild-key/*@*.rsa.pub /etc/apk/keys/
RUN echo http://shmilee.io/repo-shmilee/alpine-v3.8/shmilee >> /etc/apk/repositories

USER builder
WORKDIR /home/builder
CMD ["/bin/bash"]
