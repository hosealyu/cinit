project('hello-world', 'c', default_options : ['c_std=c11', 'warning_level=3'])

hello = static_library(
  'hello',
  'src/hello.c',
  include_directories : include_directories('include'),
)

executable(
  '@EXECUTABLE_NAME@',
  'src/main.c',
  link_with : hello,
  include_directories : include_directories('include'),
)

hello_test = executable(
  'test-@EXECUTABLE_NAME@',
  'tests/test_hello.c',
  link_with : hello,
  include_directories : include_directories('include'),
)
test('hello-test', hello_test)
