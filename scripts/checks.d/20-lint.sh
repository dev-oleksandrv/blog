#!/usr/bin/env bash
# Static checks of the app (ADR-0001 tools): the Prettier format check, ESLint with errors and
# warnings failing, and the TypeScript type checker. Prints little on success.
set -euo pipefail
cd "$(dirname "$0")/../.."
# shellcheck source=scripts/checks.d/lib/pnpm.sh
. scripts/checks.d/lib/pnpm.sh

deps_install
step "format (prettier --check)" pnpm exec prettier --check .
step "lint (eslint --max-warnings 0)" pnpm exec eslint --max-warnings 0 .
step "types (next typegen)" pnpm exec next typegen
step "types (tsc --noEmit)" pnpm exec tsc --noEmit
echo "== lint: format, lint, and types passed"
