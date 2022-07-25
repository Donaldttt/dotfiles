
# display git status
export GIT_PS1_SHOWDIRTYSTATE=1
if [[ $(type -t __git_ps1) != function ]]; then
    __git_ps1(){

        local branch=`git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/\1/'`
        
        if [ $? ]; then
            status=`git status 2>/dev/null`
            local stage_info="not staged for commit"
            local commit_info="Changes to be committed"

            local stage_sign=''
            local commit_sign=''
            [[ "$status" == *"$stage_info"* ]] && stage_sign=" *"
            [[ "$status" == *"$commit_info"* ]] && commit_sign=" +"
            echo "(${branch}${stage_sign}${commit_sign})"
        fi
    }
fi
export PS1=' \[\e[0;32m\]\w\[\e[01;31m\]$(__git_ps1 "(%s)")\[\e[00m\]$ '
