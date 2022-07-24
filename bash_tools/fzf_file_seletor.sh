#!/bin/bash

# For any command require a file path, this function
# helps to select the correct file with key words
# Usage:
# Add the command to desired list

# fzf match everything
fzf_command_list_all=(\
)

# fzf match files
fzf_command_list_file=(\
cat \
vim \
set_wallpaper \
)

# fzf only match folders
fzf_command_list_dir=(\
cd \
)

# in case above functions are broken
function no_fzf(){
    for c in "${fzf_command_list_all[@]}"; do
        unalias $c
    done
    for c in "${fzf_command_list_file[@]}"; do
        unalias $c
    done
    for c in "${fzf_command_list_dir[@]}"; do
        unalias $c
    done
}

function dp(){
    local debug=0
    [ "$debug" = "1" ] && echo $1
}

# SHELL specific setting
if [ ! -z "$ZSH_NAME" ]; then 
    SHELL_NAME=zsh
    dp "[bash_tools]: In ZSH shell"
    # disable error output when 
    # wildcard found 0 match
    setopt +o nomatch

    #setopt extended_glob

    # show hidden file when using wildcard
    # use in fzf_selector
    # only for zsh
    setopt dotglob
    setopt glob_dots
else
    # temporary
    SHELL_NAME=bash
    dp "[bash_tools]: In non-ZSH shell"
    # only for bash
    shopt -s dotglob

    # allow reverse wildcard exp. !(b*)
    # shopt -s extglob

    # allows filename patterns which match no 
    # files to expand to a null string, rather 
    # than themselves
    shopt -s nullglob
fi

ret=''

# $1 keyword
# $2 
#   0: show all
#   1: only show directories
#   2: only show files
function fzf_selector() {
    ret=$1
    if [ "$1" = "." ] || [ "$1" = ".." ] || \
       [[ "$1" == -* ]] || [[ "$1" == */* ]]; then
        return 1
    fi

    if [ $2 = 0 ]; then
        all_items=(*)
    elif [ $2 = 1 ]; then
        dp "try to find dirs"
        all_items=(*/)
    elif [ $2 = 2 ]; then
        dp "try to find files"
        if [ "$SHELL_NAME" = "zsh" ]; then 
            eval "all_items=(*(^/))"
        elif [ "$SHELL_NAME" = "bash" ]; then
            # no easy way to list just regular files
            # in bash???
            all=(*)
            all_items=()
            for item in "${all[@]}"; do
                [ -f "$item" ] && all_items+=("$item")
            done
        fi
    fi

    dp "${all_items[@]}"

    files=()
    # match 
    # 1. try match file/dir equals to keyword completely
    # 2. try match file/dir which keyword is substring of
    # 3. try match file/dir equals to keyword completely after ignoring cases
    # 4. try match file/dir which keyword is substring of after ignoring cases

    for item in "${all_items[@]}"; do
        # 1.
        if [ "$item" = "$1" ] || [ "$item" = "$1/" ]; then 
            return 0
        fi

        # 2.
        # this line ignore cases
        # [[ $1 =~ [A-Z] ]] && \ 
            grep $1 <<< $item > /dev/null 2>&1  && \
            files+=("$item")
    done

    dp "len contains upper cases ${#files[@]}"

    if [ "${#files[@]}" = "0" ]; then 
        for item in "${all_items[@]}"; do
            # 3. 
            if  ([ "$SHELL_NAME" = "bash" ] && ( [ "${item,,}" = "${1,,}" ] || [ "${item,,}" = "${1,,}/" ] ))  || \
                ([ "$SHELL_NAME" = "zsh" ] && ( [ "${item:l}" = "${1:l}" ] || [ "${item:l}" = "${1:l}/" ] ))  ; then
                ret=$item
                return 0
            fi
            # 4.
           grep -i $1 <<< $item > /dev/null 2>&1 && files+=("$item")
        done
    fi

    if [ "${#files[@]}" = "0" ]; then 
        # if grep find zero file
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
function fzf_command_execute() {
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

for c in "${fzf_command_list_all[@]}"; do
    alias $c="fzf_command_execute $c 0"
done
for c in "${fzf_command_list_file[@]}"; do
    alias $c="fzf_command_execute $c 2"
done
for c in "${fzf_command_list_dir[@]}"; do
    alias $c="fzf_command_execute $c 1"
done

