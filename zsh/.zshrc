#### LP config

export PATH="/opt/homebrew/bin:${PATH}"

export LDFLAGS="-L$(brew --prefix zlib)/lib -L$(brew --prefix openssl@1.1)/lib -L$(brew --prefix libffi)/lib -L$(brew --prefix xz)/lib -L$(brew --prefix libjpeg)/lib ${LDFLAGS}"
export CPPFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix openssl@1.1)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix libffi)/include -I$(brew --prefix libjpeg)/include ${CPPFLAGS}"
export CFLAGS="-I$(brew --prefix zlib)/include -I$(brew --prefix openssl@1.1)/include -I$(brew --prefix bzip2)/include -I$(brew --prefix libffi)/include -I$(brew --prefix xz)/include ${CFLAGS}"

export LIBRARY_PATH="$(brew --prefix)/lib"
export CPATH="$(brew --prefix)/include"

# For compiling python libraries
export LIBMEMCACHED=$(brew --prefix libmemcached)
export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1

# Its really important to keep the architecture of your shell in mind
PROMPT="$(arch) ${PROMPT}"

eval "$(brew shellenv)"

# google-cloud-sdk (homebrew)
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Python/pyenv (homebrew)
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="${HOME}/.pyenv/shims:${PATH}"
export PATH="/opt/poetry/bin:/opt/poetry2/bin:${PATH}"


# Pip env variables for hydra libraries
export CPPFLAGS="-I/usr/local/include ${CPPFLAGS}"
export LDFLAGS="-L/usr/local/lib ${LDFLAGS}"

export PATH="/opt/poetry/bin:/opt/poetry2/bin:${PATH}"

source ~/.zsh-secrets.sh

export PATH="${HOME}/.local/bin:${PATH}"

#### Prompt
export ZSH=$HOME/.oh-my-zsh
plugins=(
    git-prompt
    pyenv
)
ZSH_THEME="evans-2"
source $ZSH/oh-my-zsh.sh

#### Aliases

# git
alias gcm='git commit -m'
alias ga='git add'
alias gs='git status'
alias gb='git branch'
alias gch='git checkout'
alias gpush='git push origin $(git symbolic-ref --short HEAD)'
alias gpull='git pull origin $(git symbolic-ref --short HEAD)'
alias gd='git diff'
alias gdm='git diff master..$(git symbolic-ref --short HEAD)'
alias gbprune='git branch | grep -v "master" | grep -v "main" | xargs git branch -D'
alias gwa='git worktree add'
alias gwr='git worktree remove'
alias gwl='git worktree list'
alias gwpd='git worktree prune --dry-run'
alias gwp='git worktree prune'
alias glog='git log --graph --oneline --decorate --all'

# docker
alias lpdu="docker compose -f ~/dev/lp/lp-docker/docker-compose.yml up --detach"
alias lpds="docker compose -f ~/dev/lp/lp-docker/docker-compose.yml stop"
alias lpdr="docker compose -f ~/dev/lp/lp-docker/docker-compose.yml restart"
alias lpdl="docker compose -f ~/dev/lp/lp-docker/docker-compose.yml logs -f"
alias da="docker ps --format 'table {{.Names}}\t{{.Status}}'"

alias d='docker'
alias dr='docker run --rm -it'
alias de='docker exec -it'
alias dc='docker compose'
alias dcupd='docker compose up -d'
alias dcs='docker compose stop'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

# other
alias cl='cd dev/lp'
alias v='vim'
alias n='nvim'
alias nightly='nv.sh'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias luamake=/Users/evan/.config/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake
