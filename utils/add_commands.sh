#!/bin/bash

. utils/add_file.sh

add_commands() {
    for cmd in "$@"; do
        if [[ $cmd =~ ^\/ ]]; then
            if [[ -e "$cmd" ]]; then
                path=$cmd
            else
                echo "Error: wrong command $cmd"
                exit
            fi
        else
            if ! which "$cmd"; then
                echo "Error: wrong command $cmd"
                exit
            fi
            path=$(which "$cmd")
        fi
        echo "Adding command: $path"
        add_file "$path"

        for line in $(ldd "$path"); do
            if [[ $line =~ ^\/ ]]; then
            echo "Adding library: $line"
            add_file "$line"
            fi
        done
    done
}
