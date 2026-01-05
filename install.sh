#!/bin/bash
# Dotfiles installer - creates symlinks from home directory to this repo
#
# AI agent configs (Claude, Gemini, Codex) are in separate repos:
#   - https://github.com/ali-nr/claude-config
#   - https://github.com/ali-nr/gemini-config
#   - https://github.com/ali-nr/codex-config

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing dotfiles from $DOTFILES_DIR"

# ------------------------------------------------------------------------------
# Homebrew packages
# ------------------------------------------------------------------------------
ensure_brew_package() {
  local package_name="$1"

  # Special handling for claude-code: if 'claude' binary exists, skip.
  if [[ "$package_name" == "claude-code" ]]; then
    if command -v claude &>/dev/null; then
      echo "  $package_name (skipped - binary 'claude' found, assumed externally managed)"
      return 0
    fi
  fi

  # General logic for other packages
  # Check if installed by Homebrew (either formula or cask)
  local brew_managed=false
  if (set +e; brew list "$package_name" &>/dev/null); then
    brew_managed=true
  elif (set +e; brew list --cask "$package_name" &>/dev/null); then
    brew_managed=true
  fi

  if $brew_managed; then
    # Assume if it's brew-managed, brew outdated/upgrade knows how to handle it (formula or cask)
    if brew outdated --quiet "$package_name" &> /dev/null; then
      echo "  Upgrading $package_name..."
      brew upgrade --quiet "$package_name"
    else
      echo "  $package_name (up to date)"
    fi
  else
    echo "  Installing $package_name..."
    # If it's claude-code and reached here, it means binary was not found and not brew-managed
    if [[ "$package_name" == "claude-code" ]]; then
      brew install --cask --quiet "$package_name"
    else
      brew install --quiet "$package_name"
    fi
  fi
}

if command -v brew &> /dev/null; then
  echo "Checking Homebrew packages..."
  echo "Updating Homebrew..."
  brew update

  # CLI tools
  ensure_brew_package atuin        # Shell history sync
  ensure_brew_package fzf          # Fuzzy finder
  ensure_brew_package ripgrep      # Fast grep
  ensure_brew_package fd           # Fast find
  ensure_brew_package eza          # Modern ls
  ensure_brew_package bat          # Cat with syntax highlighting
  ensure_brew_package jq           # JSON processor
  ensure_brew_package gh           # GitHub CLI
  ensure_brew_package tmux         # Terminal multiplexer
  ensure_brew_package tmuxinator   # Tmux session manager

  # AI tools
  ensure_brew_package claude-code  # Claude Code CLI

  # Shell prompt
  ensure_brew_package starship     # Cross-shell prompt

  # Editor
  ensure_brew_package neovim       # Terminal editor

  echo "Homebrew packages done!"
else
  echo "Warning: Homebrew not found. Skipping package installation."
  echo "Install Homebrew: https://brew.sh"
fi

# ------------------------------------------------------------------------------
# Symlinks
# ------------------------------------------------------------------------------

# Shell
ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/aliases.zsh" "$HOME/.aliases.zsh"
ln -sf "$DOTFILES_DIR/zprofile" "$HOME/.zprofile"

# Git
ln -sf "$DOTFILES_DIR/gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/gitignore_global" "$HOME/.gitignore"

# Tmux
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.config/tmuxinator"
ln -sfn "$DOTFILES_DIR/tmuxinator" "$HOME/.config/tmuxinator"

# WezTerm
ln -sf "$DOTFILES_DIR/wezterm.lua" "$HOME/.wezterm.lua"
mkdir -p "$HOME/.config"
ln -sfn "$DOTFILES_DIR/wezterm" "$HOME/.config/wezterm"

# Starship prompt
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# VSCode
mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$DOTFILES_DIR/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

echo ""
echo "Dotfiles installed successfully!"
echo ""
echo "Symlinks created:"
echo "  ~/.zshrc"
echo "  ~/.aliases.zsh"
echo "  ~/.zprofile"
echo "  ~/.gitconfig"
echo "  ~/.gitignore"
echo "  ~/.tmux.conf"
echo "  ~/.config/tmuxinator/"
echo "  ~/.wezterm.lua"
echo "  ~/.config/wezterm/"
echo "  ~/.config/starship.toml"
echo "  ~/Library/Application Support/Code/User/settings.json"
echo ""
echo "Note: AI agent configs are in separate repos. Clone them separately:"
echo "  git clone git@github.com:ali-nr/claude-config.git ~/.claude"
echo "  git clone git@github.com:ali-nr/gemini-config.git ~/.gemini"
echo "  git clone git@github.com:ali-nr/codex-config.git ~/.codex"
