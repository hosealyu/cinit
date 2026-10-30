# Building with Bazel

Run these commands from the project directory to build and test the program:

```sh
bazel run //:@EXECUTABLE_NAME@
bazel test //:hello_test
```

The test uses the standard C `assert` macro.

To build without running it, use `bazel build //:@EXECUTABLE_NAME@`. If Bazelisk is installed as `bazelisk` rather than `bazel`, run the same commands with `bazelisk` in place of `bazel`.
