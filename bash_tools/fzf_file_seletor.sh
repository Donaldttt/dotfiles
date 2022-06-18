#!/bin/bash

# For any command require a file path, this function
# helps to select the correct file with key words

ret=''

# $1 keyword
# $2 
#   0: show all
#   1: only show directory
fzf_selector() {
    ret=$1
    fchar=(${1[@]})
    if [ "$1" = "." ] || [ "$1" = ".." ] || [ $fchar = "-" ]; then
        return 1
    fi

    if [ $2 = 0 ]; then
        all_items=(*)
    elif [ $2 = 1 ]; then
        all_items=(*/)
    fi

    files=()
    for item in "${all_items[@]}"; do
        grep $1 <<< $item > /dev/null 2>&1 && \
        files+=("$item")
    done

    # if grep find zero file
    if [ "${#files[@]}" = "0" ]; then 
        ret=$1
    elif [ "${#files[@]}" = "1" ]; then 
        ret=$files
    else
        select file in "${files[@]}"; do
            ret=$file
            break
        done
    fi
}

# $1 command for fzf substuting(like ls)
# $2 original args pass to function
# $3 command require file type (file: 0 |directory: 1)
fzf_command_execute() {
    local args=($@)
    local len=${#args}

    # zsh shell's array starts with 1 rather than 0
    if [ ! -z "$ZSH_NAME" ]; then 
        flag="${args[2]}"
        unset 'args[2]'
    else
        flag="${args[1]}"
        unset 'args[1]'
    fi
    
    if [ "$len" = "2" ]; then 
        $args
        return 0
    fi
    # probably work for bash
    #keyword="${args: -1}"

    keyword="${args[-1]}"

    # Delete last argument
    # Here we assume it is a file path
    unset 'args[-1]'

    fzf_selector $keyword $flag
    $args "$ret"
}


fzf_command_list_file=(\
vim \
)

fzf_command_list_dir=(\
ls \
cd \
)

for c in "${fzf_command_list_file[@]}"; do
    alias $c="fzf_command_execute $c 0"
done
for c in "${fzf_command_list_dir[@]}"; do
    alias $c="fzf_command_execute $c 1"
done

# in case above functions are broken
no_fzf(){
    for c in "${fzf_command_list_file[@]}"; do
        unalias $c
    done
    for c in "${fzf_command_list_dir[@]}"; do
        unalias $c
    done
}
