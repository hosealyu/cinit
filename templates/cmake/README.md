# Building with CMake

Run these commands from the project directory:

```sh
cmake -S . -B build
cmake --build build
./build/@EXECUTABLE_NAME@
ctest --test-dir build --output-on-failure
```

The first command configures the project in the `build` directory, and the second compiles it. The last command runs the starter test, which uses the standard C `assert` macro. To start over, remove the generated `build` directory.
