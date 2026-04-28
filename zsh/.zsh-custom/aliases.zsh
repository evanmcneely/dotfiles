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
alias glog='git log --graph --oneline --decorate --all'

alias c="CLAUDE_CONFIG_DIR=~/.claude-personal claude --dangerously-skip-permissions"
alias cw="CLAUDE_CONFIG_DIR=~/.claude-work claude --dangerously-skip-permissions"

# Helper function to navigate to bare repo root
goto_bare_repo() {
    if git rev-parse --show-toplevel &>/dev/null; then
        # We're in a worktree, navigate to bare repo
        cd "$(git rev-parse --show-toplevel)"
        cd ..
    fi
    # If the command fails, we're already in the bare repo, do nothing
}
gwa() {
    local worktree_name="$1"
    if [[ -z "$worktree_name" ]]; then
      echo "Worktree name not provided"
      return 0
    fi
    # Navigate to repository root
    if git rev-parse --show-toplevel &>/dev/null; then
      # We're in a worktree, navigate to bare repo (assumes we are in worktree root)
      cd "$(git rev-parse --show-toplevel)"
      cd ..
    fi
    # Create the worktree
    git worktree add "$worktree_name"
    # Switch to worktree
    cd "$worktree_name"
}
gws(){
  local worktree_name="$1"
  if [[ -n "$worktree_name" ]]; then
    # Get the absolute path to the worktree if one was provided
    if git rev-parse --show-toplevel &>/dev/null; then
      # We're in a worktree
      local repo_root="$(git rev-parse --show-toplevel)"
      local worktree_path="$(realpath "$repo_root/../$worktree_name")"
    else
      # We're in the bare repo
      local worktree_path="$(realpath "./$worktree_name")"
    fi
    # Switch to the worktree if it exists
    if git worktree list | grep -q "$worktree_path"; then
      cd "$worktree_path"
    else
      echo "Worktree '$worktree_name' does not exist"
      return 1
    fi
  else
    # Otherwise fuzzy find a wortktree to switch too
    selected=$(git worktree list | fzf | awk '{print $1}')
    if [[ -z "$selected" ]]; then
      return 0
    fi
    cd "$selected"
  fi
}
gwch() {
  local branch_name="$1"
  if [[ -n "$branch_name" ]]; then
    # Try switching to the branch if one was provided
    if ! git checkout "$branch_name" --ignore-other-worktrees 2>/dev/null; then
      # Branch not found locally, try to fetch from origin
      echo "Branch '$branch_name' not found locally, fetching from origin..."
      git fetch origin "$branch_name:$branch_name" && git checkout "$branch_name" --ignore-other-worktrees
    fi
  else
    # Otherwise fuzzy find a branch to switch to.
    # Already checked branches can have prefixes in the branch list. We need to remove those before switching
    git checkout $(git branch | fzf | sed "s/^[* ] *//" | sed "s/^+ *//") --ignore-other-worktrees
  fi
}
gwr() {
  local worktree_name="$1"
  if [[ -n "$worktree_name" ]]; then
    # Get the absolute path to the worktree if one was provided
    if git rev-parse --show-toplevel &>/dev/null; then
      # We're in a worktree
      local repo_root="$(git rev-parse --show-toplevel)"
      local worktree_path="$(realpath "$repo_root/../$worktree_name")"
    else
      # We're in the bare repo
      local worktree_path="$(realpath "./$worktree_name")"
    fi
    # Remove to the worktree if it exists
    if git worktree list | grep -q "$worktree_path"; then
      git worktree remove "$worktree_path"
    else
      echo "Worktree '$worktree_name' does not exist"
      return 1
    fi
  else
    # Otherwise fuzzy find a worktree to remove
    git worktree remove $(git worktree list | fzf | awk '{print $1}')
  fi
}
alias gwl='git worktree list'
alias gwpd='git worktree prune --dry-run'
alias gwp='git worktree prune'

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

# other
alias v='vim'
alias n=' env TERM=wezterm nvim'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rds="find . -name ".DS_Store" -delete"
alias luamake=/Users/evan/.config/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake
alias fn='fd --type f --hidden --exclude .git | fzf-tmux -p | xargs nvim'
