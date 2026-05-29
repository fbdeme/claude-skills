#!/usr/bin/env bash
# Initialize the docs-pattern in the current project's docs/ directory.
# Usage:
#   bash init-docs.sh              # all 5 files including research_method.md
#   bash init-docs.sh --no-research # 4 files, skip research_method.md
#
# Existing files are NEVER overwritten.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../templates" && pwd)"

INCLUDE_RESEARCH=1
for arg in "$@"; do
  case "$arg" in
    --no-research) INCLUDE_RESEARCH=0 ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# //;s/^#//'
      exit 0
      ;;
    *) echo "unknown arg: $arg" >&2; exit 2 ;;
  esac
done

mkdir -p docs

FILES=(current_status.md history.md issues.md todo.md)
[ "$INCLUDE_RESEARCH" = "1" ] && FILES+=(research_method.md)

CREATED=()
SKIPPED=()
for f in "${FILES[@]}"; do
  if [ -e "docs/$f" ]; then
    SKIPPED+=("$f")
  else
    cp "$TEMPLATES_DIR/$f" "docs/$f"
    CREATED+=("$f")
  fi
done

if [ "${#CREATED[@]}" -gt 0 ]; then
  echo "created in docs/:"
  printf '  %s\n' "${CREATED[@]}"
fi
if [ "${#SKIPPED[@]}" -gt 0 ]; then
  echo "skipped (already exists):"
  printf '  %s\n' "${SKIPPED[@]}"
fi
