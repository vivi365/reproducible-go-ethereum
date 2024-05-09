# Reproducible Go Ethereum

Reproducing Official Linux amd64 binary bundles from [geth.ethereum.org/downloads](https://geth.ethereum.org/downloads)

## Usage

Build dockerfile and diffoscope if different binaries are produced.

`./scripts/docker-and-diff.sh <docker relative filepath> <docker tag>`

**For example,**
`./scripts/docker-and-diff.sh travis/CGO0.Dockerfile travis-cgo0`

**Note:** May need to redo `chmod +x ./scripts/docker-and-diff.sh` if docker issues.

## STATE

> 🚧 Rootcauses for unreproducibility found

Rootcauses:
- [x] Embedding of date
  - When compiling in detached state a date is NOT embedded, as in official releases. Check out in a new branch, or perhaps set the date in other way.
- [x] Full path embeddings of C libraries
  - `trimpath` broken on some architectures (e.g. `ubintu:bionic`) See [issue](https://github.com/golang/go/issues/67011)

### Investigation Steps

- [x] Check equivalence of Go compiler (`-dlgo` follows checksum.txt requirements. gimme download ok.)
- [x] Check equivalence of c compiler
- [x] Check equivalence of linker
- [ ] Check equivalence of compiler flags
- [ ] Check equivalence of dependencies and versions
- [x] Check if different optimizations are applied (O2 for all `/ci.go` builds.)

## Binary Modifications

- Strip symbol table
- Strip two build id sections
  - This makes local builds reproducibile (compile twice pipeline ok)
- Checkout in a new branch (avoid detached state which does not embed a date)

See `Dockerfile`s in `./docker` for details.

## Positive Findings

- All ELF headers match
  - This is mainly metadata
- The go compilers are the same
  - I checked `md5` of the Travis go SDK (downloaded by `gimme`) - it corresponds to the `md5` used in reproducing `Dockerfile`
- Same versions of gcc and ld (probably? in my pipeline at least. May need to double check w. `readelf -p geth-bundle`)

## Goals

The goal of reproducible builds in Go Ethereum is to make a build reproducible in order to...

1. Enable users to verify the binary artifact they download
2. Provide a canary to developers, signaling if a build is non-deterministic, possibly
   related to a security issue

For...

- Binary bundles (linux)
- Docker images (maybe)
