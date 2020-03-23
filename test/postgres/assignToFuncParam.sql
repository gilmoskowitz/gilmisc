BEGIN;
  CREATE FUNCTION testme(pInt INTEGER) RETURNS INTEGER AS $$
  BEGIN
    IF pInt % 2 = 0 THEN
      pInt = 0;
    END IF;
    RETURN pInt;
  END;
  $$ LANGUAGE plpgsql;

  SELECT testme(generate_series), generate_series
    FROM generate_series(1, 10);
ROLLBACK;
