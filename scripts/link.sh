DOTFILES="${HOME}/dev/dotfiles"

ln -sf "${DOTFILES}/zsh/.zshrc" ~
ln -sf "${DOTFILES}/zsh/.zsh-secrets.sh" ~
ln -sf "${DOTFILES}/vim/.vimrc" ~
ln -sf "${DOTFILES}/nvim" "${HOME}/.config"
ln -sf "${DOTFILES}/vim/.vim/coc-settings.json" "${HOME}/.vim"
ln -sf "${DOTFILES}/zsh/evans.zsh-theme" "${HOME}/.oh-my-zsh/themes"
ln -sf "${DOTFILES}/zsh/evans-2.zsh-theme" "${HOME}/.oh-my-zsh/themes"
ln -sf "${DOTFILES}/git/.gitignore_global" ~
ln -sf "${DOTFILES}/git/.gitconfig" ~
ln -sf "${DOTFILES}/scripts/nv.sh" "${HOME}/.local/bin/"
