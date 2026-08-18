# --- Core Environment ---
export ZSH="$HOME/.oh-my-zsh"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export TERM="xterm-256color"

export EDITOR="nvim"
export VISUAL="nvim"

# --- Autocompletion & Paths ---
fpath+=(
  /opt/homebrew/share/zsh/site-functions
  ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
)

# --- Python Path ---
if [ -d "/opt/homebrew/opt/python/libexec/bin" ]; then
  export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
fi

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

# FZF Settings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --hidden --follow --exclude .git"

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# SDKMAN Configuration
export SDKMAN_DIR="/opt/homebrew/opt/sdkman-cli/libexec"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# --- Aliases ---
alias ls="eza --group-directories-first --icons"
alias ll="ls -al"
alias lg="lazygit"
alias cdb="cd -"

# --- History Settings ---
HISTFILE=$HOME/.zsh_history
HISTSIZE=200000
SAVEHIST=200000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY_TIME
unsetopt SHARE_HISTORY

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
