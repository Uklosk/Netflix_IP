#!/bin/bash
# Gather Netflix and Amazon AWS IP ranges and put them into single file

set -e
if [ -e getflix.txt ] ; then rm getflix.txt ; fi
curl -s https://nflx.ksc91u.info/as-nflx > auxfile.txt
grep -Eo "([0-9.]+){4}/[0-9]+" auxfile.txt > getflix.tmp

# Netflix only IP address ranges
cat getflix.tmp | aggregate -q >NF_only.txt

# create openwrt route rules
counter=0
while read -r line; do
    sed "s|__COUNTER__|$counter|g;s|__IP__|$line|g" rule_template
    (( counter=counter+1 ))
done < NF_only.txt > openwrt_route_rules_nf_only.txt

#tidy the tempfiles
curl -s https://purge.jsdelivr.net/gh/Uklosk/Netflix_IP/NF_only.txt
curl -s https://purge.jsdelivr.net/gh/Uklosk/Netflix_IP/openwrt_route_rules_nf_only.txt
curl -s https://purge.jsdelivr.net/gh/Uklosk/Netflix_IP@main/NF_only.txt
curl -s https://purge.jsdelivr.net/gh/Uklosk/Netflix_IP@main/openwrt_route_rules_nf_only.txt

rm auxfile.txt
rm getflix.tmp
