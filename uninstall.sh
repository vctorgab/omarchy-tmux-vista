#!/usr/bin/env bash
# omarchy-tmux-vista uninstaller: removes scripts and keybindings.
set -euo pipefail

BIN_DIR="$HOME/.local/bin"
BINDINGS="$HOME/.config/hypr/bindings.lua"
BEGIN_MARK="# omarchy-tmux-vista: begin"
END_MARK="# omarchy-tmux-vista: end"

rm -f "$BIN_DIR/tmux-vista" "$BIN_DIR/hypr-layout-cycle"
echo "✓ Scripts removed from $BIN_DIR"

if [[ -f $BINDINGS ]] && grep -qF "$BEGIN_MARK" "$BINDINGS"; then
  sed -i "/^$BEGIN_MARK$/,/^$END_MARK$/d" "$BINDINGS"
  echo "✓ Keybindings removed from $BINDINGS"
else
  echo "↷ No keybindings block found"
fi

echo "Bye bye! 👋"
