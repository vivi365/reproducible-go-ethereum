FROM ubuntu:noble

RUN apt-get update && apt-get install git ca-certificates wget binutils -yq --no-install-recommends

RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch

RUN wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz && \
    rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin	

# reference build
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.14.3-ab48ba42.tar.gz && tar -xvf geth-linux-amd64-1.14.3-ab48ba42.tar.gz && \
    cd geth-linux-amd64-1.14.3-ab48ba42 && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth && \
    mkdir -p /bin && mv geth /bin/geth-reference

# checkout and build in same env as ref build (except travis)
RUN cd go-ethereum && git fetch && git checkout -b reproduce ab48ba42f4f34873d65fd1737fabac5c680baff6 && \
    CGO_ENABLED=1 go run ./build/ci.go install -dlgo ./cmd/geth/

RUN cd go-ethereum/build/bin && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth

RUN	mv go-ethereum/build/bin/geth /bin/geth-reproduce