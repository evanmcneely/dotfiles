# Source all the things
source ~/.zsh-lp.sh
source ~/.zsh-aliases.sh
source ~/.zsh-secrets.sh

# Path to where nvim nightly script is
export PATH="${HOME}/.local/bin:${PATH}"

# Prompt powered by oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
    pyenv
)
ZSH_THEME="evans-2"
source $ZSH/oh-my-zsh.sh

# for zoxide to work
eval "$(zoxide init zsh)"
