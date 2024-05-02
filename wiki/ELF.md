# ELF Files

## Anatomy

ELF (Executable and Linkable Format) is a common file format used for executables, object code, shared libraries, and core dumps.

The elf consits of the following parts:

1. ELF header
2. Program (segment) headers
   - Provides info of how segments should be loaded during execution
3. Section headers
   - Provides info to linking
4. Segments
   - Contains multiple sections
5. Sections

`readelf` (GNU binutils) display information about the contents of ELF format files.

### ELF header

The ELF header is found at the start of the file and contains metadata about the file. The ELF header is 32 bytes long starting with 0x7f 0x45 0x4c, translating into 'ELF'.

The `-h` flag displays the ELF header

> `readelf -h geth`

```txt
ELF Header:
  Magic:                             7f 45 4c 46 02 01 01 00 00 00 00 00 00 00 00 00
  Class:                             ELF64
  Data:                              2's complement, little endian
  Version:                           1 (current)
  OS/ABI:                            UNIX - System V
  ABI Version:                       0
  Type:                              EXEC (Executable file)
  Machine:                           Advanced Micro Devices X86-64
  Version:                           0x1
  Entry point address:               0x4152c0
  Start of program headers:          64 (bytes into file)
  Start of section headers:          41384824 (bytes into file)
  Flags:                             0x0
  Size of this header:               64 (bytes)
  Size of program headers:           56 (bytes)
  Number of program headers:         11
  Size of section headers:           64 (bytes)
  Number of section headers:         35
  Section header string table index: 34
```

### Program header

This is a table storing info of the segments, each segment made of one or more sections. The information in the program header is used during runtime.

Kernel steps:

1. Load ELF header into memory
2. Load program header into memory
3. Load contents specified as `LOAD` in the program header and check if interpreter is needed
4. Control to executable/interpreter

The `-l` flag displays the program header

> `readelf -l geth`

```txt
Elf file type is EXEC (Executable file)
Entry point 0x4152c0
There are 11 program headers, starting at offset 64

Program Headers:
  Type           Offset             VirtAddr           PhysAddr
                 FileSiz            MemSiz              Flags  Align
  PHDR           0x0000000000000040 0x0000000000400040 0x0000000000400040
                 0x0000000000000268 0x0000000000000268  R      0x8
  INTERP         0x00000000000002e0 0x00000000004002e0 0x00000000004002e0
                 0x000000000000001c 0x000000000000001c  R      0x1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]
  LOAD           0x0000000000000000 0x0000000000400000 0x0000000000400000
                 0x000000000259bc50 0x000000000259bc50  R E    0x200000
  LOAD           0x000000000259c8a0 0x0000000002b9c8a0 0x0000000002b9c8a0
                 0x00000000001db160 0x0000000000232520  RW     0x200000
  DYNAMIC        0x000000000259cde0 0x0000000002b9cde0 0x0000000002b9cde0
                 0x0000000000000200 0x0000000000000200  RW     0x8
  NOTE           0x00000000000002fc 0x00000000004002fc 0x00000000004002fc
                 0x0000000000000020 0x0000000000000020  R      0x4
  NOTE           0x0000000000000380 0x0000000000400380 0x0000000000400380
                 0x0000000000000020 0x0000000000000020  R      0x8
  NOTE           0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  R      0x8
  TLS            0x000000000259c8a0 0x0000000002b9c8a0 0x0000000002b9c8a0
                 0x0000000000000000 0x0000000000000008  R      0x8
  GNU_EH_FRAME   0x00000000025820c0 0x00000000029820c0 0x00000000029820c0
                 0x0000000000003afc 0x0000000000003afc  R      0x4
  GNU_STACK      0x0000000000000000 0x0000000000000000 0x0000000000000000
                 0x0000000000000000 0x0000000000000000  RW     0x8

 Section to Segment mapping:
  Segment Sections...
   00
   01     .interp
   02     .interp .note.ABI-tag .note.gnu.property .gnu.hash .dynsym .dynstr .gnu.version .gnu.version_r .rela.dyn .rela.plt .init .plt .text .fini .rodata .typelink .itablink .gopclntab .eh_frame_hdr .eh_frame
   03     .init_array .fini_array .data.rel.ro .dynamic .got .got.plt .data .go.buildinfo .noptrdata .bss .noptrbss
   04     .dynamic
   05     .note.ABI-tag
   06     .note.gnu.property
   07
   08     .tbss
   09     .eh_frame_hdr
   10
```

### Sections

Section types include (from Linkers & Loaders, John R. Levine, 2000):

- `PROGBITS`
  - Program contents inclding code, data, debug info
- `NOBITS`
   - Block starting symbol (bss) data allocated at load time
- `SYMTAB` and `DYNTAB`
  - Symbol tables for regularly linked symbols and symbols needing dynamic linking (loaded at runtime).
- `STRTAB`
   - String table
- `REL`and `RELA`
  - Relocation information
- `DYNAMIC` and `HASH`
  - Dynamic linking information and run-time symbol hash table

Commands

- --sections 
- `--sections `