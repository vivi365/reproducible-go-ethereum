## Extracting (env) information from the binary

>`file geth`

```txt
geth-1: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, stripped
```

*Interesting parts:*
- Architecture
- Linking type
- Linker
- Stripped


> `geth version`
...Given a certain geth executable in `$PATH`

```txt
Geth
Version: 1.13.14-stable
Architecture: amd64
Go Version: go1.22.0
Operating System: darwin
GOPATH=~/go/src
GOROOT=~/gosource/goroot
```

*Interesting parts:*
- Version information

The remaining env variables seem local, i.e. not for the build.
- Architecture
- Go version (local)
- Go env paths

>`go version -m geth`

```txt
geth: go1.21.6
	path	github.com/ethereum/go-ethereum/cmd/geth
	mod	    github.com/ethereum/go-ethereum	(devel)
    dep     ...
    ...
    ...
	build	-buildmode=exe
	build	-compiler=gc
	build	-tags=urfave_cli_no_docs,ckzg
	build	-trimpath=true
	build	DefaultGODEBUG=panicnil=1
	build	CGO_ENABLED=1
	build	GOARCH=amd64
	build	GOOS=linux
	build	GOOS=v1
	build	vcs=git
	build	vcs.revision=2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1
	build	vcs.time=2024-02-27T11:51:11Z
	build	vcs.modified=false
```


*Interesting parts:*
- All build information, especially
    - CGO_ENABLED
    - GOARCH
    - GOOS