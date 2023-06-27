#####################
---Common Data Types--- 
#####################
-- CHAR, VARCHAR, TEXT 
-- INFORMATION_SCHEMA.COLUMNS 
-- Select all columns from the TABLES system database
SELECT
    *
FROM
    INFORMATION_SCHEMA.TABLES -- Filter by schema
WHERE
    table_schema = 'public';

-- Select all columns from the COLUMNS system database
SELECT
    *
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    table_name = 'actor';

-- Get the column name and data type
SELECT
    column_name,
    data_type -- From the system database information schema
FROM
    INFORMATION_SCHEMA.COLUMNS -- For the customer table
WHERE
    table_name = 'customer';

#####################
---Date and time data types--- 
#####################
SELECT
    -- Select the rental and return dates
    rental_date,
    return_date,
    -- Calculate the expected_return_date
    rental_date + INTERVAL '3 days' AS expected_return_date
FROM
    rental;

#####################
---Working with Arrays--- 
#####################
-- CREATING ARRAY : 
CREATE TABLE my_fist_table(
    first_column text,
    second_column integer
);

INSERT INTO
    my_fist_table(first_column, second_column)
VALUES
    ('text value', 12);

CREATE TABLE grades(
    student_id int,
    email text [] [],
    -- Array text
    test_score int [] -- Array int
);

INSERT INTO
    grades
VALUES
    (
        1,
        '{{"work", "work1@datacamp.com"}, {"other", "other1@datacamp.com"}}',
        '{92,85,96,88}'
    );

SELECT
    email [1] [1] AS type,
    -- indexes start with one not zero  
    email [1] [2] AS address,
    test_score [1],
FROM
    grades;

-- Select the title and special features column ( special feature column type is ARRAY)
SELECT
    title,
    special_features
FROM
    film -- Use the array index of the special_features column
WHERE
    special_features [1] = 'Trailers';

-- Select the title and special features column 
SELECT
    title,
    special_features
FROM
    film -- Use the array index of the special_features column
WHERE
    special_features [1] = 'Deleted Scenes';

-- Select the title and special features column 
SELECT
    title,
    special_features
FROM
    film -- Use the array index of the special_features column
WHERE
    special_features [2] = 'Deleted Scenes';

SELECT
    title,
    special_features
FROM
    film -- Modify the query to use the ANY function 
WHERE
    'Trailers' = ANY (special_features);

-- When using the ANY function, the value you are filtering on appears on the left side of the equation with the name of the ARRAY column as the parameter in the ANY function. in any given index 
-- The contains operator @> operator is alternative syntax to the ANY function and matches data in an ARRAY using the following syntax. in any given index 
SELECT
    title,
    special_features
FROM
    film -- Filter where special_features contains 'Deleted Scenes'
WHERE
    special_features @ > ARRAY ['Deleted Scenes'];

#####################
---Overview of Basic arithmetic operators--- 
#####################
-- AGE() -- will return interval timestamp to timestamp 

SELECT
    f.title,
    f.rental_duration,
    -- Calculate the number of days rented
    r.return_date - r.rental_date AS days_rented
FROM
    film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY
    f.title;

SELECT
    f.title,
    f.rental_duration,
    -- Calculate the number of days rented
    AGE(return_date, rental_date) AS days_rented
FROM
    film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY
    f.title;

SELECT
    f.title,
    -- Convert the rental_duration to an interval
    INTERVAL '1' day * f.rental_duration,
    -- to change rental duration(int) to interval
    -- Calculate the days rented as we did previously
    r.return_date - r.rental_date AS days_rented
FROM
    film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id -- Filter the query to exclude outstanding rentals
WHERE
    r.return_date IS NOT NULL
ORDER BY
    f.title;

SELECT
    f.title,
    r.rental_date,
    f.rental_duration,
    -- Add the rental duration to the rental date
    INTERVAL '1' day * f.rental_duration + rental_date AS expected_return_date,
    r.return_date
FROM
    film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
ORDER BY
    f.title;

#####################
---Functions for retrieving current date/time--- 
#####################
-- CURRENT_DATE(), CURRENT_TIMESTAMP(), NOW()
-- NOW() --- NOW DATE WITH MICRO SECONDS PRECISION 
SELECT
    NOW();

-- Select the current date
SELECT
    CURRENT_DATE;

--Select the current timestamp without a timezone
SELECT
    CAST(NOW() AS TIMESTAMP);

SELECT
    -- Select the current date
    CURRENT_DATE,
    -- CAST the result of the NOW() function to a date
    CAST(NOW() AS date);

--Select the current timestamp without timezone
SELECT
    CURRENT_TIMESTAMP :: timestamp AS right_now;

SELECT
    CURRENT_TIMESTAMP :: timestamp AS right_now,
    INTERVAL '5 DAYS' + CURRENT_TIMESTAMP AS five_days_from_now;

SELECT
    CURRENT_TIMESTAMP(2) :: timestamp AS right_now,
    interval '5 days' + CURRENT_TIMESTAMP(2) AS five_days_from_now;

#####################
---Extracting and transforming date/time data--- 
#####################
-- DATE_PART(), DATE_TRUNC() , EXTRACT() 
