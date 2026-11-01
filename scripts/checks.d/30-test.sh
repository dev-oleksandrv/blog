#!/usr/bin/env bash
# Unit tests of the app with Vitest (docs/testing-rules.md): offline and deterministic. Prints
# little on success.
set -euo pipefail
cd "$(dirname "$0")/../.."
# shellcheck source=scripts/checks.d/lib/pnpm.sh
. scripts/checks.d/lib/pnpm.sh

deps_install
step "unit tests (vitest run)" pnpm exec vitest run
echo "== test: unit tests passed"
