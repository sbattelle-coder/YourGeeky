#!/usr/bin/env bash
# Installs YourGeeky into ~/.yourgeeky and puts the yourgeeky command on your PATH.
#
#   curl -fsSL https://raw.githubusercontent.com/sbattelle-coder/YourGeeky/main/install.sh | bash
#
# Run from a downloaded copy of the repo, it installs that copy instead.

set -euo pipefail

REPO_TARBALL="${YOURGEEKY_TARBALL:-https://github.com/sbattelle-coder/YourGeeky/archive/refs/heads/main.tar.gz}"
INSTALL_DIR="${YOURGEEKY_DIR:-$HOME/.yourgeeky}"
BIN_DIR="${YOURGEEKY_BIN_DIR:-$HOME/.local/bin}"

say() { printf '%s\n' "$*"; }

say "Installing YourGeeky..."

src=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "$here/bin/yourgeeky" ]; then
    src="$here"
  fi
fi

tmp=""
if [ -z "$src" ]; then
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  curl -fsSL "$REPO_TARBALL" | tar -xz -C "$tmp" --strip-components 1
  src="$tmp"
fi

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR" "$BIN_DIR"
cp -R "$src/bin" "$src/prompts" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/bin/yourgeeky"
ln -sf "$INSTALL_DIR/bin/yourgeeky" "$BIN_DIR/yourgeeky"

# Make sure new Terminal windows can find the command.
case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    rc="$HOME/.zshrc"
    line="export PATH=\"$BIN_DIR:\$PATH\""
    if ! grep -qsF "$line" "$rc"; then
      printf '\n# Added by YourGeeky\n%s\n' "$line" >> "$rc"
    fi
    say "Open a new Terminal window so it can find YourGeeky."
    ;;
esac

say ""
say "YourGeeky is installed. To start it, type:  yourgeeky"
