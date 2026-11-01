#!/usr/bin/env bash
# The fast check (CHECK_FAST in .claude/harness.conf, run by `scripts/env.sh fast`): the
# documentation checks, then Prettier and ESLint on the app files changed against origin/main
# (committed, staged, unstaged, and untracked), and the Vitest tests related to them. Prints
# little on success.
set -euo pipefail
cd "$(dirname "$0")/../../.."
# shellcheck source=scripts/checks.d/lib/pnpm.sh
. scripts/checks.d/lib/pnpm.sh

scripts/check-docs.sh >/dev/null

base=$(git merge-base HEAD origin/main 2>/dev/null || git rev-parse HEAD)
changed=()
while IFS= read -r f; do changed+=("$f"); done < <(
  { git diff --name-only --diff-filter=d "$base"; git ls-files --others --exclude-standard; } |
    sort -u | grep -E '\.(ts|tsx|js|jsx|mjs|cjs)$' || true
)
if [ "${#changed[@]}" -eq 0 ]; then
  echo "== fast: documentation passed; no app files changed"
  exit 0
fi

deps_install
step "format (prettier --check)" pnpm exec prettier --check --ignore-unknown "${changed[@]}"
step "lint (eslint --max-warnings 0)" pnpm exec eslint --max-warnings 0 "${changed[@]}"
step "related unit tests (vitest related)" pnpm exec vitest related --run --passWithNoTests "${changed[@]}"
echo "== fast: ${#changed[@]} changed app files passed format, lint, and related tests"
