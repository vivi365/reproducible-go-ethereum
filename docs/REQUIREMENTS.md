# Reproducibility requirements

## Objectives

Leverage reproducibility of `geth` to strengthen their software supply chain and mitigate attacks.

## Goals

The goals of reproducible builds in Go Ethereum is to make a build reproducible to:

- Enable users to verify the binary artifact they download
- Provide a "canary" to developers, signaling if a build is non-deterministic, possibly related to a security issue

### Scope

Go Ethereum have several packaging forms that can benefit from verification of binary reproducibility. In this implementation, the verification will be adopted for binary releases of the `geth` command, targeted at the Linux x86-64 architecture.


## System Requirements

1. Build determinism
    - Given a specific source code and dependency versions, a build should always produce the same result.
2. Recorded build inputs and environment
    - Given an executable artifact, the tools used in the build must be recorded for recreation.
3. Secure cryptographic hashes
    - Cryptographic hashes are used for generating digests for the output artifact and should be created with a secure hashing algorithm.
4. Verification procedure
    - A method for end-users to recreate and validate a build provided by Go Ethereum
5. Verifiable verification?...


# Implementation

An independent verifier that let's users verify their binary