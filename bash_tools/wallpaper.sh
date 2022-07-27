
# Linux specific functions
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

set_gnome_wp() {
    gsettings set org.gnome.desktop.background picture-uri "file://$1"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$1"
}

function set_wallpaper(){
    local file=$1
    # convert to abs path
    if [[ ! "$file" = /* ]]; then
        file=$(pwd)/$1
    fi
    set_gnome_wp $file
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
