# args:
# $1: 
# The IP address you want to query geo info for.
# If no argument supplied, the host machine's ip will
# be used
# doc for api: https://ip-api.com/docs/api
ipinfo()
{
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

change_wallpaper(){
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

change_wallpaper(){
    local file=$1
    # convert to abs path
    if [[ ! "$file" = /* ]]; then
        file=$(pwd)/$1
    fi

    # not working for all desktops
    #apple_script_all_desk=" \
    #    import AppKit; \
    #    let url = URL(fileURLWithPath: \"$file\"); \
    #    for screen in NSScreen.screens {
    #        try! NSWorkspace.shared.setDesktopImageURL(url, for: screen, options: [:]) \
    #    }" 
    #swift <<< $apple_script_all_desk

    apple_script_single_desk="tell application \"Finder\" to set desktop picture to POSIX file \"$file\""
    osascript -e "$apple_script_single_desk"

}

fi
