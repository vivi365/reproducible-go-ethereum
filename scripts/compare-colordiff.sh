#!/bin/bash

REF=$1
REP=$2

if [ $# != 2 ]; then
    echo "Usage: $0 <bin 1> <bin 2>"
    exit 2
fi


echo -e "Comparing binary hash of $REF and $REP...\n"

REF_MD5=$(md5 "$REF" | awk '{print $NF}')
REP_MD5=$(md5 "$REP" | awk '{print $NF}')


echo "First build has hash $REF_MD5"
echo "Second build has hash $REP_MD5"
sleep 2

if [ "$REP_MD5" != "$REF_MD5" ]; then
    echo "Binaries mismatch. Diffing..."
    sleep 3 
    readelf -a "$REF" > r1.txt
    readelf -a "$REP" > r2.txt
    colordiff r1.txt r2.txt
    rm r1.txt r2.txt
else
    echo "Binaries match."
fi

