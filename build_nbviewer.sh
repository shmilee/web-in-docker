#!/bin/bash
depends=(wget unzip npm invoke)

commit=${1:-000}
rm_google_analytics=yes

if [ $commit == 000 ]; then
    echo "usage: $0 <commit_id in dockerfile>"
    exit 0
fi

[ -d build_nbviewer ] || mkdir build_nbviewer
cd build_nbviewer

echo "==> check commit_id ..."
if curl https://raw.githubusercontent.com/jupyter/nbviewer/${commit}/requirements.txt \
    -o ${commit}-requirements.txt; then
    echo "==> OK."
    echo "==> check requirements ..."
    if curl https://raw.githubusercontent.com/jupyter/nbviewer/master/requirements.txt \
        -o master-requirements.txt;then
        if diff -Nur ${commit}-requirements.txt master-requirements.txt; then
            echo "==> Changing to latest commit ..."
            old_commit=${commit}
            commit='master'
        else
            echo "==> New docker image needed, if you want to use latest nbviewer."
        fi
    else
        echo "==> Failed to get latest requirements.txt"
    fi
else
    echo "==> Invalid id."
    exit 1
fi

if [ -f nbviewer-${commit:0:7}.tar.gz ]; then
    echo "have built one."
    exit 0
fi
[ -f ${commit}.zip ] || wget -c https://github.com/jupyter/nbviewer/archive/${commit}.zip
[ -d nbviewer-${commit} ] && rm -r nbviewer-${commit}/
unzip ${commit}.zip

cd nbviewer-${commit}
npm install . && invoke bower && invoke less
ln -s /usr/share/mathjax ./nbviewer/static/mathjax
if [[ $rm_google_analytics == yes ]]; then
    echo "==> remove google-analytics ..."
    if grep -A10 -B10 -n UA-38683231-2 ./nbviewer/templates/layout.html; then
        _line=$(grep UA-38683231-2 ./nbviewer/templates/layout.html -n|awk -F: '{print $1}')
        _ln1=$(expr $_line - 5)
        _ln2=$(expr $_line + 2)
        echo "==> from line $_ln1 to $_ln2. Check this."
        sed -i "${_ln1},${_ln2}d" ./nbviewer/templates/layout.html
    else
        echo "==> Not found the script for google-analytics."
    fi
fi
find nbviewer/static  \( -type d -a -name less -o -name scss \) -exec rm -rf '{}' +
find nbviewer/static \( -name "*.json" -o -name "*.map" -o -name "*ignore" -o -name "README.md" \) -exec rm -rf '{}' \;
find nbviewer/static/components \( -type d -a -name src -o -name source \) -exec rm -rf '{}' +
find nbviewer \( -type d -a -name test -o -name tests \) -exec rm -rf '{}' +

tar zcf ../nbviewer-${commit:0:7}.tar.gz nbviewer/
if [ $commit == 'master' ]; then
    ln -s nbviewer-${commit:0:7}.tar.gz ../nbviewer-${old_commit:0:7}.tar.gz
fi
