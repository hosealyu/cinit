# Building with Meson

Run these commands from the project directory:

```sh
meson setup build
meson compile -C build
./build/@EXECUTABLE_NAME@
```

The first command configures the project in the `build` directory, and the second compiles it. To start over, remove the generated `build` directory.
