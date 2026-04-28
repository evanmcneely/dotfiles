#!/usr/bin/env bash

set -Eeuo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="${DOTFILES_DIR}/BrewFile"
BACKUP_DIR="${HOME}/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

STOW_PACKAGES="${STOW_PACKAGES:-wezterm zsh nvim bat git bin}"
RUN_MACOS_DEFAULTS="${RUN_MACOS_DEFAULTS:-1}"

info() {
  printf '\n==> %s\n' "$1"
}

warn() {
  printf '\nWARN: %s\n' "$1" >&2
}

die() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

has() {
  command -v "$1" >/dev/null 2>&1
}

ensure_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || die "This setup script is intended for macOS."
}

ensure_xcode_cli_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  warn "Xcode Command Line Tools are not installed. macOS will open the installer now."
  xcode-select --install || true
  die "Install Xcode Command Line Tools, then rerun ./setup.sh."
}

load_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

install_homebrew() {
  load_homebrew

  if has brew; then
    return
  fi

  info "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_homebrew
  has brew || die "Homebrew install finished, but brew is still not on PATH."
}

ensure_brew_shellenv() {
  local brew_bin shellenv_line profile

  brew_bin="$(command -v brew)"
  shellenv_line="eval \"\$(${brew_bin} shellenv)\""
  profile="${HOME}/.zprofile"

  touch "$profile"
  if ! grep -Fqx "$shellenv_line" "$profile"; then
    printf '\n%s\n' "$shellenv_line" >>"$profile"
  fi
}

install_brew_bundle() {
  [[ -f "$BREWFILE" ]] || die "Missing BrewFile at ${BREWFILE}."

  info "Installing Homebrew packages"
  brew update
  brew bundle --file "$BREWFILE"
}

install_oh_my_zsh() {
  if [[ -d "${HOME}/.oh-my-zsh" ]]; then
    return
  fi

  info "Installing Oh My Zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

backup_path() {
  local target relative backup_target

  target="$1"
  relative="${target#${HOME}/}"
  backup_target="${BACKUP_DIR}/${relative}"

  if [[ ! -e "$target" && ! -L "$target" ]]; then
    return
  fi

  if [[ -L "$target" ]]; then
    local link_target
    link_target="$(readlink "$target")"
    if [[ "$link_target" == "${DOTFILES_DIR}"* || "$link_target" == *".dotfiles/"* ]]; then
      return
    fi
  fi

  if [[ -d "$target" ]] && contains_dotfile_symlinks "$target"; then
    return
  fi

  mkdir -p "$(dirname "$backup_target")"
  mv "$target" "$backup_target"
  warn "Moved existing ${target} to ${backup_target}"
}

contains_dotfile_symlinks() {
  local target link link_target

  target="$1"
  while IFS= read -r link; do
    link_target="$(readlink "$link")"
    if [[ "$link_target" == "${DOTFILES_DIR}"* || "$link_target" == *".dotfiles/"* ]]; then
      return 0
    fi
  done < <(find "$target" -maxdepth 2 -type l 2>/dev/null)

  return 1
}

backup_known_stow_conflicts() {
  info "Backing up known dotfile conflicts"

  backup_path "${HOME}/.zshrc"
  backup_path "${HOME}/.vimrc"
  backup_path "${HOME}/.gitconfig"
  backup_path "${HOME}/.gitignore_global"

  backup_path "${HOME}/.config/wezterm"
  backup_path "${HOME}/.config/nvim"
  backup_path "${HOME}/.config/tmux"
  backup_path "${HOME}/.config/bat"
}

stow_dotfiles() {
  info "Stowing dotfiles: ${STOW_PACKAGES}"
  mkdir -p "${HOME}/.config" "${HOME}/.local/bin"

  # shellcheck disable=SC2086
  stow --dir "$DOTFILES_DIR" --target "$HOME" --restow $STOW_PACKAGES
}

create_directories() {
  info "Creating development directories"
  mkdir -p "${HOME}/Dev/personal" "${HOME}/Dev/work"
}

install_keyboard_layouts() {
  local layouts_dir source_layout target_layout

  layouts_dir="${HOME}/Library/Keyboard Layouts"
  source_layout="${DOTFILES_DIR}/keyboards/evan_dev.keylayout"
  target_layout="${layouts_dir}/evan_dev.keylayout"

  [[ -f "$source_layout" ]] || die "Missing keyboard layout at ${source_layout}."

  info "Installing keyboard layouts"
  mkdir -p "$layouts_dir"
  install -m 0644 "$source_layout" "$target_layout"
}

install_tmux_plugins() {
  if [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    return
  fi

  info "Installing tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
}

source_tmux_config() {
  if ! has tmux; then
    return
  fi

  tmux source-file "${HOME}/.config/tmux/tmux.conf" >/dev/null 2>&1 || true
}

run_macos_defaults() {
  if [[ "$RUN_MACOS_DEFAULTS" != "1" ]]; then
    warn "Skipping macOS defaults because RUN_MACOS_DEFAULTS=${RUN_MACOS_DEFAULTS}."
    return
  fi

  info "Applying macOS defaults"
  bash "${DOTFILES_DIR}/.macos"
}

run_setup_commands() {
  local command

  ensure_macos

  for command in "$@"; do
    if [[ "$(type -t "$command")" != "function" || "$command" == "main" ]]; then
      die "Unknown setup function: ${command}"
    fi

    "$command"
  done
}

main() {
  if [[ $# -gt 0 ]]; then
    run_setup_commands "$@"
    return
  fi

  ensure_macos
  ensure_xcode_cli_tools
  install_homebrew
  ensure_brew_shellenv
  install_brew_bundle
  install_oh_my_zsh
  backup_known_stow_conflicts
  stow_dotfiles
  create_directories
  install_keyboard_layouts
  # install_tmux_plugins
  # source_tmux_config
  run_macos_defaults

  info "Setup complete"
  printf 'Open WezTerm or restart your shell to pick up the new configuration.\n'
}

main "$@"
