# Author: Evan Mcneely

# disable the default pyenv prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$bg[magenta]%}${FG[000]} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$bg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SEPARATOR="%{$bg[magenta]%}${FG[000]} "
ZSH_THEME_GIT_PROMPT_BRANCH="%{$bg[magenta]%}${FG[000]}\ue0a0 "
ZSH_THEME_GIT_PROMPT_STAGED="%{$bg[magenta]%}${FG[162]}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$bg[magenta]%}${FG[162]}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$bg[magenta]%}${FG[057]}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$bg[magenta]%}${FG[057]}%{-%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$bg[magenta]%}${FG[057]}%{ ↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$bg[magenta]%}${FG[057]}%{ ↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$bg[magenta]%}${FG[034]}%{…%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="%{$bg[magenta]%}${FG[057]}%{⚑%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$bg[magenta]%}${FG[034]}%{✔%G%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR="->"

# primary prompt 
PS1='${BG[008]}%{$fg[white]%} %n %{$bg[blue]%}${FG[000]}  $(arch)  $(pyenv_prompt_info)  $(node -v) %{$bg[cyan]%}  %3~ $(git_super_status) %{$reset_color%}
%B%{$fg[magenta]%} ⤷ %b%{$reset_color%}'

# secondary prompt
PS2='%{$fg[blue]%}\ %{$reset_color%}'

# override right prompt which contains the git status info via the git-prompt plugin
RPROMPT=''


