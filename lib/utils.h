#ifndef UTILS_H
#define UTILS_H

// dynamically allocate space to read a string from standard in
void *read();

// dynamically allocate an array of given size
void *alloc_c(size_t size);
void *alloc_i(size_t size);

#endif
