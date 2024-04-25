This dockerfile verifies that a build is locally reproducible by stripping the symbol table and We just need to replicate environments:

- Linux dist
- Go version
- git commit

And then strip binaries from symbol table and two build ids.

We only need to remove the section .note.go.buildid geth apparently.


**Is it ok to strip geth?, i.e. are we stripping symbols needed by the linker during runtime? E.g. can we run these binaries?**

- OK according to [this](https://reverseengineering.stackexchange.com/questions/2539/what-symbol-tables-stay-after-a-strip-in-elf-format)

- Probably yes, it is only metadata. The build id does tell something though, which can be interesting to look into more, read here: [go nuts](https://groups.google.com/g/golang-nuts/c/b9pcb3paiGQ/m/0jyFtw8mCQAJ)
