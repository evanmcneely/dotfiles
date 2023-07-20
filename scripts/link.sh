DOTFILES="${HOME}/dev/dotfiles"

# zsh
ln -sf "${DOTFILES}/zsh/.zshrc" ~
ln -sf "${DOTFILES}/zsh/.zsh-aliases.sh" ~
ln -sf "${DOTFILES}/zsh/.zsh-lp.sh" ~
ln -sf "${DOTFILES}/zsh/evans.zsh-theme" "${HOME}/.oh-my-zsh/themes"
ln -sf "${DOTFILES}/zsh/evans-2.zsh-theme" "${HOME}/.oh-my-zsh/themes"
ln -sf "${DOTFILES}/zsh/.wezterm.lua" "${HOME}/.wezterm.lua"

# vim
ln -sf "${DOTFILES}/vim/.vimrc" ~
ln -sf "${DOTFILES}/vim/.vim/coc-settings.json" "${HOME}/.vim"

# nvim
ln -sf "${DOTFILES}/nvim" "${HOME}/.config"
ln -sf "${DOTFILES}/scripts/nv.sh" "${HOME}/.local/bin/"

# git
ln -sf "${DOTFILES}/git/.gitignore_global" ~
ln -sf "${DOTFILES}/git/.gitconfig" ~

#vscode
ln -sf "${DOTFILES}/vscode/settings.json" "${HOME}/Library/Application Support/Cursor/User"
ln -sf "${DOTFILES}/vscode/keybindings.json" "${HOME}/Library/Application Support/Cursor/User"
