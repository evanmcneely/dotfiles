# load aliases and secrets
source ~/.zsh-aliases.sh
source ~/.zsh-secrets.sh

# prompt powered by oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
    pyenv
)
ZSH_THEME="evans-2"
source $ZSH/oh-my-zsh.sh

# for zoxide to work
# eval "$(zoxide init zsh)" -- FIX: not found ??

# check for local zsh config extension
if [[ -r ~/.zsh-local.sh ]]; then
    source ~/.zsh-local.sh
else
    # do nothing
fi

export PATH="~/.dotfiles/bin:${PATH}"
