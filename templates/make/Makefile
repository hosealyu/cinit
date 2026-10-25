CC ?= cc
CFLAGS ?= -Wall -Wextra -std=c11
EXECUTABLE := @EXECUTABLE_NAME@

.PHONY: all clean

all: $(EXECUTABLE)

$(EXECUTABLE): main.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(EXECUTABLE)
