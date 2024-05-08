""" cross platform installation script
"""
import subprocess
import os
import urllib.request

from os.path import expanduser, join
from shutil import which

home = expanduser("~") 
app_name = 'dotfiles'
APP_PATH = join(home, '.' + app_name)
REPO_URL = 'https://github.com/Donaldttt/' + app_name
REPO_BRANCH = 'dev'
VIM_RTPATH = join(home, '.vim')

def exist(app):
    return which(app) is not None

def program_must_exist(app):
    if not exist(app):
        fatal_error("must be installed to continue")

def fatal_error(msg):
    print('Error:', msg)
    exit()

def msg(msg):
    print(msg)

def execute(cmd, cwd=None):
    out = subprocess.check_output(
        cmd,
        stderr=subprocess.STDOUT,
        shell=True,
        cwd=None
    )
    print(out)

def sync_repo(repo_path, repo_url, repo_branch, repo_name):
    if not os.path.exists(repo_path):
        msg('Trying to clone ' + repo_name)
        cmd = "git clone -b {} {} {}".format(repo_branch, repo_url, repo_path)
        execute(cmd)
    else:
        msg('Trying to update ' + repo_name)
        cmd = "git pull origin {}".format(repo_branch)
        execute(cmd, cwd=APP_PATH)

def setup_vimplug():

    vimplug_path = VIM_RTPATH + "\\autoload\\plug.vim"
    if not os.path.isdir(os.path.dirname(vimplug_path)):
        os.makedirs(os.path.dirname(vimplug_path))
    urllib.request.urlretrieve("https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim", vimplug_path)
    print("Please execute :PlugInstall in vim")

def setup_nvim():
    if exist('nvim'):
        nvim_dir = home + '\\AppData\\Local\\nvim\\'
        nvim_config = nvim_dir + 'init.vim'
        if not os.path.isdir(nvim_dir):
            os.mkdir(nvim_dir)
        msg('Setting up neovim config')
        with open(nvim_config, 'w') as f:
            f.write('''set runtimepath^=~/.vim runtimepath+=~/.vim/after
            let &packpath=&runtimepath
            source ~/.vimrc''')

def setup_vim():
    if not exist('vim') and not exist('nvim'):
        fatal_error('Error: vim or nvim has to be installed.')
    program_must_exist('git')
    sync_repo(APP_PATH, REPO_URL, REPO_BRANCH, app_name)
    path = join(home, '.vimrc')
    if os.path.exists(path):
        os.remove(path)
    os.symlink(join(APP_PATH, '.vimrc'), join(home, '.vimrc'))
    path = join(home, '.vimrc.bundles')
    if os.path.exists(path):
        os.remove(path)
    os.symlink(join(APP_PATH, '.vimrc.bundles'), join(home, '.vimrc.bundles'))
    setup_nvim()
    setup_vimplug()
    msg("Done!")

setup_vim()
