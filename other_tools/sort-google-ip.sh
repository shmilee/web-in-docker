#!/bin/bash
## sh ./sort-google-ip.sh $(<./iplist.source)

count=$(echo "$@" | sed 's/[| ]/\n/g' | sed '/^$/d' | sort | uniq | wc -l)
i=1
> 1-ip.list
for ip in `echo "$@" | sed 's/[| ]/\n/g' | sort | uniq`; do
    echo "##### $((i++)) / $count #####"
    ping -c 2 -W 1 $ip && echo $ip >> 1-ip.list
done

count=$(sort 1-ip.list | uniq | wc -l)
i=1
> 2-ip.test
for ip in `sort 1-ip.list | uniq`; do
    echo "##### $((i++)) / $count #####"
    (echo -n $ip" "
    ping -c 10 $ip | awk '/rtt/{print $4}
/transmitted/ {printf $6 }' | sed 's/%/% /;s/\// /g') >> 2-ip.test
done

sed -i 's/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]* 100% //g' 2-ip.test

## sort test result
cat > 3-ip.result.md <<EOF
|     IP     | packet loss | RTT min | RTT avg | RTT max | RTT mdev |
|:----------:|:-----------:|:-------:|:-------:|:-------:|:--------:|
EOF
sort -k 4,4 -k 2,2 -k 6,6 -n 2-ip.test \
    | sed -e 's/ /|/g' -e 's/^/|/' -e 's/$/|/' >> 3-ip.result.md
#awk '{print "|"$1"|"$2"|"$3"|"$4"|"$5"|"$6"|"}'

## BEST output
sort -k 4,4 -k 2,2 -k 6,6 -n 2-ip.test | awk '
{
    if($2=="0%" || $2=="10%" || $2=="20%") {
        printf $1"|"
    }
}
END {printf $1}' > 4-ip.best

## nginx conf output
sed 's/[| ]/\n/g' 4-ip.best > 4-ip.best.tmp
awk '
BEGIN{
    "wc -l 4-ip.best.tmp" | getline;
    weight=$1;
    weight++;
    print "fair;";
}
{
    print "server "$1":443 weight="weight";";
    weight--;
}' 4-ip.best.tmp > 4-ip.best.conf
rm 4-ip.best.tmp
