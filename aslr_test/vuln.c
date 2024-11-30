#include <stdio.h>

int foo() {
    return 0;
}

int main() {
    setvbuf(stdout, NULL, _IONBF, 0);
    printf("Address of foo: %p\n", foo);
}