## TODO

- [x] -dlgo as build flag in docker! (did not improve)
- [ ] Replicate travis env and diff. (not sure how to get the same commit from a new Travis pipeline...)
- [ ] Make reproducible by building in Docker in Travis
- [ ] Compile twice (diversly) in a Travis pipeline
- [ ] Omit the symbol table, debug information and the DWARF symbol table by passing -s and -w to the Go linker: `go build -o mybinary -ldflags="-s -w" src.go`

Later on...

- [ ] Test if implementation detects/mitigates a malicious change

## Ideas

- [ ] Use some attestation for a build (see Trebuchet SolarWinds) for setting env. to replicate
  - Attestations record build steps (?) whereas we extract build info embedded in the executables
