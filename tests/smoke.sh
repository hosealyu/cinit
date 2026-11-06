#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="$repo_root/cinit"

if ! command -v make >/dev/null 2>&1; then
  printf 'Skipping smoke test: make is not installed in this environment.\n' >&2
  exit 0
fi

work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT
project_dir="$work_dir/generated-project"

printf 'Running cinit smoke test...\n'
"$script_path" --build-tool make --target "$project_dir" --no-git >/dev/null

for required in \
  "$project_dir/Makefile" \
  "$project_dir/README.md" \
  "$project_dir/src/main.c" \
  "$project_dir/src/hello.c" \
  "$project_dir/include/hello.h" \
  "$project_dir/tests/test_hello.c"; do
  if [[ ! -f "$required" ]]; then
    printf 'Smoke test failed: missing expected file: %s\n' "$required" >&2
    exit 1
  fi
done

(
  cd -- "$project_dir"
  make >/dev/null
  make test >/dev/null
  ./"$(basename -- "$project_dir")" > /tmp/cinit-smoke-output.txt
)

if ! grep -q 'Hello, world!' /tmp/cinit-smoke-output.txt; then
  printf 'Smoke test failed: generated executable did not print the expected greeting.\n' >&2
  exit 1
fi

printf 'Smoke test passed.\n'
