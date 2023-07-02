#!/bin/bash

. utils/add_file.sh

add_modules() {
    for mod in "$@"; do
        filename_line=$(modinfo "$mod" | grep filename)
        path=${filename_line##* }
        add_file "$path"
    done
}
