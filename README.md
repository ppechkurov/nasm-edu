# Learning assembly language

This project is for educational purposes. Implementing different procedures using assembly language (nasm).

## File structure

```
.
├── macros
└── src
    ├── main.asm
    └── modules
```

## Build

```
./build.sh
```

It compiles **ALL** the sources from `src/modules` to the `obj` and `bin` directories.

## Debug

Pass -g to the build script.
Use [gdb](https://sourceware.org/gdb/onlinedocs/gdb/).

## What's implemented

- number.to_string - converts 4 bytes number to it's string representation
- string.to_number - does the opposite
