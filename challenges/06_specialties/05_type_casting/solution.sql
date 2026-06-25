SELECT
    id,
    date_str::DATE AS sale_date,
    REPLACE(REPLACE(price_str, '$', ''), ',', '')::NUMERIC(10,2) AS price,
    CASE
        WHEN phone_str ~ '^\d{10}$' THEN
            '(' || SUBSTRING(phone_str, 1, 3) || ') ' || SUBSTRING(phone_str, 4, 3) || '-' || SUBSTRING(phone_str, 7, 4)
        WHEN phone_str ~ '^\d{3}-\d{3}-\d{4}$' THEN
            '(' || SUBSTRING(phone_str, 1, 3) || ') ' || SUBSTRING(phone_str, 5, 3) || '-' || SUBSTRING(phone_str, 9, 4)
        WHEN phone_str ~ '^\(\d{3}\)\s?\d{3}-\d{4}$' THEN
            '(' || SUBSTRING(phone_str, 2, 3) || ') ' || SUBSTRING(phone_str, 7, 3) || '-' || SUBSTRING(phone_str, 11, 4)
        ELSE NULL
    END AS phone_formatted
FROM raw_data
WHERE date_str ~ '^\d{4}-\d{2}-\d{2}$'
  AND price_str ~ '^\$?[\d,]+\.?\d*$'
ORDER BY id;
