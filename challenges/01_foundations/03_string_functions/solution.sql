SELECT
    UPPER(username) AS upper_username,
    LOWER(email) AS lower_email,
    LENGTH(bio) AS bio_length
FROM users;
