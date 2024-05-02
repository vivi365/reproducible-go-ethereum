FROM ubuntu:bionic

RUN apt-get update && apt-get install gcc-multilib git ca-certificates wget -yq --no-install-recommends
RUN git clone --branch master https://github.com/ethereum/go-ethereum.git && cd go-ethereum && git fetch
RUN wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz && \
	rm -rf /usr/local/go && \
	tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz && \
	export PATH=$PATH:/usr/local/go/bin


RUN cd go-ethereum && git fetch && git checkout c5ba367eb6232e3eddd7d6226bfd374449c63164 && \
    cd cmd/geth && CGO_ENABLED=1 /usr/local/go/bin/go build -trimpath .
#RUN cd go-ethereum/build/bin

RUN /usr/local/go/bin/go version >> /go-environment.txt && \
	echo -e "\n" >> /go-environment.txt && \
	usr/local/go/bin/go env >> /go-environment.txt