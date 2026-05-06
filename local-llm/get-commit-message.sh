#!/usr/bin/env bash
set -euo pipefail

max_chars=20000

ignore=(
  # macOS/editor junk
  ':(exclude).DS_Store'
  ':(exclude)**/.DS_Store'
  ':(exclude)*~'
  ':(exclude)*.swp'
  ':(exclude)*.swo'

  # local env/config/secrets
  ':(exclude).env'
  ':(exclude).env.*'
  ':(exclude)**/.env'
  ':(exclude)**/.env.*'

  # language/package caches
  ':(exclude)node_modules/**'
  ':(exclude)__pycache__/**'
  ':(exclude)**/__pycache__/**'
  ':(exclude)*.pyc'
  ':(exclude)**/.pytest_cache/**'
  ':(exclude)**/.mypy_cache/**'
  ':(exclude)**/.ruff_cache/**'
  ':(exclude)**/.tox/**'
  ':(exclude)**/.nox/**'
  ':(exclude)**/.venv/**'
  ':(exclude)**/venv/**'
  ':(exclude)**/.cpanm/**'

  # pixi/conda-ish env state
  ':(exclude).pixi/**'
  ':(exclude)**/.pixi/**'
  ':(exclude)conda-meta/**'
  ':(exclude)**/conda-meta/**'

  # common build outputs
  ':(exclude)build/**'
  ':(exclude)**/build/**'
  ':(exclude)dist/**'
  ':(exclude)**/dist/**'
  ':(exclude)target/**'
  ':(exclude)**/target/**'
  ':(exclude)out/**'
  ':(exclude)**/out/**'
  ':(exclude)tmp/**'
  ':(exclude)**/tmp/**'
  ':(exclude)temp/**'
  ':(exclude)**/temp/**'

  # CMake artefacts
  ':(exclude)CMakeFiles/**'
  ':(exclude)**/CMakeFiles/**'
  ':(exclude)CMakeCache.txt'
  ':(exclude)**/CMakeCache.txt'
  ':(exclude)cmake_install.cmake'
  ':(exclude)**/cmake_install.cmake'
  ':(exclude)Makefile'
  ':(exclude)**/Makefile'
  ':(exclude)compile_commands.json'
  ':(exclude)**/compile_commands.json'

  # binaries/archives/heavy generated files
  ':(exclude)*.o'
  ':(exclude)*.a'
  ':(exclude)*.so'
  ':(exclude)*.dylib'
  ':(exclude)*.dll'
  ':(exclude)*.exe'
  ':(exclude)*.bin'
  ':(exclude)*.class'
  ':(exclude)*.jar'
  ':(exclude)*.zip'
  ':(exclude)*.tar'
  ':(exclude)*.tar.gz'
  ':(exclude)*.tgz'
  ':(exclude)*.xz'
  ':(exclude)*.bz2'
  ':(exclude)*.gz'

  # logs/runtime junk
  ':(exclude)*.log'
  ':(exclude)**/logs/**'
  ':(exclude)**/.cache/**'
)

diff="$(git diff -- . "${ignore[@]}")"
status="$(git status --short -- . "${ignore[@]}")"

if [ "${#diff}" -gt "$max_chars" ] || [ "${#status}" -gt "$max_chars" ]; then
  diff="$(git diff --cached -- . "${ignore[@]}")"
  status="$(git diff --cached --name-status -- . "${ignore[@]}")"
fi

[ -n "$diff" ] || {
  echo "No changes after script ignores"
  exit 1
}

printf '%s\n\nStatus:\n%s\n\nDiff:\n%s\n' \
  'Write a one-line Conventional Commit message for these changes. Use one of: fix:, feat:, docs:, refactor:, test:, chore:. Summarize the specific change in 8-14 words. No markdown. No quotes.' \
  "$status" \
  "$diff" |
  ollama run gemma3:4b
