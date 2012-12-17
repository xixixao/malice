#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

void *read() {
  char *s = alloc_c(200);
  fgets(s, 200, stdin);
  return s;
}

void *alloc(int type_size, size_t size) {
  void *a = malloc(type_size * size);
  if (a == NULL) {
    printf("Program has run out of memory\n");
    exit(1);
  }
  return a;
}

void *alloc_c(size_t size) {
  return alloc(1, size);
}

void *alloc_i(size_t size) {
  return alloc(8, size);
}
