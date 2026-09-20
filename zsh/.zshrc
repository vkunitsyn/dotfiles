# --- Core Environment ---
export ZSH="$HOME/.oh-my-zsh"
# Auto-update check costs ~65-78ms per shell start; update manually with `omz update` instead.
export DISABLE_AUTO_UPDATE="true"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export EDITOR="nvim"
export VISUAL="nvim"

# Keep PATH entries unique; the blocks below prepend on every shell start
typeset -U path

# --- Autocompletion & Paths ---
fpath+=(
  /opt/homebrew/share/zsh/site-functions
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
)

# --- Oh My Zsh Plugins ---
plugins=(
  git
  brew
  macos
  colored-man-pages
  zsh-autosuggestions
  zoxide
  fzf
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- Prompt & CLI Tools ---
eval "$(starship init zsh)"

# --- FZF Settings ---
# fd respects .gitignore; fzf's built-in walker does not
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"

# Ctrl-T previews file contents, Alt-C previews the directory tree
export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :200 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"

# ** completion has its own options; it does not read FZF_CTRL_T_OPTS
# Path completion lists both files and directories, so pick the previewer per item
export FZF_COMPLETION_PATH_OPTS="--preview 'if [ -d {} ]; then eza --tree --level=2 --color=always {}; else bat -n --color=always --line-range :200 {}; fi'"
export FZF_COMPLETION_DIR_OPTS="--preview 'eza --tree --level=2 --color=always {}'"

# --- Aliases ---
alias ls="eza --group-directories-first --icons=auto"
alias ll="ls -al"
alias lg="lazygit"
alias cdb="cd -"

# --- Lazygit ---
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"

# --- Python Path ---
if [ -d "/opt/homebrew/opt/python/libexec/bin" ]; then
  export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
fi

# --- NVM Configuration ---
export NVM_DIR="$HOME/.nvm"

# Put the default node version's bin dir on PATH directly instead of sourcing
# nvm.sh eagerly (~300ms). Keeps node/npm/npx available everywhere (including
# for tools spawned from the shell, e.g. Neovim) without that cost.
# An exact alias (e.g. v22.11.0) is used as is; anything else (lts/*, node, 22)
# falls back to the newest installed version.
if [[ -d "$NVM_DIR/versions/node" ]]; then
  [[ -r "$NVM_DIR/alias/default" ]] && _nvm_default=$(<"$NVM_DIR/alias/default")
  [[ "$_nvm_default" != v* || ! -d "$NVM_DIR/versions/node/$_nvm_default" ]] && \
    _nvm_default=$(ls "$NVM_DIR/versions/node" | sort -V | tail -1)
  [[ -n "$_nvm_default" ]] && path=("$NVM_DIR/versions/node/$_nvm_default/bin" $path)
  unset _nvm_default
fi

# Load the real nvm() only on first actual use, so `nvm use`/`nvm install` etc. still work.
nvm() {
  unset -f nvm
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  nvm "$@"
}

# --- SDKMAN Configuration ---
export SDKMAN_DIR="/opt/homebrew/opt/sdkman-cli/libexec"

# Put each installed candidate's "current" bin dir on PATH directly instead of sourcing
# sdkman-init.sh eagerly (~30ms). Keeps java/gradle/etc. available for the shell and
# anything it spawns without that cost.
if [[ -d "$SDKMAN_DIR/candidates" ]]; then
  # (N): no error if the candidates directory is empty
  for _sdk_current in "$SDKMAN_DIR"/candidates/*/current(N); do
    [[ -d "$_sdk_current/bin" ]] || continue
    path=("$_sdk_current/bin" $path)
    export "${(U)${_sdk_current:h:t}}_HOME"="$_sdk_current"
  done
  unset _sdk_current
fi

# Load the real sdk() only on first actual use.
sdk() {
  unset -f sdk
  [[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
  sdk "$@"
}

# --- History Settings ---
HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=200000

setopt SHARE_HISTORY            # all sessions write immediately and read each other's commands
setopt EXTENDED_HISTORY         # store timestamps
setopt HIST_IGNORE_SPACE        # commands starting with a space are not saved
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS     # keep only the latest copy of a command
