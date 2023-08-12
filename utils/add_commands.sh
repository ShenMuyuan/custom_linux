#!/bin/bash

# Usage: add_commands cmd1 cmd2 ...
# can be name or path

. utils/add_file.sh

add_commands() {
    for cmd in "$@"; do
        if [[ $cmd =~ ^\/ ]]; then  # cmd is full path
            if [[ -e "$cmd" ]]; then
                path=$cmd
            else
                echo "Error: wrong command $cmd"
                exit
            fi
        else    # cmd is a name
            if ! which "$cmd"; then
                echo "Error: wrong command $cmd"
                exit
            fi
            path=$(which "$cmd")
        fi
        echo "Adding command: $path"
        add_file "$path"

        for line in $(ldd "$path"); do  # split words by space and newline
            if [[ $line =~ ^\/ ]]; then
            echo "Adding dependency library: $line"
            add_file "$line"
            fi
        done
    done
}
