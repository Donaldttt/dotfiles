#!/usr/bin/env bash

############################  SETUP PARAMETERS

app_name='dotfiles'

[ -z "$APP_PATH" ] && APP_PATH="$HOME/.$app_name"
[ -z "$REPO_URI" ] && REPO_URI="https://github.com/Donaldttt/$app_name"
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='main'


############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "\33[32m[✔]\33[0m ${1}${2}"
}

fatal_error() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

program_exists() {
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}

program_must_exist() {
    program_exists $1

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        fatal_error "You must have '$1' installed to continue."
    fi
}

env_set() {
    if [ -z "$1" ]; then
        fatal_error "You must have your $1 environmental variable set to continue."
        exit 1
    fi
}

try_symlink() {
    local source_path="$1"
    local symlink_path="$2"
    if [ -e "$source_path" ]; then
        ln -sf "$source_path" "$symlink_path"
        msg "Create symlink $symlink_path points to $source_path"
        return 0
    fi
    return 1
}

############################ SETUP FUNCTIONS

backup_file() {
    local original_file=$1
    if [ -f "$original_file" ] && [ ! -L "$original_file" ]; then
        today=`date +%Y%m%d_%s`
        mv -v "$original_file" "$original_file.$today";
        success "Your file $original_file has been backed up as $original_file.$today"
    fi
}

# Usage: sync_repo path url
#
# This function try to clone git repo host in @url 
# to @path. If @path alreay exsits, it will simply
# update the repo
sync_repo() {
    local repo_path="$1"
    local repo_uri="$2"
    local repo_branch="$3"
    local repo_name="$4"

    if [ ! -e "$repo_path" ]; then
        msg "Trying to clone $repo_name"
        mkdir -p "$repo_path"
        git clone -b "$repo_branch" "$repo_uri" "$repo_path"
        ret="$?"
        success "Successfully cloned $repo_name."
    else
        msg "Trying to update $repo_name"
        cd "$repo_path" && git pull origin "$repo_branch"
        ret="$?"
        success "Successfully updated $repo_name"
    fi
}

setup_vimplug() {

    # setup for vim 
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1

    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        "+set nomore" \
        "+PlugInstall!" \
        "+PlugClean" \
        "+qall"

    export SHELL="$system_shell"
    success "Now updating/installing plugins using vim-plug"
}

set_up_nvim() {
    nvim_dir="$HOME/.config/nvim"
    nvim_config="$nvim_dir/init.vim"
    mkdir -p $nvim_dir
    if program_exists "nvim"; then
        msg "Found neovim."
        if [ -f "$nvim_config" ]; then
            msg "Found init.vim. backing up it"
            mv $nvim_config "${nvim_config}.backup"
        fi
        echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc" > $nvim_config
    fi
    success "neovim config setup successed"
}

set_up_tmux() {
    if program_exists "tmux"; then
        backup_file "$HOME/.tmux.conf"
        try_symlink "$APP_PATH/.tmux.conf" "$HOME/.tmux.conf" && \
        success "tmux config setup successed"
    else
        msg "tmux not installed"
    fi
}

set_up_vim() {

    program_must_exist "vim"
    program_must_exist "git"
    program_must_exist "curl"

    sync_repo       "$APP_PATH" \
                    "$REPO_URI" \
                    "$REPO_BRANCH" \
                    "$app_name"

    backup_file "$HOME/.vimrc"
    backup_file "$HOME/.vimrc.bundles"

    try_symlink "$APP_PATH/.vimrc"         "$HOME/.vimrc" 
    try_symlink "$APP_PATH/.vimrc.bundles" "$HOME/.vimrc.bundles"

    success "Setting up vim symlinks."

    setup_vimplug
    set_up_nvim
}

############################ MAIN()
env_set "$HOME"

set_up_tmux
set_up_vim

msg             "\nThanks for installing $app_name."
