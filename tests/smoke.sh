#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
script_path="$repo_root/cinit"

compiler_name="cc"
for candidate in cc gcc clang; do
  if command -v "$candidate" >/dev/null 2>&1; then
    compiler_name="$candidate"
    break
  fi
done
compiler_path="$(command -v "$compiler_name" || true)"
if [[ -z "$compiler_path" ]]; then
  printf 'Skipping smoke test: no C compiler is installed in this environment.\n' >&2
  exit 0
fi

work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT
project_dir="$work_dir/generated-project"

printf 'Running cinit smoke test...\n'

if output="$("$script_path" --build-tool make --compiler "$compiler_name" --target "$work_dir/conflicting-options" --no-git 2>&1)"; then
  printf 'Smoke test failed: --build-tool and --compiler should not be accepted together.\n' >&2
  exit 1
else
  status=$?
fi
if [[ "$status" -ne 2 ]] || ! grep -Fq 'Error: choose either --build-tool or --compiler, not both.' <<< "$output"; then
  printf 'Smoke test failed: conflicting selection options did not produce the expected error.\n' >&2
  exit 1
fi

if command -v make >/dev/null 2>&1; then
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
    ./"$(basename -- "$project_dir")" > "$work_dir/make-output.txt"
  )

  if ! grep -q 'Hello, world!' "$work_dir/make-output.txt"; then
    printf 'Smoke test failed: generated Make executable did not print the expected greeting.\n' >&2
    exit 1
  fi
else
  printf 'Skipping Make-specific smoke checks: make is not installed.\n'
fi

choice_bin="$work_dir/choice-tools"
mkdir -p -- "$choice_bin"
for utility in bash basename cp dirname mkdir sed tr; do
  utility_path="$(command -v "$utility")"
  ln -s -- "$utility_path" "$choice_bin/$utility"
done
ln -s -- "$(command -v env)" "$choice_bin/env"
ln -s -- "$compiler_path" "$choice_bin/cc"
build_choice_count=0
if command -v make >/dev/null 2>&1; then
  ln -s -- "$(command -v make)" "$choice_bin/make"
  build_choice_count=1
fi

manual_project="$work_dir/compiler-only-project"
compiler_choice=$((build_choice_count + 1))
printf '%s\n' "$compiler_choice" | PATH="$choice_bin" "$script_path" --target "$manual_project" --no-git > "$work_dir/selection-output.txt"

if [[ ! -f "$manual_project/README.md" || -e "$manual_project/Makefile" ]]; then
  printf 'Smoke test failed: compiler-only project files were not generated as expected.\n' >&2
  exit 1
fi
if [[ "$build_choice_count" == 1 ]] &&
  (! grep -q 'Build tool: Make' "$work_dir/selection-output.txt" ||
   ! grep -q 'Compiler: C compiler' "$work_dir/selection-output.txt"); then
  printf 'Smoke test failed: build tools and compilers were not presented as peer choices.\n' >&2
  exit 1
fi
if ! grep -Fq 'cc -std=c11' "$manual_project/README.md"; then
  printf 'Smoke test failed: compiler-only README does not contain direct compiler commands.\n' >&2
  exit 1
fi

(
  cd -- "$manual_project"
  "$compiler_path" -std=c11 -Wall -Wextra -Iinclude src/main.c src/hello.c -o compiler-only-project
  ./compiler-only-project > "$work_dir/compiler-only-output.txt"
  "$compiler_path" -std=c11 -Wall -Wextra -Iinclude tests/test_hello.c src/hello.c -o test-compiler-only-project
  ./test-compiler-only-project
)

if ! grep -q 'Hello, world!' "$work_dir/compiler-only-output.txt"; then
  printf 'Smoke test failed: compiler-only executable did not print the expected greeting.\n' >&2
  exit 1
fi

compiler_cli_project="$work_dir/compiler-cli-project"
"$script_path" --compiler "$compiler_name" --target "$compiler_cli_project" --no-git > /dev/null
if [[ ! -f "$compiler_cli_project/README.md" || -e "$compiler_cli_project/Makefile" ]] ||
  ! grep -Fq "$compiler_name -std=c11" "$compiler_cli_project/README.md"; then
  printf 'Smoke test failed: --compiler did not select the direct-compile template.\n' >&2
  exit 1
fi

printf 'Smoke test passed.\n'
