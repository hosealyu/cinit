# Building with Meson

Run these commands from the project directory:

```sh
meson setup build
meson compile -C build
./build/@EXECUTABLE_NAME@
meson test -C build
```

The first command configures the project in the `build` directory, and the second compiles it. The last command runs the starter test, which uses the standard C `assert` macro. To start over, remove the generated `build` directory.
