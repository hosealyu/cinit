# Building with a C compiler

This project was generated without a build system. Run these commands from the project directory:

```sh
@COMPILER_NAME@ -std=c11 -Wall -Wextra -Iinclude src/main.c src/hello.c -o @EXECUTABLE_NAME@
./@EXECUTABLE_NAME@
@COMPILER_NAME@ -std=c11 -Wall -Wextra -Iinclude tests/test_hello.c src/hello.c -o test-@EXECUTABLE_NAME@
./test-@EXECUTABLE_NAME@
```

The final two commands compile and run the starter test using the standard C `assert` macro.
