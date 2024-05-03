FROM ubuntu:jammy

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/365theth/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin && go=/usr/local/go/bin
	

# reference build
RUN wget https://github.com/365theth/go-ethereum/releases/download/v1.1.4/geth && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth && \
	mkdir -p /bin && mv geth /bin/geth-reference

# checkout and build in same env as ref build (except travis)
RUN cd go-ethereum && git fetch && git checkout -b reproduce c080b09b7cdb3788affffc471af9d085a3a11f7b && \
	CGO_ENABLED=1 /usr/local/go/bin/go run ./build/ci.go install -dlgo ./cmd/geth/
RUN cd go-ethereum/build/bin && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth
RUN	mv go-ethereum/build/bin/geth /bin/geth-reproduce

RUN /usr/local/go/bin/go version >> /go-env.txt && \
    echo >> /go-env.txt && /usr/local/go/bin/go env >> /go-env.txt