#!/bin/bash
sleep ${1:-10}
config=${2:-/srv/etc/supervisord.conf}
hook_script="$3"
if [ ! -f $config ]; then
    echo "!!! lost supervisord.conf"
    exit 1
fi

# hook script
if [ -x "$hook_script" ]; then
    "$hook_script"
fi
# run
exec /usr/bin/supervisord -c $config
