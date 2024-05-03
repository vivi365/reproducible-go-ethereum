# Overview

Here, we try to reproduce releases from our own travis release pipeline.

## STATE

> `CGO=0`releases are reproducible given `strip geth`
> No reproduction achieved with `CGO=1` yet.

**Prerequisites:**

Use certain...

- Linux dist
- Go version
- Git commit

Unreproducibility issues:

- [x] Date embedding
- [ ] path embeddings: under investigation
  - [x] Bionic - embed c paths
  - [ ] Jammy

## Usage

`chmod +x ./scripts/docker-and-diff.sh`

`./scripts/docker-and-diff.sh travis/CGO1.Dockerfile CGO1-travis`
