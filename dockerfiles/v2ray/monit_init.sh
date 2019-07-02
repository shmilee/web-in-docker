#!/bin/bash
sleep ${1:-8}
config=${2:-/srv/etc/monitrc}
hook_script="${3:-/srv/etc/hook_script}"
if [ ! -f $config ]; then
    echo "!!! lost etc/monitrc"
    exit 1
fi

# hook script
if [ -x "$hook_script" ]; then
    "$hook_script"
fi
# run
exec /usr/bin/monit -c $config
