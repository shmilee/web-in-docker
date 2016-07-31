#!/bin/bash
count=$(echo "$@" | grep '|' -o | wc -l)
((count++))
i=1
for ip in `echo "$@" | sed 's/|/ /g'`; do
    echo "##### $((i++)) / $count #####"
    ping -c 2 $ip && echo $ip >> ip.list
done

count=$(sort ip.list | uniq | wc -l)
i=1
for ip in `sort ip.list | uniq`; do
    echo "##### $((i++)) / $count #####"
    (echo -n $ip": "
    ping -c 5 $ip | awk '/rtt/{print $4}
/transmitted/ {printf $6 }' | sed 's/%/% /;s/\// /g') >> ip.test
done

sed -i 's/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*: 100% //g' ip.test

## 0% packet loss
echo "-----00%-----" > ip.result
cat ip.test | awk '{ if($2=="0%"){print $0}}' | sort -k 4 -n >> ip.result
cat ip.test | awk '{ if($2=="0%"){print $0}}' | sort -k 4 -n > ip.best.tmp
## 20% packet loss
echo "-----20%-----" >> ip.result
cat ip.test | awk '{ if($2=="20%"){print $0}}' | sort -k 4 -n >> ip.result

## 40% packet loss
echo "-----40%-----" >> ip.result
cat ip.test | awk '{ if($2=="40%"){print $0}}' | sort -k 4 -n >> ip.result

## 60% packet loss
echo "-----60%-----" >> ip.result
cat ip.test | awk '{ if($2=="60%"){print $0}}' | sort -k 4 -n >> ip.result

## 80% packet loss
echo "-----80%-----" >> ip.result
cat ip.test | awk '{ if($2=="80%"){print $0}}' | sort -k 4 -n >> ip.result

## BEST output
awk 'BEGIN{"wc -l ip.best.tmp" | getline; weight=$1}
{ if($2=="0%") {print "server "$1"443 weight="weight";"; weight--;} }' ip.best.tmp > ip.best
rm ip.best.tmp
