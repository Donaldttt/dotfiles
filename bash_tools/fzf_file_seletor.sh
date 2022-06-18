#!/bin/bash

# For any command require a file path, this function
# helps to select the correct file with key words
# Usage:
# Add the command to desired list

# fzf match everything
fzf_command_list_file=(\
vim \
set_wallpaper \
)

# fzf only match folder
fzf_command_list_dir=(\
ls \
cd \
)

# in case above functions are broken
no_fzf(){
    for c in "${fzf_command_list_file[@]}"; do
        unalias $c
    done
    for c in "${fzf_command_list_dir[@]}"; do
        unalias $c
    done
}

dp(){
    local debug=0
    [ "$debug" = "1" ] && echo $1
}

# SHELL specific setting
if [ ! -z "$ZSH_NAME" ]; then 
    # disable error output when 
    # wildcard found 0 match
    setopt +o nomatch

    # show hidden file when using wildcard
    # use in fzf_selector
    # only for zsh
    setopt dotglob
else
    # only for bash
    shopt -s dotglob
fi

ret=''

# $1 keyword
# $2 
#   0: show all
#   1: only show directory
fzf_selector() {
    ret=$1
    if [ "$1" = "." ] || [ "$1" = ".." ] || \
       [[ "$1" == -* ]] || [[ "$1" == */* ]]; then
        return 1
    fi

    if [ $2 = 0 ]; then
        all_items=(*)
    elif [ $2 = 1 ]; then
        all_items=(*/) 2>&1
    fi
    #shopt -u dotglob

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
    local len=${#args[@]}

    dp "lens: $len"

    # zsh shell's array starts with 1 rather than 0
    if [ ! -z "$ZSH_NAME" ]; then 
        dp "zsh"
        flag="${args[2]}"
        unset 'args[2]'
    else
        dp "not zsh"
        flag="${args[1]}"
        unset 'args[1]'
    fi

    dp "flag: $flag"
    
    if [ "$len" = "2" ]; then 
        ${args[@]}
        return 0
    fi
    # probably work for bash
    #keyword="${args: -1}"

    keyword="${args[-1]}"

    dp "keyword: $keyword"
    # Delete last argument
    # Here we assume it is a file path
    unset 'args[-1]'

    fzf_selector $keyword $flag
    dp "${args[@]} $ret"
    ${args[@]} "$ret"
}

for c in "${fzf_command_list_file[@]}"; do
    alias $c="fzf_command_execute $c 0"
done
for c in "${fzf_command_list_dir[@]}"; do
    alias $c="fzf_command_execute $c 1"
done

