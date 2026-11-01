#!/usr/bin/env bash
# SETUP and RESET in .claude/harness.conf: installs the app's dependencies from the lock file,
# with pnpm through npx where pnpm is not installed.
set -euo pipefail
cd "$(dirname "$0")/../../.."
# shellcheck source=scripts/checks.d/lib/pnpm.sh
. scripts/checks.d/lib/pnpm.sh

deps_install
echo "== install: dependencies installed from pnpm-lock.yaml"
