# Root causes for diffs

## #1 - LOAD in program header

Two loaded segments have different sizes, changing the addresses they are loaded at.

Notice differences in Filesiz and MemSiz.

```txt
geth-1 (ref build)
Type            Offset               VirtAddr            PhysAddr
LOAD            0x0000000000000000   0x0000000000400000  0x0000000000400000
                FileSiz              MemSiz              Flags  Align
                0x000000000259bc10  0x000000000259bc10   R E    0x200000
```

```txt
geth-2 (reproducing build)
Type            Offset               VirtAddr            PhysAddr
LOAD             0x0000000000000000 0x0000000000400000 0x0000000000400000
                FileSiz              MemSiz              Flags  Align
                0x000000000259bc50 0x000000000259bc50  R E    0x200000
```

## #2 GNU_EH_FRAME in program header

LOAD segment in the program header of an ELF file, it likely indicates differences in how the executables were compiled or linked.
At the moment we have a very large diff... Some causes identified are differing sizes for loaded programs, offsetting address loaded. Another reason is path embeddings from travis.

```txt
Type            Offset      VirtAddr            PhysAddr            FileSiz     MemSiz     Flg  Align

GNU_EH_FRAME    0x25820c0   0x00000000029820c0  0x00000000029820c0  0x003afc    0x003afc    R     0x4

vs

GNU_EH_FRAME    0x2582080   0x0000000002982080  0x0000000002982080  0x003afc    0x003afc    R   0x4
```

**Insights:**

- ELF headers match

```

```


## #3 Date

20240227 embedded in travis release


```txt
20240227	
··0x01e73830·32303234·30323237·00000000·00000000·20240227........	
```


## #4 Embedding path files
- `karalabe/usb` embedded in one version... etc.