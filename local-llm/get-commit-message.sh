#!/usr/bin/env bash
set -euo pipefail

diff="$(git diff --cached)"

[ -n "$diff" ] || {
  echo "No staged changes"
  exit 1
}

printf '%s\n\n%s\n' \
  'Write a short Conventional Commit message for this diff. Use one of: fix:, feat:, docs:, refactor:, test:, chore:. No markdown. No quotes.' \
  "$diff" |
  ollama run gemma3:4b |
  head -n 1
