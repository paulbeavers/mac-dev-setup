#!/usr/bin/env bash
# Install Homebrew, kitty and CLI tools (macOS) and Claude Code, then the
# kitty config and zsh/bash rc files. Existing files are backed up with a
# timestamp suffix before being replaced.
#
#   ./install.sh              install everything
#   ./install.sh --no-brew    skip Homebrew, kitty and tools
#   ./install.sh --no-claude  skip Claude Code
set -euo pipefail

src_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kitty_dir="${KITTY_CONFIG_DIRECTORY:-${XDG_CONFIG_HOME:-$HOME/.config}/kitty}"
stamp="$(date +%Y%m%d-%H%M%S)"
brew_tools=(eza bat fd fzf zoxide)

with_brew=1
with_claude=1
for arg in "$@"; do
  case "$arg" in
    --no-brew) with_brew=0 ;;
    --no-claude) with_claude=0 ;;
    -h|--help) sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# Puts brew on PATH for the rest of this script, from wherever it lives.
load_brew() {
  local b
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$b" ]; then
      eval "$("$b" shellenv)"
      return 0
    fi
  done
  return 1
}

install_brew_and_kitty() {
  if [ "$(uname -s)" != Darwin ]; then
    echo "skipped: Homebrew and kitty (not macOS)"
    return
  fi

  if command -v brew >/dev/null || load_brew; then
    echo "present:   Homebrew"
  else
    echo "installing: Homebrew (it will ask for your password)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    load_brew || { echo "Homebrew installed but brew not found" >&2; exit 1; }
  fi

  if brew list --cask kitty >/dev/null 2>&1; then
    echo "present:   kitty (Homebrew)"
  elif [ -d /Applications/kitty.app ]; then
    echo "present:   kitty (/Applications/kitty.app, not from Homebrew)"
  else
    echo "installing: kitty"
    brew install --cask kitty
  fi

  # Command-line tools the zshrc and bashrc use when present.
  local tool missing=()
  for tool in "${brew_tools[@]}"; do
    if brew list --formula "$tool" >/dev/null 2>&1; then
      echo "present:   $tool"
    else
      missing+=("$tool")
    fi
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    echo "installing: ${missing[*]}"
    brew install "${missing[@]}"
  fi
}

# Anthropic's native installer, which puts claude in ~/.local/bin and
# keeps it updated itself.
install_claude_code() {
  if command -v claude >/dev/null || [ -x "$HOME/.local/bin/claude" ]; then
    echo "present:   Claude Code"
  else
    echo "installing: Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

if [ "$with_brew" = 1 ]; then
  install_brew_and_kitty
fi
if [ "$with_claude" = 1 ]; then
  install_claude_code
fi

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
