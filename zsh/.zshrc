# path to dotfiles
export DOTFILES=$HOME/.dotfiles
# custom oh-my-zsh
ZSH_CUSTOM=$DOTFILES/zsh/zsh-custom
# disable oh-my-zsh update checks
zstyle ':omz:update' mode disabled

# load aliases and secrets

# prompt powered by oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
    pyenv
)
ZSH_THEME="evans"
source $ZSH/oh-my-zsh.sh

# for zoxide to work
# eval "$(zoxide init zsh)" -- FIX: not found ??

# check for local zsh config extension
if [[ -r ~/.zsh-local.sh ]]; then
    source ~/.zsh-local.sh
fi

export PATH="~/.local/bin:${PATH}"
