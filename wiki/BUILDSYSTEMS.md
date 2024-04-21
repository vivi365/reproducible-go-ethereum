# Build Systems - Go Ethereum

> The purpose of this document is to map out the build environments used in geth releases and reproducing attempts, in order to **1.** find causes of unreproducibility, **2.** find any integrity issues in build pipeline.

Build environments discussed:

1. **B1:** Go Ethereum binary bundle (linux-amd64)
2. **B2:** Replicating build in Docker
   - A Docker image replicating the environment of the bundle (except travis pipeline).

## B1: Travis

The geth binary releases are built in Travis CI and archived to Azure blobstore.
We `wget` the release and untar it in a Docker image (see `docker/binary-bundle/Dockerfile`). The binary is stripped of build ids for comparison to (attempts) of reproducing releases.

### Go toolchain

The `-dlgo` flag is used for CI builds (see `go-ethereum/travis.yml`) which results in the following behaviour:

- Gimme, a script for downloading Go in Travis, will download the Go version specified in `go-ethereum/travis.yml`
- Go version corresponds to the version specified in `go-ethereum/build/checksums.txt`?
  - **Yes:** use gimme download of Go. This is not verified AFAIK.
  - **No:** Download Go and verify correct package contents according to checksum, use this Go compiler

```go
// dlgo flag in doInstall [build/ci.go]
func doInstall(cmdline []string) {
  var dlgo = flag.Bool("dlgo", false, "Download Go and build with it")

  // ...

  if *dlgo {
      csdb := build.MustLoadChecksums("build/checksums.txt") // loads checksums defined in build/checksums.txt
      tc.Root = build.DownloadGo(csdb) // given version in csdb,
  }
  / ...
}
```

```go
// downloadGo excerpt [internal/build/download.go]
func DownloadGo(csdb *ChecksumDB) string {
	version, err := Version(csdb, "golang") // get version from build/checksum.txt
  	activeGo := strings.TrimPrefix(runtime.Version(), "go")
	if activeGo == version {
		log.Printf("-dlgo version matches active Go version %s, skipping download.", activeGo)
		return runtime.GOROOT()
	}
}
  // ...
  // downloads and verifies the checksum...
  if err := csdb.DownloadFile(url, dst); err != nil { // verifies filetree hash from build/checksums.txt
		log.Fatal(err)
	}
  // ....
  // extracts archive. NOTE (VIVI): why not verify the binary checksum? Is it enough with the filetree of archive?
  if err := ExtractArchive(dst, godir); err != nil {
		log.Fatal(err)
	}
  // ...
```

## B2: Docker

The environment for the bundle build is replicated in Docker in terms of

- Ubuntu distribution
- Go version
- Release commit

No Travis pipeline is set up, as users must be able to verify a build without this step.

- Go toolchain:
- Linker:
- C toolchain:

# Suggestions!

1. Should verify gimme toolchain if used!
2. Verification of unarchived Go binaries seems to be done

```sh
md5sum $(which go)
e235ac942f5019f545285756b41fbc3e /home/travis/.gimme/versions/go1.21.6.linux.amd64/bin/go
# check go download posted hash
```

**Note:** Checksums match for gimme on initial attempts, which is good. But (potentially small) risk in compromise of gimme script. **TTBV** = Trust Travis But Verify
