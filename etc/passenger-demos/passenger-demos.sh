#!/bin/bash

download_demos() {
# 1
if git clone --depth=1 https://github.com/phusion/passenger-ruby-rails-demo.git; then
    cd ./passenger-ruby-rails-demo
    sed -i 's|https://rubygems.org|https://gems.ruby-china.org|g' Gemfile
    mkdir ./tmp
    export PATH=$PATH:$PWD/bin
    setup
    cd ..
fi
# 2
if git clone --depth=1 https://github.com/phusion/passenger-ruby-faye-websocket-demo.git; then
    cd ./passenger-ruby-faye-websocket-demo
    sed -i 's|https://rubygems.org|https://gems.ruby-china.org|g' Gemfile
    bundle install --path vendor/bundle
    cd ../
fi
# 3
if git clone --depth=1 https://github.com/phusion/passenger-nodejs-websocket-demo.git; then
    cd ./passenger-nodejs-websocket-demo
    sed -i 's|https://registry.npmjs.org|http://registry.npm.taobao.org|g' npm-shrinkwrap.json
    npm install
    cd ../
fi
# 4
if git clone --depth=1 https://github.com/phusion/passenger-nodejs-connect-demo.git; then
    cd ./passenger-nodejs-connect-demo
    sed -i 's|https://registry.npmjs.org|http://registry.npm.taobao.org|g' npm-shrinkwrap.json
    npm install
    cd ../
fi
# 5
if git clone --depth=1 https://github.com/phusion/passenger-python-flask-demo.git; then
    echo "from app import MyApp as application" > passenger-python-flask-demo/passenger_wsgi.py
    echo "==> Install flask by yourself! pacman -S python-flask"
fi
}

if [[ x$1 != x ]]; then
    download_demos
fi

sed "s|==PWD==|$PWD|g" ./passenger-demos-template.vhost > ./passenger-demos.vhost
