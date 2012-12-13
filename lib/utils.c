#include <stdio.h>
#include <stdlib.h>

char *read() {
  char *s = (char *)alloc_c(200);
  fgets(s, 200, stdin);
  return s;
}

void *alloc(int type_size, int size) {
  void *a = malloc(type_size * size);
  if (a == NULL) {
    printf("Program has run out of memory\n");
    exit(1);
  }
  return a;
}

void *alloc_c(int size) {
  return alloc(sizeof(char), size);
}

void *alloc_i(int size) {
  return alloc(sizeof(int), size);
}
