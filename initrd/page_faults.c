#include <stdio.h>
#include <stdlib.h>

#define KB(x) (x << 10)
#define MB(x) (x << 20)

#define MAX_REPEAT 1
#define MEM_SIZE MB(1024)
#define PAGE_SIZE_BITS 12
#define PAGE_SIZE (1 << PAGE_SIZE_BITS) /* 4K page */

int *mem;

int main()
{
  int iter = 0;
  int max_index = MEM_SIZE / sizeof(int);
  int page_stride = PAGE_SIZE / sizeof(int);
  mem = (int *)malloc(MEM_SIZE);

  for (int repeat = 0; repeat < MAX_REPEAT; repeat++) {
    for (int i = 0; i < max_index; i += page_stride) {
      mem[i] = i;
      iter++;
    }
  }

  printf("Expected page faults: %d\n", iter);
  return 0;
}
