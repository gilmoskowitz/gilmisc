#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
  int a, pos, tens;
  const char *ruler = " 123456789";

  for (a = 1; a < argc; a++)
  {
    printf("%s\n", argv[a]);
    for (pos = 0; pos < strlen(argv[a]); pos += strlen(ruler))
      printf("%s", ruler);
    printf("\n");
    for (pos = 0, tens = 0; pos < strlen(argv[a]); pos += strlen(ruler), tens++)
      printf("%-10d", tens);
    printf("\n");
  }
}
