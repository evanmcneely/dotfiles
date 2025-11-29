export DOTFILES=$HOME/.dotfiles
ZSH_CUSTOM=$DOTFILES/zsh/.zsh-custom

# disable oh-my-zsh update checks
zstyle ':omz:update' mode disabled

# prompt powered by oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
    pyenv
)
ZSH_THEME="evans"
source $ZSH/oh-my-zsh.sh

# check for local zsh config extension
if [[ -r $HOME/.zsh-local.sh ]]; then
    source $HOME/.zsh-local.sh
fi

eval "$(zoxide init zsh)"

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# go stuff
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

