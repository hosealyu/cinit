cmake_minimum_required(VERSION 3.16)
project(hello_world C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_library(hello src/hello.c)
target_include_directories(hello PUBLIC include)

add_executable(@EXECUTABLE_NAME@ src/main.c)
target_link_libraries(@EXECUTABLE_NAME@ PRIVATE hello)

include(CTest)
if(BUILD_TESTING)
    add_executable(test-@EXECUTABLE_NAME@ tests/test_hello.c)
    target_link_libraries(test-@EXECUTABLE_NAME@ PRIVATE hello)
    add_test(NAME hello-test COMMAND test-@EXECUTABLE_NAME@)
endif()
