CC ?= cc
CFLAGS ?= -Wall -Wextra -std=c11
EXECUTABLE := @EXECUTABLE_NAME@
TEST_EXECUTABLE := test-@EXECUTABLE_NAME@
INCLUDES := -Iinclude
APP_SOURCES := src/main.c src/hello.c
TEST_SOURCES := tests/test_hello.c src/hello.c

.PHONY: all clean test

all: $(EXECUTABLE)

$(EXECUTABLE): $(APP_SOURCES) include/hello.h
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(APP_SOURCES)

$(TEST_EXECUTABLE): $(TEST_SOURCES) include/hello.h
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $(TEST_SOURCES)

test: $(TEST_EXECUTABLE)
	./$(TEST_EXECUTABLE)

clean:
	rm -f $(EXECUTABLE) $(TEST_EXECUTABLE)
