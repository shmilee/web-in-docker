#!/bin/bash
sleep ${1:-5}
config=${2:-/srv/jupyterhub/jupyterhub_config.py}
hub_options=${@:3}
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
done <<EOF
$(sed -n '/# PASSWORD OF USER / p' $config)
EOF

# run hub
exec jupyterhub --config=$config $hub_options
