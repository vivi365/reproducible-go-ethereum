# Overview

Bundle builds reproduces environment of a geth binary release and tries to compile to the same binary.

## STATE

> No reproduction achieved with `CGO=1` yet.

**Prerequisites:**

Use certain...

- Linux dist
- Go version
- Git commit

Unreproducibility issues:

- [x] date: solved
- [ ] path embeddings: under investigation

## Usage

`chmod +x ./scripts/docker-and-diff.sh`

`./scripts/docker-and-diff.sh bundle/13.15.Dockerfile 13.15-bundle`


## `13.14.Dockerfile` / `13.15.Dockerfile` / `14.0.Dockerfile`

Regular reproducing experiments with specific bundled versions.


## `syms.Dockerfile`

This version keeps symbol information which is good for debugging x86.


