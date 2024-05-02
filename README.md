# Reproducible Go Ethereum

## HOW TO

Build dockerfile and diffoscope if different binaries are produced.

> `./scripts/docker-and-diff.sh <docker dir> <imgname>`
> e.g. `./scripts/docker-and-diff.sh v.1.13.14 geth-april-20`

**Note:** May need to redo `chmod +x ./scripts/docker-and-diff.sh` if docker issues.

## Goals

The goal of reproducible builds in Go Ethereum is to make a build reproducible in order to...

1. Enable users to verify the binary artifact they download
2. Provide a canary to developers, signaling if a build is non-deterministic, possibly
   related to a security issue

For...

- Binary bundles (linux)
- Docker images (maybe)

## STATE

What is currently reproducible?

- **Local builds**, i.e. we can compile twice in Docker and get the same md5
- **Local Travis builds**, i.e. we can compile twice in travis and get the same md5

What is not reproducible?

- We cannot reproduce a **CI build** for a binary release (Linux x86-64) (see root cause analysis in `wiki/ROOTCAUSES.md`)
