# Aliases

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
