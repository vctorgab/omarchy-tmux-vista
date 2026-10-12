#!/usr/bin/env bash
# omarchy-tmux-vista installer: copies the scripts and adds the keybindings.
# Usage: ./install.sh [--no-bindings]
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
BINDINGS="$HOME/.config/hypr/bindings.lua"
BEGIN_MARK="# omarchy-tmux-vista: begin"
END_MARK="# omarchy-tmux-vista: end"

# --- 1. Dependencies -------------------------------------------------------
for cmd in tmux kitty jq hyprctl; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Missing dependency: $cmd" >&2; exit 1; }
done

# --- 2. Install scripts ----------------------------------------------------
mkdir -p "$BIN_DIR"
install -m 755 "$REPO_DIR/bin/tmux-vista" "$BIN_DIR/tmux-vista"
install -m 755 "$REPO_DIR/bin/hypr-layout-cycle" "$BIN_DIR/hypr-layout-cycle"
echo "✓ Scripts installed in $BIN_DIR"

# --- 3. Keybindings --------------------------------------------------------
if [[ "${1:-}" == "--no-bindings" ]]; then
  echo "↷ Skipping keybindings (--no-bindings)"
  exit 0
fi

mkdir -p "$(dirname "$BINDINGS")"
touch "$BINDINGS"

# Remove a previous block to stay idempotent
if grep -qF "$BEGIN_MARK" "$BINDINGS"; then
  sed -i "/^$BEGIN_MARK$/,/^$END_MARK$/d" "$BINDINGS"
fi

cat >> "$BINDINGS" << 'BINDINGS_BLOCK'
# omarchy-tmux-vista: begin
-- Tmux vista (Super+Alt+V): new terminal with an independent view of the
-- base session — one view per agent to watch them work in parallel.
o.bind("SUPER + ALT + V", "Tmux vista", "uwsm-app -- kitty --working-directory \"$(omarchy-cmd-terminal-cwd)\" bash -c '~/.local/bin/tmux-vista Work'")
-- Layout cycle (Super+L): dwindle -> master -> scrolling per workspace.
-- Comment out these two lines if you want to keep the default Super+L.
hl.unbind("SUPER + L")
o.bind("SUPER + L", "Cycle layout", "~/.local/bin/hypr-layout-cycle")
# omarchy-tmux-vista: end
BINDINGS_BLOCK

echo "✓ Keybindings added to $BINDINGS"
echo "  Super+Alt+V  → tmux vista"
echo "  Super+L      → cycle layout (comment out in $BINDINGS to keep the default)"
echo
echo "Done! Open the binding file or restart Hyprland (Super+Shift+R) to apply."
