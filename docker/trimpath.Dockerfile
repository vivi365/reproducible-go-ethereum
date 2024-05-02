FROM ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin

RUN cd go-ethereum && git fetch && git checkout 0d4c38865e9cda492e71221c4c429d9b1bec8ac5 && \
    cd cmd/geth && CGO_ENABLED=1 /usr/local/go/bin/go build -trimpath .

RUN mv /go-ethereum/cmd/geth/geth /geth && readelf -p .rodata geth | grep /root/go/pkg >> full-paths.txt