/* longest line(s) in a file */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAXLEN 2048
#define MAXCNT   10

int main(int argc, char *argv[])
{
  struct {
    int   num;
    char *str;
  } longest[MAXCNT] = {
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 },
    { -1, 0 }
  } ;

  char str[MAXLEN];

  int line;
  int i;
  int j;
  for (line = 0; fgets(str, MAXLEN, stdin); line++)
  {
    for (i = 0; i < MAXCNT; i++)
    {
      if (longest[i].num < 0)
      {
        longest[i].str = strncpy(malloc(MAXLEN), str, MAXLEN);
        longest[i].num = line;
        break;
      }
      else if (strlen(str) > strlen(longest[i].str))
      {
        if (longest[MAXCNT - 1].str)
          free(longest[MAXCNT - 1].str);
        for (j = MAXCNT - 1; j > i; j--)
        {
          longest[j].str = longest[j - 1].str;
          longest[j].num = longest[j - 1].num;
        }
        longest[i].str = strncpy(malloc(MAXLEN), str, MAXLEN);
        longest[i].num = line;
        break;
      }
    }
  }

  for (i = 0; i < MAXCNT && longest[i].num > -1; i++)
    printf("line %0.8d = %0.8d: %s", longest[i].num, strlen(longest[i].str), longest[i].str);

  exit(0);
}
