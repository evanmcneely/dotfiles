DOTFILES="${HOME}/dev/dotfiles"

# TODO: fancy script like this https://github.com/paulirish/dotfiles/blob/main/symlink-setup.sh

# create directories needed to store symlinks
mkdir -p "${HOME}/.dotfiles/bin"

# scripts
ln -sf "${DOTFILES}/bin/git-delete-merged-branches" "${HOME}/.dotfiles/bin"

# zsh
ln -sf "${DOTFILES}/zsh/.zshrc" ~
ln -sf "${DOTFILES}/zsh/.zsh-aliases.sh" ~
ln -sf "${DOTFILES}/zsh/.zsh-local.sh" ~
ln -sf "${DOTFILES}/zsh/evans-2.zsh-theme" "${HOME}/.oh-my-zsh/themes"

# terms
ln -sf "${DOTFILES}/terms/.wezterm.lua" ~

# vim
ln -sf "${DOTFILES}/vim/.vimrc" ~
ln -sf "${DOTFILES}/vim/.vim/coc-settings.json" "${HOME}/.vim"

# nvim
ln -sf "${DOTFILES}/nvim_2023" "${HOME}/.config"

# git
ln -sf "${DOTFILES}/git/.gitignore_global" ~
ln -sf "${DOTFILES}/git/.gitconfig" ~
# Check if .gitignore_local file exists
if [ -f "{DOTFILES}/git/.gitignore_local" ]; then
    # Create symlink to home directory
    ln -sf "{DOTFILES}/git/.gitignore_local" ~
fi

# vscode/cursor
ln -sf "${DOTFILES}/vscode/settings.json" "${HOME}/Library/Application Support/Cursor/User"
ln -sf "${DOTFILES}/vscode/keybindings.json" "${HOME}/Library/Application Support/Cursor/User"
