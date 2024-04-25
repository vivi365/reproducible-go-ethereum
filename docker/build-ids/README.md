This Dockerfile is for removing build-ids by build flags rather than stripping.

**Choosing stripping option at the moment as attempts using build flags are not working well.**

**What are the diffs?**

Build ids:

- GO BUILDID in note section .note.go.buildid
- NT_GNU_BUILD_ID in note section .note.gnu.build-id

**What flags do we use to exclude build id metadata?**

- GO BUILDID
  - **Not working:** suggested in [GitHub issue](https://github.com/golang/go/issues/48557): `ldflags="-buildid="` which does not affect the go build ids at all.
- NT_GNU_BUILD_ID
  - In docker on underlying mac: - `ldflags="-w"` nor `ldflags="-s"` or the combination SEEM TO WORK after all.
  - In docker on underlying repairnator: - `cflags="-buildid="`
    - We could use both, but we should test this on additional underlying OSes

**Is it ok to exclude build ids?**

Probably yes, it is only metadata. The build id does tell something though, which can be interesting to look into more, read here: [go nuts](https://groups.google.com/g/golang-nuts/c/b9pcb3paiGQ/m/0jyFtw8mCQAJ)
