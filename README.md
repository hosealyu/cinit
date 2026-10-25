# Cinit

Cinit is an interactive Bash tool that creates a minimal Hello World C project using an installed build system.

## Usage

```sh
./cinit
```

You can supply either or both choices as command-line options:

```sh
./cinit --build-tool cmake --target ./my-project
./cinit --build-tool make --target .
```

`--build-tool` accepts an installed build-system ID: `make`, `cmake`, `bazel`, or `meson`. `--target` accepts a directory path; relative paths are resolved from the current directory, missing target directories (including missing parent directories) are created automatically, and `.` selects the current directory. If either option is omitted, the script prompts for that choice. Use `--help` to see the options.

When prompted for a target, enter a directory path: relative paths (including `../somewhere`) are resolved from the current directory, and absolute paths are used directly. Enter `.` to select the current directory.

The script checks for the supported tools and offers the installed options:

- Make (`make`)
- CMake (`cmake`)
- Bazel (`bazel` or `bazelisk`)
- Meson (`meson`)

It then asks for a project directory name. Enter `.` to create the files in the current directory. Otherwise, the directory is created under the current directory. The destination must not contain files; the script refuses to overwrite existing content. If no supported build system is installed, the script exits with installation guidance.

Generated projects include `main.c`, a `README.md` with instructions for the selected build system, and only that system's configuration files:

| Build system | Generated files | Example build/run |
| --- | --- | --- |
| Make | `Makefile`, `README.md` | `make && ./<executable-name>` |
| CMake | `CMakeLists.txt`, `README.md` | `cmake -S . -B build && cmake --build build && ./build/<executable-name>` |
| Bazel | `MODULE.bazel`, `BUILD.bazel`, `README.md` | `bazel run //:<executable-name>` |
| Meson | `meson.build`, `README.md` | `meson setup build && meson compile -C build && ./build/<executable-name>` |

The C compiler is expected to be available separately.
The executable name is derived from the destination directory name, normalized to lowercase letters, digits, and hyphens. For `--target .`, the default executable name is `hello-world`.

## Adding a build system

Build-system options are listed in `build-systems.conf` as tab-separated fields:

```text
id<TAB>display name<TAB>command candidates separated by |
```

Add one registry row with a unique ID, a user-facing label, and one or more executable names to detect. Then add a directory at `templates/<id>/` containing the build configuration files and a `README.md` with build/run instructions to copy into the generated project. The common `templates/common/main.c` is copied for every option. Keep template names as the filenames you want users to receive.
