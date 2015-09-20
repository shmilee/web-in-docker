#!/bin/bash

[ -d deploy ] && rm -r deploy/

mkdir deploy

echo "==> copy files ..."
cp -r etc root_files deploy/
chmod 777 -R deploy/root_files/upload/

echo "==> build nbviewer ..."
nbviewer_commit=$(sed -n "/commit=/ s/.*commit='\(.*\)' &&.*/\1/ p"  Dockerfile-nginx-arc)
bash ./build_nbviewer.sh ${nbviewer_commit}
tar zxf ./build_nbviewer/nbviewer-${nbviewer_commit:0:7}.tar.gz -C deploy/root_files/

echo "==> prepare a hashed password for jupyter notebook ..."
sha1_passwd=$(ipython -c 'from IPython.lib import passwd;passwd()')
sha1_passwd=${sha1_passwd/#*\'sha1/\'sha1}
sed -i "s|'sha1:yourpasswd'|$sha1_passwd|" deploy/etc/ipynb_config.py

echo "==> log dir ..."
mkdir deploy/log

echo "==> Done."
