#!/bin/bash
sleep ${1:-5}
config=${2:-/srv/jupyterhub/jupyterhub_config.py}
hook_script="${3:-/srv/jupyterhub/hook_script}"
hub_options=${@:4}
if [ ! -f $config ]; then
    echo "!!! lost jupyterhub_config.py"
    exit 1
fi

# add users
while read line; do
    line=${line/'# PASSWORD OF USER '/}
    _UID=${line%%:*}
    _USER=$(echo $line | sed "s/.*$_UID:\(.*\):.*<.*>/\1/")
    _PSWD=$(echo $line | sed 's/.*:.*:.*<\(.*\)>.*$/\1/')
    useradd -g users -m -b /srv/jupyterhub -u $_UID -p "$_PSWD" $_USER
    hash iruby &>/dev/null && {
        echo "==> Register IRuby kernel for USER: $_USER"
        su $_USER -c 'iruby register --force'
    }
done <<EOF
$(sed -n '/# PASSWORD OF USER / p' $config)
EOF

# hook script
if [ -x "$hook_script" ]; then
    "$hook_script"
fi

# run hub
exec jupyterhub --config=$config $hub_options
