WITH hon AS (SELECT unnest AS c
               FROM unnest(ARRAY['Mr', 'Ms', 'Dr', 'Hon'])),
     suf AS (SELECT unnest AS c
               FROM unnest(ARRAY['', 'Jr', 'III', 'Sr'])),
     abc AS (SELECT unnest AS c
               FROM unnest(ARRAY['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
                                 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                                 'U', 'V', 'W', 'X', 'Y', 'Z'])),
     dig AS (SELECT unnest AS c
               FROM unnest(ARRAY['1', '2', '3', '4', '5', '6', '7', '8', '9', '0' ]))
 SELECT hon AS honorific, first.c AS first, middle.c AS middle, last.c AS last, suffix.c AS suffix,
        first.c || middle.c || last.c || ' Inc' AS company, NULL AS title,
        '757-555-' || cast(floor(random() * 1000) AS INTEGER) % 1000 AS office,
        '757-555-' || cast(floor(random() * 1000) AS INTEGER) % 1000 AS mobile,
        '757-555-' || cast(floor(random() * 1000) AS INTEGER) % 1000 AS other,
        first.c || middle.c || last.c || '@' ||
          first.c || middle.c || last.c || '.example.com' AS email,
        first.c || middle.c || last.c || '.example.com' AS web,
        cast(floor(random() * 10000) AS INTEGER) || ' Main St' AS address1,
        NULL AS address2,
        NULL AS address3,
        'Midway' AS city,
        'VA'     AS state,
        '23456'  AS postal_code,
        NULL     AS country,
        'Notes: ' || first.c || middle.c || last.c || suffix.c AS notes
   FROM hon, abc AS first, abc AS middle, abc as last, suf as suffix;
