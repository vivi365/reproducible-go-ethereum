# Mach-O

[wikipedia](https://en.wikipedia.org/wiki/Mach-O)

Mac runs mach-o mainly & geth compiles to mach-o for darwin. 

`file` geth gives minimal info. Instead, we can use e.g. `otool` for inspecting the binary. 

For example to see that geth uses dynamic linking, we can use `otool -l geth` and find `cmd LC_LOAD_DYLIB`.