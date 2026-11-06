# Cinit

Cinit is an interactive Bash tool that creates a minimal Hello World C project using either an installed build system or a C compiler directly.

## Usage

```sh
./cinit
```

You can select a build system or compiler and set the target using command-line options. Git is initialized by default when installed; use `--no-git` to skip it:

```sh
./cinit --build-tool cmake --target ./my-project
./cinit --build-tool make --target .
./cinit --compiler gcc --target ./my-project
./cinit --compiler clang --target . --no-git
```

`--build-tool` accepts an installed build-system ID: `make`, `cmake`, `bazel`, or `meson`. `--compiler` accepts an installed compiler ID from `compilers.conf`, such as `cc`, `gcc`, or `clang`; compiler mode generates direct compile/run instructions without a build-system file. These two options are mutually exclusive. If neither is supplied, Cinit lists all detected build systems and compilers together and prompts you to choose one. `--target` accepts a directory path; relative paths are resolved from the current directory, missing target directories (including missing parent directories) are created automatically, and `.` selects the current directory. Use `--help` to see the options.

When prompted for a target, enter a directory path: relative paths (including `../somewhere`) are resolved from the current directory, and absolute paths are used directly. Enter `.` to select the current directory.

The script checks for supported build systems and compilers and offers the detected options:

- Make (`make`)
- CMake (`cmake`)
- Bazel (`bazel` or `bazelisk`)
- Meson (`meson`)

Compiler choices are presented alongside build-system choices even when build systems are installed. If no supported build system is installed, available compilers remain selectable. Cinit asks for a project directory path unless `--target` is provided. Enter `.` to create the files in the current directory. The destination must not contain files; the script refuses to overwrite existing content. If no supported build system or C compiler is installed, the script exits with installation guidance.

Generated projects include `src/main.c`, a small `src/hello.c` component with its public header in `include/hello.h`, a `tests/test_hello.c` starter test using standard C `assert`, `.gitignore`, and a `README.md` with instructions for the selected build system:

| Selection | Generated files | Example build/run |
| --- | --- | --- |
| Make | `Makefile`, `README.md` | `make && ./<executable-name>`; tests: `make test` |
| CMake | `CMakeLists.txt`, `README.md` | `cmake -S . -B build && cmake --build build && ./build/<executable-name>`; tests: `ctest --test-dir build --output-on-failure` |
| Bazel | `MODULE.bazel`, `BUILD.bazel`, `README.md` | `bazel run //:<executable-name>`; tests: `bazel test //:hello_test` |
| Meson | `meson.build`, `README.md` | `meson setup build && meson compile -C build && ./build/<executable-name>`; tests: `meson test -C build` |
| Compiler (`cc`, `gcc`, or `clang`) | `README.md` | Compile `src/main.c` and `src/hello.c` directly with the selected compiler; the README also includes commands to compile and run the starter test |

When using a build system, the C compiler is expected to be available separately. In compiler mode, Cinit writes direct compile/run instructions for the selected compiler into the generated README. If Git is not installed, Cinit prints an error message and continues without initializing a repository. Use `--no-git` to skip Git initialization without a message.
The executable name is derived from the destination directory name, normalized to lowercase letters, digits, and hyphens. For `--target .`, the default executable name is `hello-world`.
Each generated project includes a `.gitignore` for its executable, common build output, and object files.

## Smoke test

Run the repository smoke test to verify the generator creates a compiler-based project from the combined interactive choice menu and a Make project when Make is installed, and that they build and pass their starter tests:

```sh
bash tests/smoke.sh
```

The test creates a temporary compiler project from a combined menu in an isolated `PATH` containing only Make (when available) and a C compiler. It verifies both kinds are shown as peer choices, runs the compiler-based starter test, and also builds and tests a Make project when Make is installed.

## Adding a build system

Build-system options are listed in `build-systems.conf` as tab-separated fields:

```text
id<TAB>display name<TAB>command candidates separated by |
```

Add one registry row with a unique ID, a user-facing label, and one or more executable names to detect. Then add a directory at `templates/<id>/` containing build and test configuration plus a `README.md` with build/run/test instructions to copy into the generated project. The common files and folders in `templates/common/` are copied for every option. Keep template names as the filenames you want users to receive.

## Adding a compiler

Compiler choices are listed in `compilers.conf`, using the same tab-separated format as `build-systems.conf`. Add a unique compiler ID, a user-facing label, and one or more executable candidates. Compiler choices use `templates/manual/README.md` to generate direct compile/run instructions.
