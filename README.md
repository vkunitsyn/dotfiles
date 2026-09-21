# Dotfiles

Non-sensitive configuration files stored in `~/config`, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a Stow package whose internal layout mirrors `$HOME`:

```
config/
├── zsh/.zshrc
├── tmux/.tmux.conf
├── kitty/.config/kitty/kitty.conf
├── lazygit/.config/lazygit/config.yml
└── git/.gitconfig
```

## Setup

```bash
brew install stow
cd ~/config
stow -t ~ zsh tmux kitty lazygit git
```

`stow` symlinks each package's files into `$HOME` at the matching relative path. Re-running it is safe (idempotent); add `-R` to re-link after moving the repo, or `-D` to unlink a package.

## Verify Symlinks

```bash
stow -t ~ -n -v zsh tmux kitty lazygit git   # dry run, shows what would (still) be linked
readlink -f ~/.zshrc ~/.tmux.conf ~/.config/kitty/kitty.conf ~/.config/lazygit/config.yml ~/.gitconfig
```

## Adding a new package

Create a directory named after the tool, laid out exactly as it should appear under `$HOME` (e.g. `nvim/.config/nvim/init.lua`), then `stow -t ~ nvim`.
