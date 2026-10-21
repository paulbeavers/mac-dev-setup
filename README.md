# mac-dev-setup

My Mac development setup: Homebrew, the [kitty](https://sw.kovidgoyal.net/kitty/) terminal with a neon "Fluorescent" theme on a translucent, blurred black background, and zsh/bash config.

## Install

```sh
git clone <repo-url> ~/mac-dev-setup
~/mac-dev-setup/install.sh
```

On macOS, `install.sh` first installs [Homebrew](https://brew.sh), kitty (`brew install --cask kitty`) and the CLI tools the shell config uses (`eza bat fd fzf zoxide`), skipping any already installed. On any OS it installs [Claude Code](https://claude.com/claude-code) with Anthropic's native installer if `claude` is missing. Pass `--no-brew` or `--no-claude` to skip either step.

It then copies:

- `kitty.conf` and `theme.conf` into `~/.config/kitty` (or `$KITTY_CONFIG_DIRECTORY` / `$XDG_CONFIG_HOME/kitty` if set)
- `shell/zshrc` to `~/.zshrc`
- `shell/bashrc` to `~/.bashrc`

Any existing file that differs is backed up as `<name>.bak-<timestamp>` first.

Restart kitty after the first install so opacity, title bar and fullscreen settings take effect, and open a new shell to pick up the rc files.

## Files

- `kitty.conf` — main settings: font size, opacity and blur, borders, margins, padding, focus follows mouse, pane shortcuts
- `theme.conf` — colors (included from `kitty.conf`)
- `shell/zshrc`, `shell/bashrc` — prompt with git status, history, completion, aliases; the CLI tools are used when present

## Notes

- `background_blur` requires kitty 0.32+.
- `macos_*` options are ignored on Linux.
