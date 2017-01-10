# use matplotlib in jupyterhub
#
# python 3
#
# docker build --force-rm --no-cache --rm -t shmilee/jupyterhub:$(date +%y%m%d) .
# docker run --rm -v $PWD/jupyterhub:/srv/jupyterhub \
#   -p 8000:8000 shmilee/jupyterhub:$(date +%y%m%d)
# configfile: $PWD/jupyterhub/jupyterhub_config.py
#
# TODO: add pandoc, openssh, iruby kernel, matlab kernel
# iruby:  usradd problem, iruby register
# matlab: glibc, bin/glnxa64/need_softwareopengl etc. Alpine is not a good platform for matlab!

FROM alpine:3.5
MAINTAINER shmilee <shmilee.zju@gmail.com>

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    TERM=xterm-color \
    PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple \
    NPM_REGISTRY=https://registry.npm.taobao.org \
    GEM_SOURCE_URI=https://gems.ruby-china.org

ADD ./jupyterhub_init.sh /usr/bin/jupyterhub_init.sh

RUN echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.5/main > /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.5/community >> /etc/apk/repositories \
 && apk --no-cache add tini bash shadow python3 libstdc++ ca-certificates openssl \
 && apk --no-cache add --virtual=build_dependencies \
        gcc \
        g++ \
        make \
        cmake \
        curl \
        musl-dev \
        python3-dev \
 && echo "==> 1) add jupyter-notebook ..." \
 && apk --no-cache add \
        py3-tornado \
        py3-jinja2 \
        py3-jsonschema \
        py3-decorator \
        py3-six \
        py3-ptyprocess \
        py3-pygments \
        py3-pexpect \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} notebook \
 && echo "==> 2) add jupyterhub ..." \
 && apk --no-cache add \
        py3-requests \
        py3-sqlalchemy \
        linux-pam \
        nodejs \
 && npm install -g configurable-http-proxy --registry="${NPM_REGISTRY}" \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} jupyterhub \
 && echo "==> 3) add numpy scipy ..." \
 && apk --no-cache add openblas libgfortran \
 && apk --no-cache add --virtual=build_scipy_dependencies \
        gfortran \
        openblas-dev \
 && ln -s /usr/include/locale.h /usr/include/xlocale.h \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} numpy scipy \
 && echo "==> 4) add sympy pandas ..." \
 && apk --no-cache add py3-dateutil \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} sympy pandas \
 && echo "==> 5) add matplotlib plotly ..." \
 && apk --no-cache add \
        py3-parsing \
        python3-tkinter \
        py3-tz \
 && apk --no-cache add --virtual=build_plot_dependencies \
        libpng-dev \
        freetype-dev \
        tk-dev \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} matplotlib plotly \
 && echo "==> clean ..." \
 && apk del --purge -r \
        build_dependencies \
        build_scipy_dependencies \
        build_plot_dependencies \
 && find /usr/lib/python3* \
		\( -type d -a -name test -o -name tests \) \
		-exec rm -rf '{}' + ; \
    find /usr/share/terminfo/ -type f -not \( -name 'ansi' -o -name 'dumb' -o -name 'linux' \
        -o -name 'vt100' -o -name 'vt220' -o -name 'xterm' \) -exec rm {} \; \
 && rm -rf /usr/share/man/ /usr/share/doc/ /root /tmp \
 && install -d -m1777 /tmp \
 && install -d -m0700 /root \
 && chmod +x /usr/bin/jupyterhub_init.sh

# && echo "==> 7) add iruby kernel ..." \
# && apk --no-cache add ruby ruby-json \
# && apk --no-cache add --virtual=build_iruby_dependencies \
#        zeromq-dev \
#        ruby-dev \
#        libtool \
#        autoconf \
#        automake \
# && gem sources --add ${GEM_SOURCE_URI} --remove https://rubygems.org/ \
# && gem install --no-user-install --no-document rbczmq iruby awesome_print \
# && rm -rf /usr/lib/ruby/gems/*/gems/rbczmq-*/ext \
# && echo "==> 8) add matlab kernel ..." \
# && apk --no-cache add ncurses5-libs libxpm libxmu libxp libxrandr \
# && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} metakernel pymatbridge matlab_kernel \
# && python3 -m matlab_kernel install \

WORKDIR /srv/jupyterhub
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["jupyterhub_init.sh", "3", "/srv/jupyterhub/jupyterhub_config.py", "none", "--no-ssl"]
