# use matplotlib in jupyterhub + iruby kernel + matlab kernel
# python 3
# select pypi-index-url $PP_index
# docker build --force-rm --no-cache --rm -t shmilee/matplothub:$(date +%y%m%d) .
# docker run --rm -v $PWD/jupyterhub:/srv/jupyterhub \
#   -v /usr/local/matlab2010a:/opt/matlab -p 8000:8000 shmilee/matplothub:$(date +%y%m%d)
# configfile: $PWD/jupyterhub/jupyterhub_config.py
#

FROM shmilee/arch:1612
MAINTAINER shmilee <shmilee.zju@gmail.com>

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 PATH="/opt/matlab/bin:${PATH}"

ADD ./jupyterhub_init.sh /usr/bin/jupyterhub_init.sh
RUN PP_index='https://pypi.tuna.tsinghua.edu.cn/simple' && \
    NPM_Registry='https://registry.npm.taobao.org' && \
    packages=(tini \
        python-pip \
        ipython \
        jupyter-notebook \
        jupyter-nbconvert \
        python-numpy \
        python-scipy \
        python-pandas \
        python-sympy \
        mathjax \
        pandoc \
        python-pillow python-pyparsing  python-cycler \
        openssh \
        pkg-config freetype2 gcc \
        nodejs python-requests python-sqlalchemy npm) && \
    pacman -Sy --noconfirm ${packages[@]} && \
    npm install -g configurable-http-proxy --registry="$NPM_Registry" && \
    pip3 install -i "$PP_index" matplotlib jupyterhub plotly && \
    echo "==> add iruby kernel ..." && \
    pacman -Sy --noconfirm ruby make czmq && \
    gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/ && \
    gem install --no-user-install rbczmq iruby -- --with-system-libs && \
    echo "==> add matlab kernel ..." && \
    pacman -Sy --noconfirm ncurses5-compat-libs libxpm libxmu libxp libxrandr && \
    pip3 install -i "$PP_index" metakernel pymatbridge matlab_kernel && \
    python3 -m matlab_kernel install && \
    echo "==> clean ..." && \
    pacman -Rsn --noconfirm gcc npm make && \
    find /usr/lib/python3* \
		\( -type d -a -name test -o -name tests \) \
		-exec rm -rf '{}' + ; \
    rm -rf /usr/share/{man/*,doc/*,gtk-doc/,info/} /{root,tmp} && \
    rm -rf /usr/share/zsh/ /usr/share/X11/locale/ && \
    install -d -m1777 /tmp && \
    install -d -m0750 /root && \
    rm -r /var/cache/pacman/pkg/* && \
    rm -r /var/lib/pacman/sync/* && \
    chmod +x /usr/bin/jupyterhub_init.sh

WORKDIR /srv/jupyterhub
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["jupyterhub_init.sh", "3", "/srv/jupyterhub/jupyterhub_config.py", "none", "--no-ssl"]
