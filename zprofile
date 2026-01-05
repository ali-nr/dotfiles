# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.pre.zsh"

# Homebrew - check both locations
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "$HOME/homebrew/bin/brew" ]]; then
  eval "$($HOME/homebrew/bin/brew shellenv)"
fi
eval "$(pyenv init --path)"

# Created by `pipx` on 2025-07-12 01:20:21
export PATH="$PATH:/Users/alireza/.local/bin"
[[ -f ~/.zshrc ]] && source ~/.zshrc

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zprofile.post.zsh"
