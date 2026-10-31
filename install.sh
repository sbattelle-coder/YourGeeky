#!/usr/bin/env bash
# Installs YourGeeky into ~/.yourgeeky, puts the yourgeeky command on your PATH,
# and sets up the AI it uses: Google's free Antigravity CLI, or Claude Code for
# people with a paid Claude plan.
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

# Choose and set up the AI that YourGeeky uses. Google's is free; Claude Code
# needs a paid Claude plan.
engine="${YOURGEEKY_ENGINE:-}"
if [ -z "$engine" ]; then
  engine="google"
  if [ -r /dev/tty ] && { : < /dev/tty; } 2>/dev/null; then
    say ""
    say "YourGeeky can use Google's free AI, or Claude Code if you already pay for a Claude plan."
    printf 'Do you have a paid Claude plan (Pro or Max)? Most people answer n. [y/n] '
    answer=""
    read -r answer < /dev/tty || true
    case "$answer" in [Yy]*) engine="claude" ;; esac
  fi
fi
printf '%s\n' "$engine" > "$INSTALL_DIR/engine"

if [ -z "${YOURGEEKY_SKIP_ENGINE:-}" ]; then
  if [ "$engine" = "claude" ]; then
    if command -v claude >/dev/null 2>&1 || [ -x "$HOME/.local/bin/claude" ]; then
      say "Claude Code is already set up."
    else
      say ""
      say "Setting up Claude Code (the AI assistant from Anthropic)..."
      curl -fsSL https://claude.ai/install.sh | bash
    fi
  else
    if command -v agy >/dev/null 2>&1 || [ -x "$HOME/.local/bin/agy" ]; then
      say "Google's AI is already set up."
    else
      say ""
      say "Setting up Google's free AI (Antigravity CLI)..."
      curl -fsSL https://antigravity.google/cli/install.sh | bash
    fi
  fi
fi

say ""
say "All set. To start, type:  yourgeeky"
if [ "$engine" = "claude" ]; then
  say "The first time, you'll be asked to sign in to your Claude account."
else
  say "The first time, you'll be asked to sign in with your Google account. It's free."
fi
