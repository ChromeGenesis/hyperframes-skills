#!/usr/bin/env bash
# Install the HyperFrames skill kit into another agent.
#   ./install-to-agent.sh opencode   -> ~/.config/opencode/skills
#   ./install-to-agent.sh claude     -> ~/.claude/skills
#   ./install-to-agent.sh agents      -> ~/.agents/skills
#   ./install-to-agent.sh project     -> ./.opencode/skills (current directory)
set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
TARGET="${1:-opencode}"

case "$TARGET" in
  opencode) DEST="$HOME/.config/opencode/skills" ;;
  claude)   DEST="$HOME/.claude/skills" ;;
  agents)   DEST="$HOME/.agents/skills" ;;
  project)  DEST="$(pwd)/.opencode/skills" ;;
  *) echo "usage: $0 {opencode|claude|agents|project}" >&2; exit 1 ;;
esac

mkdir -p "$DEST"
COPIED=0
for d in "$KIT_DIR"/*/; do
  name="$(basename "$d")"
  [ -f "$d/SKILL.md" ] || continue          # skip the hf-blocks/ container
  rm -rf "$DEST/$name"
  cp -R "$d" "$DEST/$name"
  COPIED=$((COPIED+1))
done

# nested registry blocks (hf-blocks/*/SKILL.md -> id = folder name)
if [ -d "$KIT_DIR/hf-blocks" ]; then
  mkdir -p "$DEST/hf-blocks"
  for d in "$KIT_DIR"/hf-blocks/*/; do
    name="$(basename "$d")"
    [ -f "$d/SKILL.md" ] || continue
    rm -rf "$DEST/hf-blocks/$name"
    cp -R "$d" "$DEST/hf-blocks/$name"
    COPIED=$((COPIED+1))
  done
fi

echo "installed $COPIED skills into $DEST"
