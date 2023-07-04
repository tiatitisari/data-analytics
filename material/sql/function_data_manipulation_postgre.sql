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
-- EXTRACT(field FROM source), DATE_PART('field',source)
-- DATE_TRUNC(month, year, day) -- timestamp
SELECT
    -- Extract day of week from rental_date
    EXTRACT(
        dow
        FROM
            rental_date
    ) AS dayofweek
FROM
    rental
LIMIT
    100;

-- Extract day of week from rental_date
SELECT
    EXTRACT(
        dow
        FROM
            rental_date
    ) AS dayofweek,
    -- Count the number of rentals
    COUNT(*) as rentals
FROM
    rental
GROUP BY
    1;

-- Truncate rental_date by year
SELECT
    DATE_TRUNC('year', rental_date) AS rental_year
FROM
    rental;

-- Truncate rental_date by month
SELECT
    DATE_TRUNC('month', rental_date) AS rental_month
FROM
    rental;

SELECT
    DATE_TRUNC('day', rental_date) AS rental_day,
    -- Count total number of rentals 
    COUNT(*) AS rentals
FROM
    rental
GROUP BY
    1;

SELECT
    -- Extract the day of week date part from the rental_date
    EXTRACT(
        dow
        FROM
            rental_date
    ) AS dayofweek,
    AGE(return_date, rental_date) AS rental_days
FROM
    rental AS r
WHERE
    -- Use an INTERVAL for the upper bound of the rental_date 
    rental_date BETWEEN CAST('2005-05-01' AS DATE)
    AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    f.title,
    r.rental_date,
    -- Extract the day of week date part from the rental_date
    EXTRACT(
        dow
        FROM
            r.rental_date
    ) AS dayofweek,
    AGE(r.return_date, r.rental_date) AS rental_days,
    -- Use DATE_TRUNC to get days from the AGE function
    CASE
        WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > -- Calculate number of d
        f.rental_duration * INTERVAL '1' day THEN TRUE
        ELSE FALSE
    END AS past_due
FROM
    film AS f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
    INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
    INNER JOIN customer AS c ON c.customer_id = r.customer_id
WHERE
    -- Use an INTERVAL for the upper bound of the rental_date 
    r.rental_date BETWEEN CAST('2005-05-01' AS DATE)
    AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

#####################
-- Reformatting string and character data 
#####################
-- reformatting string adn character data 
-- parsing string and character data 
-- determine string length and character position 
-- truncating and padding string data 
-- Concatenate the first_name and last_name and email 
SELECT
    first_name || ' ' || last_name || ' <' || email || '>' AS full_email
FROM
    customer;

-- Concatenate the first_name and last_name and email
SELECT
    CONCAT(first_name, ' ', last_name, ' <', email, '>') AS full_email
FROM
    customer;

SELECT
    -- Concatenate the category name to coverted to uppercase
    -- to the film title converted to title case
    UPPER(name) || ': ' || INITCAP(title) AS film_category,
    -- Convert the description column to lowercase
    LOWER(description) AS description
FROM
    film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id;

SELECT
    -- Replace whitespace in the film title with an underscore
    REPLACE(title, ' ', '_') AS title
FROM
    film;

SELECT
    -- Select the title and description columns
    title,
    description,
    -- Determine the length of the description column
    CHAR_LENGTH(description) AS desc_len,
    LENGTH(description)
FROM
    film;

SELECT
    -- Select the first 50 characters of description
    LEFT(description, 50) AS short_desc
FROM
    film AS f;

SELECT
    -- Select only the street name from the address table
    SUBSTRING(
        address
        FROM
            POSITION(' ' IN address) + 1 FOR CHAR_LENGTH(address)
    )
FROM
    address;

SELECT
    -- Extract the characters to the left of the '@'
    SUBSTRING(
        email
        FROM
            0 FOR POSITION ('@' IN email)
    ) AS username,
    -- Extract the characters to the right of the '@'
    SUBSTRING(
        email
        FROM
            POSITION('@' IN email) + 1 FOR CHAR_LENGTH(email)
    ) AS domain
FROM
    customer;

