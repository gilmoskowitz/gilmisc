CREATE TABLE onecol (dumb INTEGER PRIMARY KEY);
INSERT INTO onecol (dumb)
  SELECT generate_series
    FROM generate_series(0, 1000000);

SELECT 'time on conflict';
INSERT INTO onecol (dumb)
  SELECT generate_series
    FROM generate_series(0, 100000, 10)
  ON CONFLICT (dumb) DO NOTHING;

SELECT 'time with not in';
INSERT INTO onecol (dumb)
  SELECT generate_series
    FROM generate_series(0, 100000, 10)
  WHERE generate_series NOT IN (SELECT dumb FROM onecol);

DROP TABLE onecol;
