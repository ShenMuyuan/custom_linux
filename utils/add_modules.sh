#!/bin/bash

# Usage: add_modules module1.ko module2.ko ...
# name only, not path

# Unlike commands and their dynamic linking libraries, kernel modules
# need to be extracted from kernel with the same version of testing kernel.
# Modify kernel compile options to get the modules.
my_kernel_dir=/home/smy/dev/kernel/linux-6.3.6/
my_kernel_version=6.3.6

add_modules() {
    if [[ ! -d $my_kernel_dir ]]; then
        echo "Error: wrong kernel directory $my_kernel_dir"
        exit
    fi
    for mod in "$@"; do
        full_path=$(find $my_kernel_dir -name "$mod".ko)
        if [[ -z $full_path ]]; then
            echo "Error: wrong module $mod"
            exit
        fi
        rel_path=${full_path#"$my_kernel_dir"}
        dest_path=lib/modules/$my_kernel_version/$rel_path
        dest_root=${dest_path%/*}
        if [[ ! -e $dest_path ]]; then
            if [[ ! -d $dest_root ]]; then
                mkdir -p "$dest_root"
            fi
            cp "$full_path" "$dest_path"
        fi

    done
}
