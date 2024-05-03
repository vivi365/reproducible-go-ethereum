#!/bin/sh

if [ $# -ne 2 ]; then
    echo "Usage: $0 <docker relative filepath> <docker tag> "
    exit 1
fi

open -a Docker
sleep 3

FILE=$1
TAG=$2
DOCKER_PATH=~/reproducible-go-ethereum/docker/$FILE
OUTPUT_DIR=~/reproducible-go-ethereum/bin
mkdir -p $OUTPUT_DIR
rm $OUTPUT_DIR/geth-reference && rm $OUTPUT_DIR/geth-reproduce


# build image
echo "\nStarting docker build..."
docker build -t "$TAG" - < "$DOCKER_PATH"


# start container
echo "\nBuild finished. Running container in detached mode."
CONTAINER_ID=$(docker run -d "$TAG" /bin/sh) # cannot use --rm here: loses cid

# copy binaries and stop container
echo "\nCopying binaries..."
docker cp -q "$CONTAINER_ID":/bin/geth-reference "$OUTPUT_DIR"
docker cp -q "$CONTAINER_ID":/bin/geth-reproduce "$OUTPUT_DIR"
docker stop "$CONTAINER_ID"
docker rm "$CONTAINER_ID"

# check binary md5s and diff if neq
md5_reference=$(md5 "$OUTPUT_DIR"/geth-reference | awk '{print $NF}')
md5_reproduce=$(md5 "$OUTPUT_DIR"/geth-reproduce | awk '{print $NF}')

echo "\nFirst build has hash $md5_reference\nSecond build has hash $md5_reproduce"

if [ "$md5_reproduce" != "$md5_reference" ]; then
    echo "\nBinaries mismatch. Running diffoscope..."
    cd "$OUTPUT_DIR" || { echo "no such directory $OUTPUT_DIR"; exit 1; }
    docker run --rm -t -w "$(pwd)" -v "$(pwd)":"$(pwd)":rw registry.salsa.debian.org/reproducible-builds/diffoscope --progress geth-reference geth-reproduce
else
    if [ "$md5_reproduce" == "" ]; then
        { echo "Error: no binary produced."; exit 1; }
    else
        echo "Binaries match."
    fi
fi