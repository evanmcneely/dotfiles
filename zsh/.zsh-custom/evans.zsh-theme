# Author: Evan Mcneely

# disable the default pyenv prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

#colors
BLUE="${FG[012]}"
YELLOW="${FG[011]}"
GREEN="${FG[010]}"
MAGENTA="%{$fg[magenta]%}"
RED="${FG[009]}"
GREY="${FG[008]}"

NAME=${YELLOW}
SYSTEM=${RED}
DIR=${GREEN}
PROMPT_SYMBOL=${YELLOW}

# git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="${BLUE} "
ZSH_THEME_GIT_PROMPT_SUFFIX="${BLUE} "
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_BRANCH="\ue0a0 "
ZSH_THEME_GIT_PROMPT_STAGED="${YELLOW}%{󰧞%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="${YELLOW}%{󰅖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="${RED}%{󰐕%G%}"
ZSH_THEME_GIT_PROMPT_DELETED="${RED}%{󰍴%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="${BLUE}%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="${BLUE}%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${GREEN}%{…%G%}"
ZSH_THEME_GIT_PROMPT_STASHED="${MAGENTA}%{⚑%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="${GREEN}%{󰄬%G%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SEPARATOR="${BLUE}%{%G%}"

# node
function node_version {
  if [[ -x "$(command -v node)" ]] then
    echo " $(node -v | cut -c 2-)"
  fi
}

# if there is a python virtualenv active show the name other wiseshow system version
function pyenv_info {
  if [[ -n "$VIRTUAL_ENV" ]] then
    echo " $(pyenv_prompt_info) "
  else
    echo " $(python3 -V | cut -c 8-) "
  fi
}

# primary prompt
PS1='
${DIR}  %2~$(git_super_status) %{$reset_color%}
${PROMPT_SYMBOL}%{$reset_color%} '

# secondary prompt
# PS2='${BLUE}\ %{$reset_color%}'

# override right prompt which contains the git status info via the git-prompt plugin
RPROMPT=''


