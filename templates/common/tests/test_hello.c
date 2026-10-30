#ifdef NDEBUG
#undef NDEBUG
#endif

#include <assert.h>
#include <string.h>

#include "hello.h"

int main(void)
{
    assert(strcmp(hello_message(), "Hello, world!") == 0);
    return 0;
}
