/*
View "api.account"
account_number                   | character varying | 
parent_account                   | text              | 
account_name                     | text              | 
active                           | boolean           | 
type                             | text              | 
primary_contact_number           | text              | 
primary_contact_honorific        | text              | 
primary_contact_first            | text              | 
primary_contact_middle           | text              | 
primary_contact_last             | text              | 
primary_contact_suffix           | text              | 
primary_contact_job_title        | text              | 
primary_contact_voice            | text              | 
primary_contact_fax              | text              | 
primary_contact_email            | text              | 
primary_contact_change           | text              | 
primary_contact_address_number   | text              | 
primary_contact_address1         | text              | 
primary_contact_address2         | text              | 
primary_contact_address3         | text              | 
primary_contact_city             | text              | 
primary_contact_state            | text              | 
primary_contact_postalcode       | text              | 
primary_contact_country          | text              | 
primary_contact_address_change   | text              | 
secondary_contact_number         | text              | 
secondary_contact_honorific      | text              | 
secondary_contact_first          | text              | 
secondary_contact_middle         | text              | 
secondary_contact_last           | text              | 
secondary_contact_suffix         | text              | 
secondary_contact_job_title      | text              | 
secondary_contact_voice          | text              | 
secondary_contact_fax            | text              | 
secondary_contact_email          | text              | 
secondary_contact_web            | text              | 
secondary_contact_change         | text              | 
secondary_contact_address_number | text              | 
secondary_contact_address1       | text              | 
secondary_contact_address2       | text              | 
secondary_contact_address3       | text              | 
secondary_contact_city           | text              | 
secondary_contact_state          | text              | 
secondary_contact_postalcode     | text              | 
secondary_contact_country        | text              | 
secondary_contact_address_change | text              | 
notes                            | text              | 
*/

WITH abc AS (SELECT unnest AS c
               FROM unnest(ARRAY['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
                                 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                                 'U', 'V', 'W', 'X', 'Y', 'Z'])),
     sym AS (SELECT unnest AS c
               FROM unnest(ARRAY['1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
                                 '!', '@', '#', '%', '-', '_', '=', '{', '}', ',',
                                 '/', '~', 'é', 'º', '¢', '©']))
INSERT INTO api.account (account_number, account_name,
                         active,
                         type,
                         primary_contact_first, primary_contact_middle,
                         primary_contact_last,  primary_contact_suffix)
 SELECT first.c || middle.c || suffix.c || last.c, first.c || middle.c || suffix.c || last.c,
        cast(floor(random() * 1000) AS INTEGER) % 1000 != 0,
        case when cast(floor(random() * 1000) AS INTEGER) % 300 != 0 then 'Organization' ELSE 'Individual' END,
        first.c, middle.c, last.c, suffix.c
   FROM abc AS first, abc AS middle, abc as last, sym as suffix;

INSERT INTO api.customer (customer_number,        customer_name,   active,
                          billing_contact_number, billing_contact_change)
                   SELECT account_number,         account_name,    active,
                          primary_contact_number, 'CHANGEALL'
                     FROM api.account
                    WHERE account_number ~ '^..[^A-Z][A-Z]$';
