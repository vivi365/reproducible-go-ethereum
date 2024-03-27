# Build Systems - Go Ethereum

> The purpose of this document is to map out the build environments used in geth releases and reproducing attempts, in order to **1.** find causes of unreproducibility, **2.** find any integrity issues ni build pipeline.

Build environments discussed:

1. **B1:** Go Ethereum binary bundle (linux-amd64)
2. **B2:** Replicating build in Docker
   - A Docker image replicating the environment of the bundle (except travis pipeline).

## B1: Travis

The geth binary releases are built in Travis CI and archived to Azure blobstore.
We `wget` the release and untar it in a Docker image (see `docker/binary-bundle/Dockerfile`). The binary is stripped of build ids for comparison to (attempts) of reproducing releases.

### Go toolchain

The go toolchain specified in checksums will be the one used if `-dlgo` is provided, else an existing Go version is used (version downloaded by `gimme` in Travis).

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
  // extracts archive. NOTE: why not verify the binary checksum? Is it enough with the filetree of archive?
  if err := ExtractArchive(dst, godir); err != nil {
		log.Fatal(err)
	}
  // ...
```

## verification of go toolchain

A verification for downloaded packages is done, for example, if using -dlgo, it would verify the filetree checksum.

There are two caveats:

1. If the compile flag `-dlgo` is used, Go will be downloaded for building, and a verification of the archive is done. However, if current Go version in environment satisfies the specified one in `build/checksums.txt`, e.g. `1.21.6`, then no download of Go is done.

```go
// line  96 in [internal/build/gotool.go]
log.Printf("-dlgo version matches active Go version %s, skipping download.", activeGo)
// verification is done in downloadGo (see above)
```

In this case, the gimme version of Go is used, located in `/home/travis/.gimme/versions/go1.21.6.linux.amd64`. This is not verified AFAIK.

**Suggestion:** Should also verify here.

2. No verification of binaries unarchived seems to be done

**Suggestion:** Verify Go checksum of binaries, eg:

```sh
md5sum $(which go)
e235ac942f5019f545285756b41fbc3e /home/travis/.gimme/versions/go1.21.6.linux.amd64/bin/go
# check go download posted hash
```

**Note:** Checksums match for gimme on initial attempts, which is good.

## B2: Docker

The environment for the bundle build is replicated in Docker in terms of

- Ubuntu distribution
- Go version
- Release commit

No Travis pipeline is set up, as users must be able to verify a build without this step.

- Go toolchain:
- Linker:
- C toolchain:
