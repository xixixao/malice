
#include <stdio.h>
#include <stdlib.h>

char* read() {
  char* s = malloc(sizeof(char) * 200);
  if (s == NULL) {
    printf ("Program has run out of memory\n");
    exit(1);
  }

  fgets (s, 200, stdin);
  return s;
}