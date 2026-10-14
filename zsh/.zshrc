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
# Expose the default Node installation and its global packages without loading NVM.
# Follow aliases such as default -> lts/* -> lts/krypton -> v24.15.0.
function _nvm_default_path {
    local version=default
    local depth=0
    while [[ -r "$NVM_DIR/alias/$version" ]] && (( depth < 20 )); do
        version=$(<"$NVM_DIR/alias/$version")
        (( depth += 1 ))
    done
    local node_bin="$NVM_DIR/versions/node/v${version#v}/bin"
    if [[ -x "$node_bin/node" ]]; then
        path=("$node_bin" ${path:#"$node_bin"})
    fi
}
_nvm_default_path
unfunction _nvm_default_path

function _load_nvm {
    local nvm_script
    for nvm_script in /opt/homebrew/opt/nvm/nvm.sh /usr/local/opt/nvm/nvm.sh; do
        if [[ -s "$nvm_script" ]]; then
            unfunction nvm node npm npx corepack
            source "$nvm_script"
            return $?
        fi
    done
    print -u2 'NVM is not installed.'
    return 127
}

for _nvm_command in nvm node npm npx corepack; do
    functions[$_nvm_command]='_load_nvm || return; "$0" "$@"'
done
unset _nvm_command

# go stuff
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Opencode
export EDITOR=nvim