-- Concatenate the first_name and last_name 
SELECT
    first_name || LPAD(last_name, LENGTH(last_name) + 1) AS full_name
FROM
    customer;

-- Concatenate the first_name and last_name 
SELECT
    RPAD(first_name, LENGTH(first_name) + 1) || RPAD(last_name, LENGTH(last_name) + 2, ' <') || RPAD(email, LENGTH(email) + 1, '>') AS full_email
FROM
    customer;

-- Concatenate the uppercase category name and film title
SELECT
    CONCAT(UPPER(name), ': ', title) AS film_category,
    -- Truncate the description remove trailing whitespace
    TRIM(LEFT(description, 50)) AS film_desc
FROM
    film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id;

SELECT
    UPPER(c.name) || ': ' || f.title AS film_category,
    -- -- Truncate the description without cutting off a word
    LEFT(
        description,
        50 - --   -- Subtract the position of the first whitespace character
        POSITION(
            ' ' IN REVERSE(LEFT(description, 50))
        )
    )
FROM
    film AS f
    INNER JOIN film_category AS fc ON f.film_id = fc.film_id
    INNER JOIN category AS c ON fc.category_id = c.category_id;

-- STRPOS
#####################
-- Introduction to full-text search 
#####################
-- Full Text search : provides a means for performing natural language queries of text data in your database: 
-- stemming, spelling mistake, ranking 
-- Extending PostgreSQL
-- Improving full text search with extensions 
-- Select all columns
SELECT
    *
FROM
    film -- Select only records that begin with the word 'GOLD'
WHERE
    title LIKE 'GOLD%';

SELECT
    *
FROM
    film -- Select only records that end with the word 'GOLD'
WHERE
    title LIKE '%GOLD';

SELECT
    *
FROM
    film -- Select only records that contain the word 'GOLD'
WHERE
    title LIKE '%GOLD%';

-- Select the film description as a tsvector
SELECT
    to_tsvector(description)
FROM
    film;

-- Select the title and description
SELECT
    title,
    description
FROM
    film -- Convert the title to a tsvector and match it against the tsquery 
WHERE
    to_tsvector(title) @ @ to_tsquery('elf');

CREATE TYPE dayofweek AS ENUM('Monday', 'Tuesday');

-- data type E >> Enum 
CREATE FUNCTION squared(i integer) RETURNS integer AS $ $ -- double dollar sign show that the function will be using sql 
BEGIN RETURN i * i:
END;

$ $ LANGUAGE plpgsql;

-- Create an enumerated data type, compass_position
CREATE TYPE compass_position AS ENUM (
    -- Use the four cardinal directions
    'North',
    'South',
    'East',
    'West'
);

-- Confirm the new data type is in the pg_type system table
SELECT
    *
FROM
    pg_type
WHERE
    typname = 'compass_position';

-- Select the column name, data type and udt name columns
SELECT
    column_name,
    data_type,
    udt_name
FROM
    INFORMATION_SCHEMA.COLUMNS -- Filter by the rating column in the film table
WHERE
    table_name = 'film'
    AND column_name = 'rating';

SELECT
    *
FROM
    pg_type
WHERE
    typname = 'mpaa_rating';

-- Select the film title and inventory ids
SELECT
    f.title,
    i.inventory_id
FROM
    film AS f -- Join the film table to the inventory table
    INNER JOIN inventory AS i ON f.film_id = i.film_id;

-- to see USER DEFINED FUNCTION in whole databases 
SELECT
    column_name,
    data_type,
    udt_name
FROM
    INFORMATION_SCHEMA.COLUMNS
WHERE
    table_name = 'film';

--- 1 st function creation 
--#OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
--#THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
--#   1) RENTAL FEES FOR ALL PREVIOUS RENTALS
--#   2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
--#   3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
--#   4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED
DECLARE v_rentfees DECIMAL(5, 2);

--#FEES PAID TO RENT THE VIDEOS INITIALLY
v_overfees INTEGER;

--#LATE FEES FOR PRIOR RENTALS
v_payments DECIMAL(5, 2);

--#SUM OF PAYMENTS MADE PREVIOUSLY
BEGIN
SELECT
    COALESCE(SUM(film.rental_rate), 0) INTO v_rentfees
