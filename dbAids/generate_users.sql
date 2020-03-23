BEGIN;
WITH abc AS (SELECT unnest AS c
               FROM unnest(ARRAY['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
                                 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                                 'U', 'V', 'W', 'X', 'Y', 'Z']))
SELECT createuser(first.c || middle.c || last.c, FALSE)
  FROM abc AS first, abc AS middle, abc as last;
  commit;
