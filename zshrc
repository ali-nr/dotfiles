# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# ------------------------------------------------------------------------------
# Oh My Zsh
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Disabled - using Starship instead
plugins=(git zsh-z zsh-autosuggestions zsh-syntax-highlighting)

# Faster compinit (only regenerate once per day)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# PATH & Environment
# ------------------------------------------------------------------------------
# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools"

# Go
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# n (Node.js version manager)
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ------------------------------------------------------------------------------
# Aliases & Functions
# ------------------------------------------------------------------------------
source ~/.aliases.zsh

# ------------------------------------------------------------------------------
# Tool Integrations
# ------------------------------------------------------------------------------
# Atuin (shell history sync)
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# Starship prompt
eval "$(starship init zsh)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export ANTHROPIC_API_KEY="REDACTED_ANTHROPIC_KEY"
export OPENAI_API_KEY="REDACTED_OPENAI_KEY"
export GOOGLE_GENERATIVE_AI_API_KEY="REDACTED_GOOGLE_KEY"
export GEMINI_API_KEY="$GOOGLE_GENERATIVE_AI_API_KEY"

# Tmuxinator alias
alias mux="tmuxinator"

# Added by Antigravity
export PATH="/Users/alireza/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity
export PATH="/Users/alireza/.antigravity/antigravity/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/util-linux/bin:$PATH"
