#!/bin/bash

add_file() {
    root=${1%/*}

    if [[ ! -e "$(pwd)$1" ]]; then
        if [[ ! -d "$(pwd)$root" ]]; then
            mkdir -p "$(pwd)$root"
        fi
        cp "$1" "$(pwd)$1"
    fi
}
