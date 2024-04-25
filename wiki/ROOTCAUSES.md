# Root Cause Analysis for Binary Unreproducibility

> These are for official Linux amd64 binary bundles from [geth.ethereum.org/downloads](https://geth.ethereum.org/downloads).

- Tested for v.1.13.14 and 1.13.15.
- Unreproducibility issues are consistent.

## TODO

- [x] Check equivalence of Go
- [x] Check equivalence of c compiler
- [x] Check equivalence of linker
- [ ] Check equivalence of compiler flags
- [ ] Check equivalence of dependencies and versions
- [ ] Check if different optimizations are applied

## What do we do to the binaries?

- Strip symbol table
- Strip two build id sections
  - This makes local builds reproducibile (compile twice pipeline ok)

See `Dockerfile`s in `/docker` for details.

## What is Good?

- All ELF headers match
  - This is mainly metadata
- The go compilers are the same
  - I checked `md5` of the Travis go SDK (downloaded by `gimme`) - it corresponds to the `md5` used in reproducing `Dockerfile`
- Same versions of gcc and ld (probably? in my pipeline at least. May need to double check w. `readelf -p geth-bundle`)

## What is diffing?

The diffs are great, as in very large. See small excerpt in `/reports/binary-bundle-diff.html`

### LOAD in program header

Two loaded segments have different sizes, which changes the addresses they are loaded at.

Notice differences in Filesiz and MemSiz.

```txt
geth-1 (ref build)
Type            Offset               VirtAddr            PhysAddr
LOAD            0x0000000000000000   0x0000000000400000  0x0000000000400000
                FileSiz              MemSiz              Flags  Align
                0x000000000259bc10  0x000000000259bc10   R E    0x200000
```

```txt
geth-2 (reproducing build)
Type            Offset               VirtAddr            PhysAddr
LOAD             0x0000000000000000 0x0000000000400000 0x0000000000400000
                FileSiz              MemSiz              Flags  Align
                0x000000000259bc50 0x000000000259bc50  R E    0x200000
```

- **ROOTCAUSE:** Instructions differ for some functions. `BLS12` from `gnarkcrypto` is in focus.
- **HOW TO FIND ROOTCAUSE:** Inspect diffoscopes and disassembled objdumps (x86).

Note:

- Try `-ldflags=" -dumpdep"` for dependency graph of symbols

#### BLS12





### #2 GNU_EH_FRAME in program header

This is exception handling.

```txt
Type            Offset      VirtAddr            PhysAddr            FileSiz     MemSiz     Flg  Align

GNU_EH_FRAME    0x25820c0   0x00000000029820c0  0x00000000029820c0  0x003afc    0x003afc    R     0x4

vs

GNU_EH_FRAME    0x2582080   0x0000000002982080  0x0000000002982080  0x003afc    0x003afc    R   0x4
```

- **ROOTCAUSE:** Unknown
- **HOW TO FIND ROOTCAUSE:** See if solved with `BLS12`, else investigate further.

### #3 Date

20240227 embedded in travis release

```txt
20240227
··0x01e73830·32303234·30323237·00000000·00000000·20240227........
```

- **ROOTCAUSE:** Unknown, something that Travis does? or a passed `ldflag?`
- **HOW TO FIX:** Check more precisely which section this appears in.

### #4 Embedding path files

**Q:** why is --trimpath not always applied? See diffs below

```sh
# bundle build
│ -/home/travis/gopath/pkg/mod/github.com/karalabe/usb@v0.0.2/libusb/libusb/os/linux_netlink.c
│ -/home/travis/gopath/pkg/mod/github.com/karalabe/usb@v0.0.2/libusb/libusb/os/linux_usbfs.c
# reproducing build
│ +/root/go/pkg/mod/github.com/karalabe/usb@v0.0.2/libusb/libusb/os/linux_netlink.c
│ +/root/go/pkg/mod/github.com/karalabe/usb@v0.0.2/libusb/libusb/os/linux_usbfs.c

│ -/home/travis/gopath/pkg/mod/github.com/ethereum/c-kzg-4844@v0.4.0/bindings/go/../../src/c_kzg_4844.c
```

- **ROOTCAUSE:** Unknown
- **HOW TO FIX:** Bug report Go.
