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
alias da="docker ps --format 'table {{.Names}}\t{{.Status}}'"
alias d='docker'
alias dr='docker run --rm -it'
alias de='docker exec -it'
alias dc='docker compose'
alias dcupd='docker compose up -d'
alias dcs='docker compose stop'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

# tmux
alias t='tmux'
alias ta='tmux attach'
alias td='tmux detach'
alias tl='tmux ls'

# other
alias v='vim'
alias n='nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rds="find . -name ".DS_Store" -delete"
alias luamake=/Users/evan/.config/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake
alias review='PYENV_VERSION=gpt-pp python ~/dev/personal/gpt_pp/cli_pr_review.py'
