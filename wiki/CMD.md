# cmd wiki!

## objdump

> `objdump -d geth` disassembles executable parts into assembly

> `objdump -D geth` disassemble all

```sh
# example of diffing dumps
objdump -d geth-1 > g1.txt
objdump -d geth-2 > g2.txt

diff g1.txt g2.txt
```

## Build info from object files

> This is an ELF pov.

> `file geth`

Basic information about the ELF.

```txt
geth-1: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 3.2.0, stripped
```

_Interesting parts:_

- Architecture
- Linking type
- Linker
- Stripped

> `geth version`
> ...Given a certain geth executable in `$PATH`

```txt
Geth
Version: 1.13.14-stable
Architecture: amd64
Go Version: go1.22.0
Operating System: darwin
GOPATH=~/go/src
GOROOT=~/gosource/goroot
```

_Interesting parts:_

- Version information

The remaining env variables seem local, i.e. not for the build.

- Architecture
- Go version (local)
- Go env paths

> `go version -m geth`

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
	build	GOAMD64=v1
	build	vcs=git
	build	vcs.revision=2bd6bd01d2e8561dd7fc21b631f4a34ac16627a1
	build	vcs.time=2024-02-27T11:51:11Z
	build	vcs.modified=false
```

_Interesting parts:_

- All build information, especially
  - CGO_ENABLED
  - GOARCH
  - GOOS

## Go

> `go env`

Env prints Go environment information. Use `-json` flag for json format.

```sh
$ go env
GO111MODULE='auto'
GOARCH='amd64'
GOCACHE='/home/travis/.cache/go-build'
GOENV='/home/travis/.config/go/env'
...
GOHOSTARCH='amd64'
GOHOSTOS='linux'
GOINSECURE=''
GOMODCACHE='/home/travis/gopath/pkg/mod'
...
GOOS='linux'
GOPATH='/home/travis/gopath'
GOPRIVATE=''
GOPROXY='https://proxy.golang.org,direct'
GOROOT='/home/travis/.gimme/versions/go1.21.8.linux.amd64'
...
GOTOOLCHAIN='auto'
GOTOOLDIR='/home/travis/.gimme/versions/go1.21.8.linux.amd64/pkg/tool/linux_amd64'
...
GOGCCFLAGS='-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=0 -fdebug-prefix-map=/tmp/go-build1824594803=/tmp/go-build -gno-record-gcc-switches'
```

### Build flags

> `--trimpath`

Trims absolute paths.
