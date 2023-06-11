#!/usr/bin/env python3

""" preview.py theme arg
"""

import os
import sys

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    RED = '\033[31m'
    YELLOW = '\033[33m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

def is_tool(name):
    """Check whether `name` is on PATH and marked as executable."""
    from shutil import which
    return which(name) is not None

def get_preview_tool():
    exec = None
    if is_tool('bat'):
        exec = 'bat'
    elif is_tool('batcat'):
        exec = 'batcat'
    elif is_tool('cat'):
        exec = 'cat'
    return exec

if __name__ == '__main__':

    theme = sys.argv[1]
    if theme == 'light':
        theme = 'ansi'
        tcolor = '31'
        color = bcolors.RED
    else:
        theme = '1337'
        tcolor = '33'
        color = bcolors.YELLOW

    filepath = ''.join(sys.argv[2:])
    args = filepath.split(":")
    args += [None, None]

    file = args[0]
    center = args[1]
    # print(sys.argv[2:])
    # exit(0)
    # if os.name == 'nt':
    #     file += args[1]
    #     center = args[2]

    if file == None or not os.path.isfile(file):
      print("File not found {}".format(file))
      exit(0)

    if center is None: center = 0

    batcmd = get_preview_tool()
    cmdstr = None

    if file[0] == '-':
        file = './' + file
    if batcmd:
        if batcmd == 'cat':
            if center:
                cmdstr = 'cat -n {} | perl -pe "s/^.*?\s{}\s.*?$/\e[1;{}m$&\e[0m/g"'.format(file, center, tcolor)
            else:
                cmdstr = 'cat -n {}'.format(file)
        elif batcmd == 'bat':
            cmdstr = 'bat --theme={} --style=numbers --color=always \
            --pager=never --highlight-line={} "{}"'.format(theme, center, file)
        if cmdstr:
            os.system(cmdstr)
    else:
        f = open(file, 'r')
        Lines = f.readlines()
        center = int(center)
        linenr = 1

        for line in Lines:
            if linenr == center:
                print("{}{:4d} {}{}".format(color, linenr, line, bcolors.ENDC), end='')
            else:
                print("{:4d} {}".format(linenr, line), end='')
            linenr += 1
        f.close()



