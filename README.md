# Dotfiles

Non-sensitive configuration files stored in `~/Documents/config`.

## Symlinks Setup

```bash
ln -sf ~/Documents/config/.zshrc ~/.zshrc
ln -sf ~/Documents/config/.tmux.conf ~/.tmux.conf
```

## Verify Symlinks

```bash
ls -la ~ | grep -E '\.zshrc|\.tmux.conf'
```
