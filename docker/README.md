# Docker Images Oveview

## `local.Dockerfile`

- Compiling twice at same site reproduces

This dockerfile verifies that a build is locally reproducible by stripping the symbol table and We just need to replicate environments:

- Linux dist
- Go version
- git commit

And then strip binaries from symbol table and two build ids.

We only need to remove the section .note.go.buildid geth apparently.

**Is it ok to strip geth?, i.e. are we stripping symbols needed by the linker during runtime? E.g. can we run these binaries?**

- OK according to [this](https://reverseengineering.stackexchange.com/questions/2539/what-symbol-tables-stay-after-a-strip-in-elf-format)

- Probably yes, it is only metadata. The build id does tell something though, which can be interesting to look into more, read here: [go nuts](https://groups.google.com/g/golang-nuts/c/b9pcb3paiGQ/m/0jyFtw8mCQAJ)

## `13.14.Dockerfile` / `13.15.Dockerfile` / `14.0.Dockerfile`

Regular reproducing experiments with specific bundled versions.

Progress:

- Need to strip build id
- Need to create a branch to include a date in the binary. (set the date?)

## `syms.Dockerfile`

This version keeps symbol information which is good for debugging x86.

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

## `buildid.Dockerfile`

This Dockerfile is for removing build-ids by build flags rather than stripping -- unfortunately quite unsuccessful.

**Choosing stripping option at the moment as attempts using build flags are not working well.**

**What are the diffs?**

Build ids:

- GO BUILDID in note section .note.go.buildid
- NT_GNU_BUILD_ID in note section .note.gnu.build-id

**What flags do we use to exclude build id metadata?**

- GO BUILDID
  - **Not working:** suggested in [GitHub issue](https://github.com/golang/go/issues/48557): `ldflags="-buildid="` which does not affect the go build ids at all.
- NT_GNU_BUILD_ID
  - In docker on underlying mac: - `ldflags="-w"` nor `ldflags="-s"` or the combination SEEM TO WORK after all.
  - In docker on underlying repairnator: - `cflags="-buildid="`
    - We could use both, but we should test this on additional underlying OSes

## `strip.Dockerfile`

Just checks diffs in stripping. Toy example.
