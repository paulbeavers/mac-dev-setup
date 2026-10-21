#!/usr/bin/env bash
# Install this kitty config and the zsh/bash rc files.
# Existing files are backed up with a timestamp suffix before being replaced.
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kitty_dir="${KITTY_CONFIG_DIRECTORY:-${XDG_CONFIG_HOME:-$HOME/.config}/kitty}"
stamp="$(date +%Y%m%d-%H%M%S)"

# install_file <source> <destination>
install_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ]; then
    if cmp -s "$src" "$dest"; then
      echo "unchanged: $dest"
      return
    fi
    cp "$dest" "$dest.bak-$stamp"
    echo "backed up: $dest -> $(basename "$dest").bak-$stamp"
  fi
  cp "$src" "$dest"
  echo "installed: $dest"
}

install_file "$src_dir/kitty.conf"   "$kitty_dir/kitty.conf"
install_file "$src_dir/theme.conf"   "$kitty_dir/theme.conf"
install_file "$src_dir/shell/zshrc"  "$HOME/.zshrc"
install_file "$src_dir/shell/bashrc" "$HOME/.bashrc"

echo "Done. Reload kitty with ctrl+cmd+, (macOS) or ctrl+shift+F5, or restart it."
echo "Open a new shell (or run: exec \$SHELL) to pick up the rc files."
