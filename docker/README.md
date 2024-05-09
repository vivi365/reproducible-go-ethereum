# Oveview - Docker

Attempts at reproducing a geth build

docker/
├── local-builds: reproducing locally ✅
├── official-binaries: reproducing official geth binaries ❌
└── travis-builds: reproducing own travis pipeline (365theth) ✅

## local builds

> Local builds are reproducible (locally).

- **CGO=1 builds**
  - Reproducible given `strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth`
- **CGO=0 builds**
  - Reproducible given `strip --remove-section .note.go.buildid geth`

**Files:**

- `Dockerfile-embedded-path`
  - This reproduces full path embeddings in ubuntu bionic despite using `trimpath`.

```
  [9e5270]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/libusbi.h
  [9e52d8]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/events_posix.c
  [9e5348]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/linux_netlink.c
  [9e53b8]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/os/linux_usbfs.c
  [9e5428]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/core.c
  [9e54c0]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/hotplug.c
  [9e5528]  /root/go/pkg/mod/github.com/karalabe/hid@v1.0.1-0.20240306101548-573246063e52/libusb/libusb/io.c
```

- `Dockerfile-cgo`
  - Reproduces locally (still embeds full paths)

## official binaries

No reproduction achieved with `CGO=1` yet.

**Rootcauses found:**

- [x] Embedding of date
  - When compiling in detached state a date is NOT embedded, as in official releases. Check out in a new branch, or perhaps set the date in other way.
- [x] Full path embeddings of C libraries
  - `trimpath` broken on some architectures (e.g. `ubintu:bionic`) See [issue](https://github.com/golang/go/issues/67011)

> Yet, can't achieve reproducibility for `Dockerfile-14.2-unstable` which diffs in number of dynamic symbols...

**Files:**

- `Dockerfile-13.15`
  - Attempts to reproduce geth linux amd-64 for v. 13.15
  - Will not be reproducible due too using bionic, which embeds paths
- `Dockerfile-14.2-unstable`
  - Reproduces and unstable build using ubuntu:noble (which does not embed paths!)
  - Unreproducible (diff in number of dynsyms)
- `Dockerfile-dynsyms`
  - A version that keeps symbol information which is good for debugging x86

## travis builds

> These are reproducible for ununtu jammy for linux amd-64, 386, arm5
