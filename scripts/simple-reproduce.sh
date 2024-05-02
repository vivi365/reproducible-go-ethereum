#!/bin/bash

# chmod +x ./docker-diff.sh
# open -a Docker
# Have Dockerfile in current directory

echo -e "\nStarting docker build..."
TARGET="geth-path-embeddings"
docker build -t "$TARGET" .

echo -e "\nDocker build finished.\nCopying geth binaries."
CONTAINER_ID=$(docker run -d "$TARGET") # run detached
docker cp -q "$CONTAINER_ID":/bin/geth-reference "$(pwd)" && docker cp -q "$CONTAINER_ID":/bin/geth-reproduce "$(pwd)"
docker cp -q "$CONTAINER_ID":/go-environment.txt "$(pwd)"
docker stop "$CONTAINER_ID" && docker rm "$CONTAINER_ID"

OS=$(uname)
if [ "$OS" == 'Linux' ]; then
    md5_reference=$(md5sum "$(pwd)"/geth-reference | awk '{print $1}')
    md5_reproduce=$(md5sum "$(pwd)"/geth-reproduce | awk '{print $1}')
else # assume Darwin...
    md5_reference=$(md5 "$(pwd)"/geth-reference | awk '{print $NF}')
    md5_reproduce=$(md5 "$(pwd)"/geth-reproduce | awk '{print $NF}')
    alias md5='md5sum'
fi


echo -e "\nFirst build has hash $md5_reference\nSecond build has hash $md5_reproduce"
if [ "$md5_reproduce" != "$md5_reference" ]; then
    echo -e "\nBinaries mismatch. Running diffoscope..."
    # diff the binaries -- this takes a while.
    docker run --rm -t -w "$(pwd)" -v "$(pwd)":"$(pwd)":rw registry.salsa.debian.org/reproducible-builds/diffoscope --progress geth-reference geth-reproduce
else
    if [ "$md5_reproduce" == "" ]; then
        { echo "Error: no binary produced."; exit 1; }
    else
        echo "Binaries match."
    fi
fi