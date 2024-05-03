FROM ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin && go=/usr/local/go/bin
	

# reference build
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.13.15-c5ba367e.tar.gz && tar -xvf geth-linux-amd64-1.13.15-c5ba367e.tar.gz && \
	cd geth-linux-amd64-1.13.15-c5ba367e && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth && \
	mkdir -p /bin && mv geth /bin/geth-reference

# checkout and build in same env as ref build (except travis)
RUN cd go-ethereum && git fetch && git checkout -b reproduce c5ba367eb6232e3eddd7d6226bfd374449c63164 && \
	CGO_ENABLED=1 /usr/local/go/bin/go run ./build/ci.go install -dlgo ./cmd/geth/
RUN cd go-ethereum/build/bin && strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth
RUN	mv go-ethereum/build/bin/geth /bin/geth-reproduce

RUN /usr/local/go/bin/go version >> /go-environment.txt && \
	echo -e "\n" >> /go-environment.txt && \
	usr/local/go/bin/go env >> /go-environment.txt