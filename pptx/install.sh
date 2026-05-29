#!/usr/bin/env bash
# install.sh — claude-pptx-skill installer

set -e

DEST="${1:-$HOME/.claude/commands}"
SKILL_FILE="commands/pptx.md"

mkdir -p "$DEST"
cp "$SKILL_FILE" "$DEST/pptx.md"

echo "✓ Installed: $DEST/pptx.md"
echo "  Usage in Claude Code: /pptx <description>"
