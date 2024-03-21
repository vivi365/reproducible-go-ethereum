#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <target name> <docker relative dir>"
    exit 1
fi

open -a Docker
sleep 2

# vaiables
TARGET=$1
DIR=$2
DOCKER_PATH=~/reproducible-go-ethereum/docker/$DIR
OUTPUT_DIR=~/reproducible-go-ethereum/bin
DIFF_DIR=~/reproducible-go-ethereum/diff-explanations
rm ~/reproducible-go-ethereum/bin/geth-1 && rm ~/reproducible-go-ethereum/bin/geth-2
mkdir -p $OUTPUT_DIR $DIFF_DIR 


# build image
cd "$DOCKER_PATH" || echo "no such directory $DOCKER_PATH"
echo "\nStarting docker build..."
docker build -t "$TARGET" .


# start container
echo "\nBuild finished. Running container in detached mode."
CONTAINER_ID=$(docker run -d "$TARGET" /bin/sh) # cannot use --rm here: loses cid

# copy binaries and stop container
echo "\nCopying binaries..."
docker cp -q "$CONTAINER_ID":/bin/geth-1 "$OUTPUT_DIR"/geth-1
docker cp -q "$CONTAINER_ID":/bin/geth-2 "$OUTPUT_DIR"/geth-2
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"


# check binary and diff if neq
md5_reference=$(md5 "$OUTPUT_DIR"/geth-1 | awk '{print $NF}')
md5_local=$(md5 "$OUTPUT_DIR"/geth-2 | awk '{print $NF}')

echo "\nFirst build has hash $md5_reference\nSecond build has hash $md5_local"

if [ "$md5_local" != "$md5_reference" ]; then
    echo "\nBinaries mismatch. Running diffoscope..."
    cd "$OUTPUT_DIR" || exit 1
    docker run --rm -t -w "$(pwd)" -v "$(pwd)":"$(pwd)":ro registry.salsa.debian.org/reproducible-builds/diffoscope --progress --html $DIFF_DIR/diff.html geth-1 geth-2
else
    echo "Binaries match."
fi


# todo write diff to file.