--- count -- 
SELECT
    COUNT(*) AS total_records
FROM
    peoples;

-- count multiple fields -- 
SELECT
    COUNT(first_name) AS first_name,
    COUNT(last_name) AS last_name
FROM
    people;

-- count unique values --- 
SELECT
    COUNT(DISTINCT first_name) AS first_names
FROM
    peoples;

-- two space field -- 
SELECT
    "release year"
FROM
    years