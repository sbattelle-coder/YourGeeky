#!/usr/bin/env bash
# Smoke tests for YourGeeky. Uses a fake claude so nothing real is run.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export YOURGEEKY_ALLOW_ANY_OS=1

# Fake claude: records its arguments.
cat > "$TMP/claude" <<'FAKE'
#!/usr/bin/env bash
for a in "$@"; do printf '%s\n--ARG--\n' "$a"; done > "$CLAUDE_ARGS_FILE"
FAKE
chmod +x "$TMP/claude"
export YOURGEEKY_CLAUDE="$TMP/claude" CLAUDE_ARGS_FILE="$TMP/args"

fails=0
check() {
  if eval "$2"; then printf 'ok   %s\n' "$1"; else printf 'FAIL %s\n' "$1"; fails=$((fails + 1)); fi
}

check "--version prints version" '"$ROOT/bin/yourgeeky" --version | grep -q "yourgeeky 0.1.0"'
check "--help explains usage" '"$ROOT/bin/yourgeeky" --help | grep -q "install Python"'
check "unknown option fails" '! "$ROOT/bin/yourgeeky" --bogus >/dev/null 2>&1'

"$ROOT/bin/yourgeeky" install Python >/dev/null
check "request is passed to claude" 'grep -q "^install Python$" "$TMP/args"'
check "guide is appended" 'grep -q "You are YourGeeky" "$TMP/args"'
check "commands hidden by default" 'grep -q "Hide raw commands" "$TMP/args"'
check "placeholder replaced" '! grep -q "COMMANDS_MODE" "$TMP/args"'

"$ROOT/bin/yourgeeky" --show-commands >/dev/null
check "--show-commands shows commands" 'grep -q "Show each command" "$TMP/args"'

# Installer, from this checkout into a temp home.
HOME="$TMP/home" PATH="/usr/bin:/bin" YOURGEEKY_SKIP_CLAUDE=1 YOURGEEKY_DIR="$TMP/home/.yourgeeky" \
  YOURGEEKY_BIN_DIR="$TMP/home/.local/bin" bash "$ROOT/install.sh" >/dev/null
check "installer links the command" '[ -L "$TMP/home/.local/bin/yourgeeky" ]'
check "installer adds PATH to .zshrc" 'grep -q ".local/bin" "$TMP/home/.zshrc"'
check "installed command runs via symlink" '"$TMP/home/.local/bin/yourgeeky" --version | grep -q 0.1.0'
"$TMP/home/.local/bin/yourgeeky" hi >/dev/null
check "installed command finds guide" 'grep -q "You are YourGeeky" "$TMP/args"'

if [ "$fails" -gt 0 ]; then echo "$fails test(s) failed"; exit 1; fi
echo "All tests passed"
