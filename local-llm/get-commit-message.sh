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

status="$(git status --short -- . "${ignore[@]}")"

diff="$(
  git diff --cached -- . "${ignore[@]}"
  git diff -- . "${ignore[@]}"
)"

if [ "${#diff}" -gt "$max_chars" ] || [ "${#status}" -gt "$max_chars" ]; then
  diff="$(git diff --cached -- . "${ignore[@]}")"
  status="$(git diff --cached --name-status -- . "${ignore[@]}")"
fi

[ -n "$status" ] || {
  echo "No changes after script ignores"
  exit 1
}

prompt='
# Role

You are a careful git commit message writer.

# Task

Write one Conventional Commit message for the provided git changes.

# Commit Type Rules

Use exactly one of these types:

- feat: for new user-visible behaviour, new commands, new options, or new workflow support
- fix: for bug fixes, broken behaviour, incorrect output, error handling, or cleanup of bad generated output
- docs: for documentation-only changes
- test: for test-only changes
- chore: for maintenance changes that do not affect behaviour

If multiple types apply, prefer this order:

1. fix
2. feat
3. docs
4. test
5. chore

# Constraints

- Output exactly one line
- Start with exactly one Conventional Commit type
- Do not use a scope unless it is clearly helpful
- Describe the concrete behavioural change
- Prefer specific verbs over generic words like update, improve, change, enhance
- Do not mention implementation details unless they are the user-visible point
- No markdown
- No quotes
- No trailing explanation

# Diff Interpretation Rules

- Lines starting with `+` are added by this change
- Lines starting with `-` are removed by this change
- Do not describe an added `rm`, `delete`, or cleanup command as removing code/files from the repository
- Describe the net behaviour introduced by the change
- Prefer the purpose of the change over the literal shell command names

# Good Examples

fix: strip terminal control characters from generated commit messages
feat: copy generated commit messages to the macOS clipboard
feat: notify when commit message generation finishes
fix: fall back to staged diff when working tree output is too large
docs: clarify staged and unstaged diff handling

# Bad Examples

chore: make changes
feat: enhance script
fix: update files
'

msg="$(
  printf '%s\n\nStatus:\n%s\n\nDiff:\n%s\n' \
    "$prompt" \
    "$status" \
    "$diff" |
    ollama run --nowordwrap qwen2.5-coder:7b |
    perl -pe 's/\e\[[0-9;?]*[ -\/]*[@-~]//g; s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]//g'
)"

printf '%s\n' "$msg"
printf '%s' "$msg" | pbcopy
osascript -e 'display notification "Commit message copied to clipboard" with title "git commit message"'
printf '\a'
