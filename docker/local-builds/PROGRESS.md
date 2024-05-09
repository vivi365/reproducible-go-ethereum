# Overview

Local builds compile twice in the dockerfile and check if determinism can be achieved in local builds.

## STATE

> Compiling twice at same site reproduces

**Prerequisites:**

Use certain...

- Linux dist
- Go version
- Git commit

**CGO=1 builds**

- Reproducible given `strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth`
  **CGO=0 builds**
- Reproducible given `strip --remove-section .note.go.buildid geth`

## Usage

`chmod +x /scripts/docker-and-diff.sh`

`./scripts/docker-and-diff.sh local/CGO1.Dockerfile CGO1-local`

## Disclaimer

**Is it ok to strip geth?, i.e. are we stripping symbols needed by the linker during runtime? E.g. can we run these binaries?**

Weak **"yes"**

- OK according to [this](https://reverseengineering.stackexchange.com/questions/2539/what-symbol-tables-stay-after-a-strip-in-elf-format)
- It is only metadata. The build id does tell something though, which can be interesting to look into more, read here: [go nuts](https://groups.google.com/g/golang-nuts/c/b9pcb3paiGQ/m/0jyFtw8mCQAJ)
- Running stripped binary geth works - but has not been thoroughly tested yet.

## `CGO1.Dockerfile`

Reproduces locally (still embeds full paths).

## `trimpath.Dockerfile`

This reproduces full path embeddings despite uding `trimpath`.

```
  [9e5270]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/libusbi.h
  [9e52d8]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/events_posix.c
  [9e5348]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/linux_netlink.c
  [9e53b8]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/linux_usbfs.c
  [9e5428]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/core.c
  [9e54c0]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/hotplug.c
  [9e5528]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/io.c
```

## `strip.Dockerfile`

Just checks diffs in stripping. Toy example.
