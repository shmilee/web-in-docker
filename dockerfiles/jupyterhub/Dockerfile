# python 3
# jupyterhub, jupyter-notebook:
# 1. ipykernel: py3, numpy scipy matplotlib sympy gdpy3
# 2. iruby kernel: awesome_print
#
# docker build --network=host --force-rm --no-cache --rm -t shmilee/jupyterhub:$(date +%y%m%d) .
#
# docker run --rm -v $PWD/jupyterhub:/srv/jupyterhub \
#   -p 8000:8000 shmilee/jupyterhub:$(date +%y%m%d)
# configfile: $PWD/jupyterhub/jupyterhub_config.py
#
# TODO: add pandoc

FROM alpine:3.14

LABEL maintainer="shmilee <shmilee.zju@gmail.com>" version="1.0"

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    TERM=xterm-color \
    PIP_INDEX_URL=https://mirrors.ustc.edu.cn/pypi/web/simple \
    NPM_REGISTRY=https://registry.npm.taobao.org \
    GEM_SOURCE_URI=https://gems.ruby-china.com

ADD ./jupyterhub_init.sh /usr/bin/jupyterhub_init.sh

# Add my repository
COPY ./*@*.rsa.pub /etc/apk/keys/
RUN echo http://shmilee.io/repo-shmilee/alpine-v3.14/shmilee > /etc/apk/repositories

RUN echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.14/main >> /etc/apk/repositories \
 && echo https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.14/community >> /etc/apk/repositories \
 && apk --no-cache add tini bash shadow python3 libstdc++ ca-certificates openssl openssh \
 && echo "==> 1) add jupyter-notebook ..." \
 && apk --no-cache add \
        py3-jinja2 \
        py3-jsonschema \
        py3-decorator \
        py3-six \
        py3-ptyprocess \
        py3-pygments \
        py3-pexpect \
        py3-pyzmq \
        py3-dateutil \
        py3-prompt_toolkit \
        py3-tornado \
        py3-argon2-cffi \
        py3-pip \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} \
        jupyter-client==6.1.12 \
        jupyter-console \
        notebook \
        ipywidgets \
 && echo "==> 2) add jupyterhub ..." \
 && apk --no-cache add \
        py3-requests \
        py3-sqlalchemy \
        py3-lxml \
        py3-yaml \
        py3-ruamel.yaml.clib \
        py3-mako \
        py3-idna \
        py3-cryptography \
        py3-cffi \
        linux-pam \
        nodejs \
        npm \
 && npm install -g configurable-http-proxy --registry="${NPM_REGISTRY}" \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} jupyterhub jupyter_contrib_nbextensions \
 && jupyter contrib nbextension install --system --symlink \
 && echo "==> 3) add numpy scipy matplotlib sympy gdpy3 ..." \
 && apk --no-cache add py3-numpy py3-scipy py3-matplotlib py3-pillow git \
 && pip3 --no-cache-dir install -i ${PIP_INDEX_URL} sympy gdpy3 \
 && echo "==> 4) add iruby kernel ..." \
 && apk --no-cache add ruby ruby-ffi ruby-json ruby-irb ruby-rake ruby-dev zeromq zeromq-dev \
 && gem sources --add ${GEM_SOURCE_URI} --remove https://rubygems.org/ \
 && gem install --no-user-install --no-document \
        ffi-rzmq \
        iruby \
        awesome_print \
 && echo "==> x) clean ..." \
 && pip3 freeze > /py3-requirements.txt \
 && apk --no-cache del --purge -r git npm \
 && find /usr/lib/python3* \
		\( -type d -a -name test -o -name tests \) \
		-exec rm -rf '{}' + ; \
    rm -rf /usr/share/man/ /usr/share/doc/ /root /tmp \
 && install -d -m1777 /tmp \
 && install -d -m0700 /root \
 && chmod +x /usr/bin/jupyterhub_init.sh

WORKDIR /srv/jupyterhub
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["jupyterhub_init.sh", "3", "/srv/jupyterhub/jupyterhub_config.py", "/srv/jupyterhub/hook_script", "--no-ssl"]
