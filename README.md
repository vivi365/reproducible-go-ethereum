# Reproducible Go Ethereum

Reproducing Official Linux amd64 binary bundles from [geth.ethereum.org/downloads](https://geth.ethereum.org/downloads)

Build docker file reproducing geth build. Diffoscope if different binaries are produced.

## Usage

`./scripts/docker-and-diff.sh <docker relative filepath> <docker tag>`

**For example,**
`./scripts/docker-and-diff.sh official-binaries/Dockerfile-14.2-unstable noble-unstable`


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
- [x] Check equivalence of dependencies and versions
- [x] Check if different optimizations are applied (O2 for all `/ci.go` builds.)

## Binary Modifications

- Strip symbol table
- Strip two build id sections
  - This makes local builds reproducibile (compile twice pipeline ok)
- Checkout in a new branch (avoid detached state which does not embed a date)

See `Dockerfile`s in `./docker` for details.
