FROM ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin && go=/usr/local/go/bin


# build 1
RUN cd go-ethereum && git checkout 2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1 && \
	CGO_ENABLED=1 /usr/local/go/bin/go run ./build/ci.go install ./cmd/geth/
RUN cd go-ethereum/build/bin && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth
RUN	mv go-ethereum/build/bin/geth /bin/geth-reference

# build 2
RUN cd go-ethereum && git checkout 2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1 && \
	CGO_ENABLED=1 /usr/local/go/bin/go run ./build/ci.go install ./cmd/geth/
RUN cd go-ethereum/build/bin && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth
RUN	mv go-ethereum/build/bin/geth /bin/geth-reproduce