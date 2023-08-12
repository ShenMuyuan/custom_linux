#!/bin/bash

# Usage: add_libraries /path/to/lib1 /path/to/lib2 ...
# full path only

. utils/add_file.sh

add_libraries() {
    for lib in "$@"; do
        if [[ $lib =~ ^\/ ]]; then  # lib is full path
            if [[ -e "$lib" ]]; then
                path=$lib
            else
                echo "Error: wrong library $lib"
                exit
            fi
        else    # lib is a name
            echo "Error: wrong library $lib"
            exit
        fi
        echo "Adding library: $path"
        add_file "$path"

        for line in $(ldd "$path"); do  # split words by space and newline
            if [[ $line =~ ^\/ ]]; then
            echo "Adding dependency library: $line"
            add_file "$line"
            fi
        done
    done
}
