# Autoload zsh add-zsh-hook and vcs_info functions (-U autoload w/o substition, -z use zsh style)
autoload -Uz add-zsh-hook vcs_info
# Enable substitution in the prompt.
setopt prompt_subst
# Run vcs_info just before a prompt is displayed (precmd)
add-zsh-hook precmd vcs_info
# Enable checking for (un)staged changes, enabling use of %u and %c
zstyle ':vcs_info:*' check-for-changes true
# Set custom strings for an unstaged vcs repo changes (*) and staged changes (+)
zstyle ':vcs_info:*' unstagedstr ' *'
zstyle ':vcs_info:*' stagedstr ' +'
# Set the format of the Git information for vcs_info
zstyle ':vcs_info:git:*' formats       '%F{green}(%b%F{red}%u%c%f%F{green})%f'
zstyle ':vcs_info:git:*' actionformats '(%b|%a%u%c)'

#export PS1='%F{green}%1~ %F{cyan}${vcs_info_msg_0_}%f '

local user="%B%(!.%F{red}.%F{green})%n%f "

local user_symbol='%(!.#.$)'
local current_dir="%B%F{cyan}%~ %f"

local vcs_branch='${vcs_info_msg_0_}'

#PROMPT="╭─${user}${current_dir}${vcs_branch}
#╰─%B${user_symbol}%b "

PROMPT="%F{magenta}› ${current_dir}${vcs_branch} "


