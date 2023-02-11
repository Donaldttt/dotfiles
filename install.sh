#!/usr/bin/env bash

############################  SETUP PARAMETERS

app_name='dotfiles'

[ -z "$APP_PATH" ] && APP_PATH="$HOME/.$app_name"
[ -z "$REPO_URI" ] && REPO_URI="https://github.com/Donaldttt/$app_name"
[ -z "$REPO_BRANCH" ] && REPO_BRANCH='dev'
[ -z "$VIM_RTPATH" ] && VIM_RTPATH="$HOME/.vim"


############################  BASIC SETUP TOOLS
msg() {
    printf '%b\n' "$1" >&2
}

success() {
    msg "\33[32m[✔]\33[0m ${1}${2}"
}

fail() {
    msg "\33[31m[✘]\33[0m ${1}${2}"
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

# check if file $2 contain string $1
# return 0 if exists
# 1 not contain string
# 2 file not exist
# when using this function:
# file path should not be quoted but like this:
# file_contains 'abc' file_path 
file_contains(){
    if [ -f "$2" ]; then
        a=`grep "$1" $2`
        [ "$a" != '' ] && return 0
        return 1
    fi
    return 2
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

    # if vimplug is already installed
    # comment out since this can update vimplug
    #if [ -e "~/.vim/autoload/plug.vim" ]; then
    #    return 0
    #fi

    mkdir -p "$VIM_RTPATH/autoload"
    # setup for vim 
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1

    local system_shell="$SHELL"
    export SHELL='/bin/sh'

    vim \
        "+set nomore" \
        "+PlugInstall!" \
        "+qall"

    export SHELL="$system_shell"
    success "Plugins' updated/installed using vim-plug \n(Be careful some plugins may not be installed since they require to use neovim or higher vim version. To intall them, run :PlugInstall inside correct version)"
}

set_up_nvim() {
    if program_exists "nvim"; then
        nvim_dir="$HOME/.config/nvim"
        nvim_config="$nvim_dir/init.vim"
        mkdir -p $nvim_dir
        msg "Found neovim."
        if [ -f "$nvim_config" ]; then
            msg "Found init.vim. backing up it"
            mv $nvim_config "${nvim_config}.backup"
        fi
        echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc" > $nvim_config
        success "Neovim config setup successed"
    else
        fail "Neovim config is not setup(neovim not installed)"
    fi
}

set_up_tmux() {
    if program_exists "tmux"; then
        backup_file "$HOME/.tmux.conf"
        try_symlink "$APP_PATH/.tmux.conf" "$HOME/.tmux.conf" && \
        success "Tmux config setup successed"
    else
        fail "Tmux config is not setup(tmux not installed)"
    fi
}

set_up_vim() {
    if ! program_exists "vim" && ! program_exists "nvim" ; then
        fatal_error "You must have 'vim' or 'nvim(neovim)' installed to continue."
    fi
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

    success "Setting up symlinks for vim configuration"
    set_up_nvim
    setup_vimplug
}

# zoxide requres extra shell configuration setup
set_up_zoxide_shell_config() {
    local source_cmd_zsh='eval "$(zoxide init zsh)"'
    local source_cmd_bash='eval "$(zoxide init bash)"'
    if program_exists "zsh"; then
        # if not already contain source command
        file_contains "$source_cmd_zsh" ~/.zshrc 
        status_code=$?
        if [ "$status_code" != '0' ]; then
            echo "Install zoxide source command ($source_cmd_zsh) for zsh shell?('y' install; 'q' quit the scrip)"
            read -r respond
            if [ "$respond" = "y" ] || [ "$respond" = "yes" ]; then
                echo "$source_cmd_zsh" >> $HOME/.zshrc
            elif [ "$respond" = "q" ]; then
                exit 0
            fi
            success "add ($source_cmd_zsh) to zsh"
        fi
    fi

    if program_exists "bash"; then
        # if not already contain source command
        file_contains "$source_cmd_bash" ~/.bashrc 
        status_code=$?
        if [ "$status_code" != '0' ]; then
            echo "Install zoxide source command ($source_cmd_bash) for bash shell?('y' install; 'q' quit the scrip)"
            read -r respond
            if [ "$respond" = "y" ] || [ "$respond" = "yes" ]; then
                echo "$source_cmd_bash" >> $HOME/.bashrc
            elif [ "$respond" = "q" ]; then
                exit 0
            fi
            success "add ($source_cmd_bash) to bash"
        fi
    fi
}

set_up_zoxide() {
    # https://github.com/ajeetdsouza/zoxide

    if program_exists "zoxide"; then
        success "zoxide is already installed"
        set_up_zoxide_shell_config
        return 0
    fi

    echo "Install zoxide (smart cd like autojump)?('y' install; 'q' quit the scrip)"
    read -r respond
    if [ "$respond" = "y" ] || [ "$respond" = "yes" ]; then
        program_must_exist "curl"
        # This will install zoxide into ~/.local
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        set_up_zoxide_shell_config

    elif [ "$respond" = "q" ]; then
        exit 0
    fi
}

set_up_bash_tool(){
    local source_cmd="source $APP_PATH/bash_tools.sh"
    local source_cmd2="source ~/.$app_name/bash_tools.sh"
    if program_exists "zsh"; then
        # if not already contain source command
        file_contains "$source_cmd" ~/.zshrc 
        status_code=$?
        if [ "$status_code" != '0' ]; then
            file_contains "$source_cmd2" ~/.zshrc 
            status_code=$?
        fi
        if [ "$status_code" != '0' ]; then
            echo "Install terminal configuration script for zsh shell?('y' install; 'q' quit the scrip)"
            read -r respond
            if [ "$respond" = "y" ] || [ "$respond" = "yes" ]; then
                echo "$source_cmd" >> $HOME/.zshrc
            elif [ "$respond" = "q" ]; then
                exit 0
            fi
            success "Terminal configuration is sourced in zsh"
        fi
    fi

    if program_exists "bash"; then
        # if not already contain source command
        file_contains "$source_cmd" ~/.bashrc 
        status_code=$?
        if [ "$status_code" != '0' ]; then
            file_contains "$source_cmd2" ~/.bashrc 
            status_code=$?
        fi
        if [ "$status_code" != '0' ]; then
            echo "Install terminal configuration script for bash shell?('y' install; 'q' quit the scrip)"
            read -r respond
            if [ "$respond" = "y" ] || [ "$respond" = "yes" ]; then
                echo "$source_cmd" >> $HOME/.bashrc
            elif [ "$respond" = "q" ]; then
                exit 0
            fi
            success "Terminal configuration is sourced in bash"
        fi
    fi
}

############################ MAIN()
env_set "$HOME"

set_up_vim
set_up_tmux
set_up_bash_tool
set_up_zoxide

msg             "\nThanks for installing $app_name."
