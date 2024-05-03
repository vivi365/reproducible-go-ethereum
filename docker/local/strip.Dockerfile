FROM ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin && go=/usr/local/go/bin


# reference build
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.14-2bd6bd01.tar.gz && tar -xvf geth-linux-amd64-1.13.14-2bd6bd01.tar.gz && \
    cd geth-linux-amd64-1.13.14-2bd6bd01 && mkdir -p /bin && mv geth /bin/geth-reference

RUN echo "echo 'before strip: ' && md5sum /bin/geth-reference && \
    cp /bin/geth-reference /bin/geth-reproduce && strip /bin/geth-reproduce && echo 'after strip: ' && md5sum /bin/geth-reproduce && \
    cp /bin/geth-reproduce /bin/geth-3 && strip --remove-section .note.gnu.build-id /bin/geth-3 && echo 'after GNU strip: ' && md5sum /bin/geth-3 && \
    cp /bin/geth-3 /bin/geth-4 && strip --remove-section .note.go.buildid /bin/geth-4 && echo 'after GO strip: ' && md5sum /bin/geth-4" >> src.sh && chmod +x src.sh

