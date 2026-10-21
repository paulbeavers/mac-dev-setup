# kitty-config

My [kitty](https://sw.kovidgoyal.net/kitty/) terminal configuration: a neon "Fluorescent" theme on a translucent, blurred black background.

## Install

```sh
git clone <repo-url> ~/kitty-config
~/kitty-config/install.sh
```

`install.sh` copies `kitty.conf` and `theme.conf` into `~/.config/kitty` (or `$KITTY_CONFIG_DIRECTORY` / `$XDG_CONFIG_HOME/kitty` if set). Any existing file that differs is backed up as `<name>.bak-<timestamp>` first.

Restart kitty after the first install so opacity, title bar and fullscreen settings take effect.

## Files

- `kitty.conf` — main settings: font size, opacity and blur, borders, margins, padding, focus follows mouse
- `theme.conf` — colors (included from `kitty.conf`)

## Notes

- `background_blur` requires kitty 0.32+.
- `macos_*` options are ignored on Linux.
