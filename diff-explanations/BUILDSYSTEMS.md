## What differs in the build systems?

Builds:

1. **B1:** Go Ethereum binary bundle (linux-amd64)
2. **B2:** Replicating build in Docker
   - Produced in a docker image replicating environment of bundle (except travis pipeline)

### B1 - Go Ethereum binary bundle (linux-amd64)

The geth binary releases are built in Travis CI and archived to Azure blobstore.
We `wget` the release and untar it in Docker image. The binary is stripped of buildids for comparison to reproducing releases.

Build system info:

- The `GOPATH` is set to `/home/travis/gopath``
  - Travis build log: `$ export GOPATH="/home/travis/gopath"`
- `gimme` seems to be used for downloading Go - does this reflect the correct Go?
  - Travis build log: `$ export PATH="/home/travis/gopath/bin:/home/travis/.gimme/versions/go1.21.8.linux.amd64/bin:/home/travis/bin:...`
  - An attempt at fetching Go using gimme to verify the Go version is unsuccessful -- version issue, cannot figure out why it complains. Can read the script if interested...
  - **TODO:** How does the compile flag `-dlgo` affect the Go download in Travis?

### B2 - Replicating build in Docker

The environment for the bundle build is replicated in Docker in terms of

- Ubuntu distribution
- Go version
- Release commit

No Travis pipeline is set up, as users must be able to verify a build without this step.
