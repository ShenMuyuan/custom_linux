#!/bin/bash

# Usage: add_file /full/path/to/file
# add single file only

add_file() {
    if [[ ! -e $1 ]]; then
        echo "Error: wrong file $1"
        exit
    fi

    root=${1%/*}    # removes the last forward slash and everything after it

    # add the file to the same directory structure in current directory
    if [[ ! -e "$(pwd)$1" ]]; then
        if [[ ! -d "$(pwd)$root" ]]; then
            mkdir -p "$(pwd)$root"
        fi
        cp "$1" "$(pwd)$1"
    fi
}
