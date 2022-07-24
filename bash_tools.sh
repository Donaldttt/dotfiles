# args:
# $1: 
# The IP address you want to query geo info for.
# If no argument supplied, the host machine's ip will
# be used
# doc for api: https://ip-api.com/docs/api

if [ ! -z "$ZSH_NAME" ]; then 
    SHELL_NAME=zsh
    DOTFILE_DIR=${0:a:h}/
else
    SHELL_NAME=bash

    # display git status
    export GIT_PS1_SHOWDIRTYSTATE=1

    export PS1='\[\e[01;32m\]\w\[\e[01;35m\]$(__git_ps1 " (%s)")\[\e[00m\] '
    DOTFILE_DIR=$(dirname ${BASH_SOURCE[0]})/
fi

function ipinfo(){
    local api_str="http://ip-api.com/json/$1?fields=query,country,regionName,city,district,zip,isp,org,reverse,mobile,proxy,hosting"
    if ! hash python; then
        curl "$api_str"
    else
        curl -s "$api_str" | python -m json.tool
    fi
}

# find file contain certain text string($2) in certain directory($1)
function fct(){
    grep -rnw $1 -e $2
}

# online directory
function odict(){
   curl dict://dict.org/d:"${1}"
}

# self host directory
function dict(){
    python $DOTFILE_DIR/bash_tools/dict.py $1 $2
}

# Linux specific functions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

function set_wallpaper(){
    local file=$1
    # convert to abs path
    if [[ ! "$file" = /* ]]; then
        file=$(pwd)/$1
    fi
    gsettings set org.gnome.desktop.background picture-uri file://$file
}

fi

# Mac OSX specific functions
if [[ "$OSTYPE" == "darwin"* ]]; then

function set_wallpaper(){
    local file=$1
    # convert to abs path
    if [[ ! "$file" = /* ]]; then
        file=$(pwd)/$1
    fi

    apple_script_single_desk="tell application \"Finder\" to set desktop picture to POSIX file \"$file\""
    osascript -e "$apple_script_single_desk"
}

fi

#
#  Command Configuration
#

# -A: get rid of . and ..
# -t: Sort by time. Display the newest first
#alias ls=ls -At

source $DOTFILE_DIR/bash_tools/fzf_file_seletor.sh

