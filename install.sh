#!/usr/bin/env bash
# Install this kitty config into kitty's config directory.
# Existing files are backed up with a timestamp suffix before being replaced.
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
dest_dir="${KITTY_CONFIG_DIRECTORY:-${XDG_CONFIG_HOME:-$HOME/.config}/kitty}"
stamp="$(date +%Y%m%d-%H%M%S)"

mkdir -p "$dest_dir"

for f in kitty.conf theme.conf; do
  if [ -e "$dest_dir/$f" ]; then
    if cmp -s "$src_dir/$f" "$dest_dir/$f"; then
      echo "unchanged: $dest_dir/$f"
      continue
    fi
    cp "$dest_dir/$f" "$dest_dir/$f.bak-$stamp"
    echo "backed up: $dest_dir/$f -> $f.bak-$stamp"
  fi
  cp "$src_dir/$f" "$dest_dir/$f"
  echo "installed: $dest_dir/$f"
done

echo "Done. Reload kitty with ctrl+cmd+, (macOS) or ctrl+shift+F5, or restart it."
