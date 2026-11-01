# Sourced by the project checks in scripts/checks.d/: provides pnpm and the app's dependencies.
# pnpm: the installed pnpm, or the version of package.json's packageManager through npx (CI
# has Git, bash, and Node.js only). deps_install: installs from the lock file, quietly; the
# output is printed only when the install fails.
pnpm() {
  if type -P pnpm >/dev/null 2>&1; then
    command pnpm "$@"
  else
    local version
    version=$(node -p 'require("./package.json").packageManager.split("@")[1].split("+")[0]')
    npx --yes "pnpm@$version" "$@"
  fi
}

deps_install() {
  local out
  if ! out=$(pnpm install --frozen-lockfile 2>&1); then
    printf '%s\n' "$out"
    echo "FAIL: pnpm install --frozen-lockfile"
    exit 1
  fi
}

# step <name> <command...>: runs the command quietly; on failure prints its output and the name
# of the step, and exits 1.
step() {
  local name=$1 out
  shift
  if ! out=$("$@" 2>&1); then
    printf '%s\n' "$out"
    echo "FAIL: $name"
    exit 1
  fi
}
