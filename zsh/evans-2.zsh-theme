# Author: Evan Mcneely

# disable the default pyenv prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%} "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="\ue0a0 "
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[magenta]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}%{-%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[blue]%}%{ ↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[blue]%}%{ ↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}%{…%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[magenta]%}%{⚑%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR="->"

# primary prompt 
PS1='%{$fg[blue]%}╭─ %n %{$fg[red]%}  $(arch)  $(pyenv_prompt_info)  $(node -v) %{$fg[yellow]%}  %3~ $(git_super_status) %{$reset_color%}
%B%{$fg[blue]%}╰─%b%{$reset_color%} '

# secondary prompt
PS2='%{$fg[blue]%}\ %{$reset_color%}'

# override right prompt which contains the git status info via the git-prompt plugin
RPROMPT=''


