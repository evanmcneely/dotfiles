export DOTFILES=$HOME/.dotfiles
ZSH_CUSTOM=$DOTFILES/zsh/.zsh-custom

# disable oh-my-zsh update checks
zstyle ':omz:update' mode disabled

# prompt powered by oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
)
ZSH_THEME="evans"
source $ZSH/oh-my-zsh.sh

# check for local zsh config extension
if [[ -r $HOME/.zsh-local.sh ]]; then
    source $HOME/.zsh-local.sh
fi

export PATH="${HOME}/.local/bin:${PATH}"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# node/npm via Homebrew nvm
export NVM_DIR="$HOME/.nvm"
if [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
elif [[ -s "/usr/local/opt/nvm/nvm.sh" ]]; then
    source "/usr/local/opt/nvm/nvm.sh"
fi

# go stuff
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Opencode
export EDITOR=nvim
