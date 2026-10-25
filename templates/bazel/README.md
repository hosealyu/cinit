# Building with Bazel

Run this command from the project directory to build and run the program:

```sh
bazel run //:@EXECUTABLE_NAME@
```

To build without running it, use `bazel build //:@EXECUTABLE_NAME@`. If Bazelisk is installed as `bazelisk` rather than `bazel`, run the same commands with `bazelisk` in place of `bazel`.
