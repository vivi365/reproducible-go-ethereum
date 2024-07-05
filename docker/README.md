# Oveview - Docker

Attempts at reproducing a geth build

docker/
├── local: reproducing locally ✅
└── geth: reproducing official geth binaries ✅


## local

> Local builds are reproducible (locally).

- **CGO=1 builds**
  - Reproducible given `strip --remove-section .note.go.buildid --remove-section .note.gnu.build-id geth`
- **CGO=0 builds**
  - Reproducible given `strip --remove-section .note.go.buildid geth`

## geth

> Control parameters for reproducibility.