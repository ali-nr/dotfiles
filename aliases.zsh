    alias devsetup='DEV_ENV=$(pwd) ./run.sh'
alias devsetup-dry='DEV_ENV=$(pwd) ./run.sh --dry'
alias restart='source ~/.zshrc'
alias reload='source ~/.zshrc'


alias codex='CODEX_HOME="$PWD/.codex" codex'

# Listing
alias la='ls -la'

# Editor
alias v='nvim'

# Claude shortcuts
cc() {
  claude --dangerously-skip-permissions "$@"
}

ccr() {
    claude --dangerously-skip-permissions --continue "$@"
}

# Gemini shortcuts (YOLO mode)
unalias gc 2>/dev/null
gc() {
    gemini --yolo "$@"
}

unalias gcr 2>/dev/null
gcr() {
    gemini --yolo --resume "$@"
}

# Codex shortcuts (bypass approvals and sandbox)
cx() {
    codex --dangerously-bypass-approvals-and-sandbox "$@"
}

cxr() {
    codex resume --last "$@"
}
