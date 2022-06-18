
# args:
# $1: 
# The IP address you want to query geo info for.
# If no argument supplied, the host machine's ip will
# be used
# doc for api: https://ip-api.com/docs/api
ipinfo(){
    api_str=http://ip-api.com/json/$1?fields=query,country,regionName,city,district,zip,isp,org,reverse,mobile,proxy,hosting
    if ! hash python; then
        curl $api_str
    else
        curl -s $api_str | python -m json.tool
    fi
}

# find file contain certain text string($2) in certain directory($1)
fct(){
    grep -rnw $1 -e $2
}

# online directory
odict(){
   curl dict://dict.org/d:"${1}"
}


# Linux specific functions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    set_wallpaper(){
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

    set_wallpaper(){
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
# alias ls=ls -At

source $HOME/.vim-config/bash_tools/fzf_file_seletor.sh
