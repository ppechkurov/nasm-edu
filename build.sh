#!/bin/bash

# build obj and exec from .asm files
# to embed debug info pass -g flag to this script

set -e

debug=""
[[ "$1" == "-g" ]] && debug="$1"

obj_path=obj
bin_path=bin
entry_point=main
modules_path=src/modules

# create dirs if not created
[ ! -d $obj_path ] && mkdir $obj_path
[ ! -d $bin_path ] && mkdir $bin_path

# get list of modules
modules=($(ls -d -- $modules_path/*))

# get list of procedures
procedures=()
for m in ${modules[@]}; do
	[ ! -d $m/* ] && continue
	procedures+=($(ls -d -- $m/*))
done

# create obj files in $obj_path dir
for p in ${procedures[@]}; do
	path=$p
	name=$(echo $path | rev | cut -d/ -f1 | rev) # split by /, get last
	nasm -f elf $path/$name.asm -o $obj_path/$name.o $debug
	echo built module: $name
done

# compile exec
nasm -f elf src/$entry_point.asm -o $obj_path/$entry_point.o $debug
ld -m elf_i386 $(ls -d -- $obj_path/*) -o $bin_path/$entry_point