FROM
    film,
    inventory,
    rental
WHERE
    film.film_id = inventory.film_id
    AND inventory.inventory_id = rental.inventory_id
    AND rental.rental_date <= p_effective_date
    AND rental.customer_id = p_customer_id;

SELECT
    COALESCE(
        SUM(
            IF(
                (rental.return_date - rental.rental_date) > (film.rental_duration * '1 day' :: interval),
                (
                    (rental.return_date - rental.rental_date) - (film.rental_duration * '1 day' :: interval)
                ),
                0
            )
        ),
        0
    ) INTO v_overfees
FROM
    rental,
    inventory,
    film
WHERE
    film.film_id = inventory.film_id
    AND inventory.inventory_id = rental.inventory_id
    AND rental.rental_date <= p_effective_date
    AND rental.customer_id = p_customer_id;

SELECT
    COALESCE(SUM(payment.amount), 0) INTO v_payments
FROM
    payment
WHERE
    payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

RETURN v_rentfees + v_overfees - v_payments;

END;

--- get customer balance 
--- 2nd function 
DECLARE v_customer_id INTEGER;

BEGIN
SELECT
    customer_id INTO v_customer_id
FROM
    rental
WHERE
    return_date IS NULL
    AND inventory_id = p_inventory_id;

RETURN v_customer_id;

END;

--- inventory_held_by_customer
--- 3rd function 
DECLARE v_rentals INTEGER;

v_out INTEGER;

BEGIN -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
-- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED
SELECT
    count(*) INTO v_rentals
FROM
    rental
WHERE
    inventory_id = p_inventory_id;

IF v_rentals = 0 THEN RETURN TRUE;

END IF;

SELECT
    COUNT(rental_id) INTO v_out
FROM
    inventory
    LEFT JOIN rental USING(inventory_id)
WHERE
    inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

IF v_out > 0 THEN RETURN FALSE;

ELSE RETURN TRUE;

END IF;

END;

-- inventory_in_stock
-- Select the film title, rental and inventory ids
SELECT
    f.title,
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) AS held_by_cust
FROM
    film as f -- Join the film table to the inventory table
    INNER JOIN inventory AS i ON f.film_id = i.film_id;

-- Select the film title and inventory ids
SELECT
    f.title,
    i.inventory_id,
    -- Determine whether the inventory is held by a customer
    inventory_held_by_customer(i.inventory_id) as held_by_cust
FROM
    film as f
    INNER JOIN inventory AS i ON f.film_id = i.film_id
WHERE
    -- Only include results where the held_by_cust is not null
    inventory_held_by_customer(i.inventory_id) IS NOT NULL;

--- commonly used extenstions in postgresql 
-- PostGIS
-- PostPic
-- fuzzystrmatch 
-- pg_trgm 
--- to see available extensions 
SELECT
    name
FROM
    pg_available_extensions;

-- to see installed extension 
SELECT
    extname
FROM
    pg_extension;

-- enable the fuzzystrmatch extension 
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
-- confirm that fuzzystrmatch has been enabled 
SELECT extname FROM pg_extension;

-- extension in fuzzystrmatch, and pg_trgm 
-- similarity 
-- levenshtein
-- Select the title and description columns
SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(title, description) -- degree of similarity 2 is perfect match 1 is less likely match 
FROM 
  film; 

  -- Select the title and description columns
SELECT  
  title, 
  description, 
  -- Calculate the levenshtein distance -- the bigger the distance the farther the string distance between each other
  levenshtein(title, 'JET NEIGHBOR') AS distance
FROM 
  film
ORDER BY 3; 

-- Select the title and description columns
SELECT  
  title, 
  description 
FROM 
  film
WHERE 
  -- Match "Astounding Drama" in the description
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama');

  SELECT 
  title, 
  description, 
  -- Calculate the similarity
  similarity(description, 'Astounding Drama')
FROM 
  film 
WHERE 
  to_tsvector(description) @@ 
  to_tsquery('Astounding & Drama') 
ORDER BY 
	similarity(description, 'Astounding Drama') DESC;