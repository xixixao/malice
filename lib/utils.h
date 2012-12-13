#ifndef UTILS_H
#define UTILS_H

// dynamically allocate space to read a string from standard in
char *read();

// dynamically allocate an array of given size
void *alloc_c(int size);
void  *alloc_i(int size);

#endif
