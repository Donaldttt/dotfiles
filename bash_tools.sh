# args:
# $1: 
# The IP address you want to query geo info for.
# If no argument supplied, the host machine's ip will
# be used
# doc for api: https://ip-api.com/docs/api

if [ -n "$ZSH_NAME" ]; then 
    SHELL_NAME=zsh
    DOTFILE_DIR=${0:a:h}/
    # enable emacs key bindings
    bindkey -e
    source $DOTFILE_DIR/bash_tools/theme_zsh.sh
elif [ -n "$SHELL" ];then
    SHELL_NAME=bash
    DOTFILE_DIR=$(dirname ${BASH_SOURCE[0]})/
    source $DOTFILE_DIR/bash_tools/theme_bash.sh
fi

## ENVIRONMENT

export EDITOR='vim'
export PATH=$PATH:~/.local/bin

# For references:
# https://askubuntu.com/questions/466198/how-do-i-change-the-color-for-directories-with-ls-in-the-console

# We use vivid to generate configuration for LS_COLORS
# more info: https://github.com/sharkdp/vivid
source $DOTFILE_DIR/bash_tools/ls_colors_theme.sh
alias ls='ls --color=auto'

# get ipinfo of the machine
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

# set_wallpaper() function
source $DOTFILE_DIR/bash_tools/wallpaper.sh

#
#  Command Configuration
#

# -A: get rid of . and ..
# -t: Sort by time. Display the newest first
#alias ls=ls -At

source $DOTFILE_DIR/bash_tools/fzf_file_seletor.sh

