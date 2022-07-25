
# display git status
export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\e[0;32m\]\w\[\e[01;31m\]$(__git_ps1 " (%s)")\[\e[00m\] '
