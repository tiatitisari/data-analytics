SELECT
    *
FROM
    renting -- Select all;        -- From table renting
SELECT
    movie_id,
    rating -- Select all columns needed to compute the average rating per movie
FROM
    renting
ORDER BY
    2 DESC;

== FILTERING
AND ORDERING ==
SELECT
    *
FROM
    renting
WHERE
    date_renting = '2018-10-09';

-- Movies rented on October 9th, 2018
SELECT
    *
FROM
    renting
WHERE
    date_renting BETWEEN '2018-04-01'
    AND '2018-08-31';

-- from beginning April 2018 to end August 2018
SELECT
    *
FROM
    renting
WHERE
    date_renting BETWEEN '2018-04-01'
    AND '2018-08-31'
ORDER BY
    date_renting DESC;

-- Order by recency in decreasing order
SELECT
    *
FROM
    movies
WHERE
    genre <> 'Drama';

-- All genres except drama
SELECT
    *
FROM
    movies
WHERE
    title IN ('Showtime', 'Love Actually', 'The Fighter');

-- Select all movies with the given titles
SELECT
    *
FROM
    movies
ORDER BY
    renting_price DESC;

-- Order the movies by increasing renting price
SELECT
    *
FROM
    renting
WHERE
    date_renting BETWEEN '2018-01-01'
    AND '2018-12-31' -- Renting in 2018
    AND rating IS NOT NULL;

-- Rating exists
== AGGREGATIONS - SUMMARIZING DATA ==
SELECT
    COUNT(*) -- Count the total number of customers
FROM
    customers
WHERE
    date_of_birth BETWEEN '1980-01-01'
    AND '1989-12-31';

-- Select customers born between 1980-01-01 and 1989-12-31
SELECT
    COUNT(*) -- Count the total number of customers
FROM
    customers
WHERE
    country = 'Germany';

-- Select all customers from Germany
SELECT
    COUNT(DISTINCT country) -- Count the number of countries
FROM
    customers;

SELECT
    MIN(rating) AS min_rating,
    -- Calculate the minimum rating and use alias min_rating
    MAX(rating) AS max_rating,
    -- Calculate the maximum rating and use alias max_rating
    AVG(rating) AS avg_rating,
    -- Calculate the average rating and use alias avg_rating
    COUNT(rating) AS number_ratings -- Count the number of ratings and use alias number_ratings
FROM
    renting
WHERE
    movie_id = '25';

-- Select all records of the movie with ID 25
== GROUPING ==
SELECT
    country,
    -- For each country report the earliest date when an account was created
    MIN(date_account_start) AS first_account
FROM
    customers
GROUP BY
    1
ORDER BY
    2 ASC;

SELECT
    movie_id,
    AVG(rating) -- Calculate average rating per movie
FROM
    renting
GROUP BY
    1;

SELECT
    movie_id,
    AVG(rating) AS avg_rating,
    -- Use as alias avg_rating
    COUNT(rating) AS number_rating,
    -- Add column for number of ratings with alias number_rating
    COUNT(movie_id) AS number_renting -- Add column for number of movie rentals with alias number_renting
FROM
    renting
GROUP BY
    movie_id;

SELECT
    movie_id,
    AVG(rating) AS avg_rating,
    COUNT(rating) AS number_ratings,
    COUNT(*) AS number_renting
FROM
    renting
GROUP BY
    movie_id
ORDER BY
    avg_rating DESC;

-- Order by average rating in decreasing order
SELECT
    customer_id,
    -- Report the customer_id
    AVG(rating),
    -- Report the average rating per customer
    COUNT(rating),
    -- Report the number of ratings per customer
    COUNT(movie_id) -- Report the number of movie rentals per customer
FROM
    renting
GROUP BY
    customer_id
HAVING
    COUNT(movie_id) > 7 -- Select only customers with more than 7 movie rentals
ORDER BY
    2 DESC;

-- Order by the average rating in ascending order
== JOINING MOVIE RATINGS WITH CUSTOMER DATA ==
SELECT
    * -- Join renting with customers
FROM
    renting r
    LEFT JOIN customers c ON r.customer_id = c.customer_id;

SELECT
    *
FROM
    renting AS r
    LEFT JOIN customers AS c ON r.customer_id = c.customer_id
WHERE
    country = 'Belgium';

-- Select only records from customers coming from Belgium
SELECT
    *
FROM
    renting AS r
    LEFT JOIN movies AS m -- Choose the correct join statment
    ON r.movie_id = m.movie_id;

SELECT
    SUM(m.renting_price),
    COUNT(*),
    COUNT(DISTINCT r.customer_id)
FROM
    renting AS r
    LEFT JOIN movies AS m ON r.movie_id = m.movie_id -- Only look at movie rentals in 2018
WHERE
    date_renting BETWEEN '2018-01-01'
    AND '2018-12-31';

SELECT
    title,
    -- Create a list of movie titles and actor names
    name
FROM
    actsin ai
    LEFT JOIN movies AS m ON m.movie_id = ai.movie_id
    LEFT JOIN actors AS a ON a.actor_id = ai.actor_id;

SELECT
    title,
    -- Report the income from movie rentals for each movie 
    SUM(renting_price) AS income_movie
FROM
    (
        SELECT
            m.title,
            m.renting_price
        FROM
            renting AS r
            LEFT JOIN movies AS m ON r.movie_id = m.movie_id
    ) AS rm
GROUP BY
    1
ORDER BY
    2 DESC;

-- Order the result by decreasing income
SELECT
    a.gender,
    -- Report for male and female actors from the USA 
    MIN(a.year_of_birth),
    -- The year of birth of the oldest actor
    MAX(a.year_of_birth) -- The year of birth of the youngest actor
FROM
    (
        SELECT
            * -- Use a subsequent SELECT to get all information about actors from the USA
        FROM
            actors
        WHERE
            nationality = 'USA'
    ) AS a -- Give the table the name a
GROUP BY
    a.gender;

== identify favorite actors of customer groups ==
SELECT
    *
FROM
    renting AS r
    LEFT JOIN customers c -- Add customer information
    ON r.customer_id = c.customer_id
    LEFT JOIN movies m -- Add movie information
    ON r.movie_id = m.movie_id;

SELECT
    *
FROM
    renting AS r
    LEFT JOIN customers AS c ON c.customer_id = r.customer_id
    LEFT JOIN movies AS m ON m.movie_id = r.movie_id
WHERE
    EXTRACT(
        YEAR
        FROM
            date_of_birth
    ) BETWEEN '1970'
    AND '1979';

-- Select customers born in the 70s
SELECT
    m.title,
    COUNT(renting_id),
    -- Report number of views per movie
    AVG(rating) -- Report the average rating per movie
FROM
    renting AS r
    LEFT JOIN customers AS c ON c.customer_id = r.customer_id
    LEFT JOIN movies AS m ON m.movie_id = r.movie_id
WHERE
    c.date_of_birth BETWEEN '1970-01-01'
    AND '1979-12-31'
GROUP BY
    1;

SELECT
    m.title,
    COUNT(*),
    AVG(r.rating)
FROM
    renting AS r
    LEFT JOIN customers AS c ON c.customer_id = r.customer_id
    LEFT JOIN movies AS m ON m.movie_id = r.movie_id
WHERE
    c.date_of_birth BETWEEN '1970-01-01'
    AND '1979-12-31'
GROUP BY
    m.title
HAVING
    COUNT(*) != 1 -- Remove movies with only one rental
ORDER BY
    AVG(r.rating) DESC;

-- Order with highest rating first
SELECT
    *
FROM
    renting as r
    LEFT JOIN customers c -- Augment table renting with information about customers 
    ON r.customer_id = c.customer_id
    LEFT JOIN actsin ac -- Augment the table renting with the table actsin
    ON r.movie_id = ac.movie_id
    LEFT JOIN actors at -- Augment table renting with information about actors
    ON ac.actor_id = at.actor_id;

SELECT
    a.name,
    c.gender,
    COUNT(*) AS number_views,
    AVG(r.rating) AS avg_rating
FROM
    renting as r
    LEFT JOIN customers AS c ON r.customer_id = c.customer_id
    LEFT JOIN actsin as ai ON r.movie_id = ai.movie_id
    LEFT JOIN actors as a ON ai.actor_id = a.actor_id
GROUP BY
    a.name,
    c.gender -- For each actor, separately for male and female customers
HAVING
    AVG(r.rating) IS NOT NULL
    AND COUNT(*) > 5 -- Report only actors with more than 5 movie rentals
ORDER BY
    avg_rating DESC,
    number_views DESC;

SELECT
    a.name,
    c.gender,
    COUNT(*) AS number_views,
    AVG(r.rating) AS avg_rating
FROM
    renting as r
    LEFT JOIN customers AS c ON r.customer_id = c.customer_id
    LEFT JOIN actsin as ai ON r.movie_id = ai.movie_id
    LEFT JOIN actors as a ON ai.actor_id = a.actor_id
WHERE
    country = 'Spain' -- Select only customers from Spain
GROUP BY
    a.name,
    c.gender
HAVING
    AVG(r.rating) IS NOT NULL
    AND COUNT(*) > 5
ORDER BY
    avg_rating DESC,
    number_views DESC;

SELECT
    *
FROM
    renting r -- Augment the table renting with information about customers
    LEFT JOIN customers c ON r.customer_id = c.customer_id
    LEFT JOIN movies m -- Augment the table renting with information about movies
    ON r.movie_id = m.movie_id
WHERE
    date_renting >= '2019-01-01';

-- Select only records about rentals since the beginning of 2019
SELECT
    country,
    -- For each country report
    COUNT(*) AS number_renting,
    -- The number of movie rentals
    AVG(rating) AS average_rating,
    -- The average rating
    SUM(renting_price) AS revenue -- The revenue from movie rentals
FROM
    renting AS r
    LEFT JOIN customers AS c ON c.customer_id = r.customer_id
    LEFT JOIN movies AS m ON m.movie_id = r.movie_id
WHERE
    date_renting >= '2019-01-01'
GROUP BY
    1;

== NESTED QUERY ==
SELECT
    *
FROM
    movies
WHERE
    movie_id IN -- Select movie IDs from the inner query
    (
        SELECT
            movie_id
        FROM
            renting
        GROUP BY
            movie_id
        HAVING
            COUNT(*) > 5
    )
SELECT
    *
FROM
    customers
WHERE
    customer_id IN -- Select all customers with more than 10 movie rentals
    (
        SELECT
            customer_id
        FROM
            renting
        GROUP BY
            customer_id
        HAVING
            COUNT(*) > 10
    );

SELECT
    title -- Report the movie titles of all movies with average rating higher than the total average
FROM
    movies
WHERE
    movie_id IN (
        SELECT
            movie_id
        FROM
            renting
        GROUP BY
            movie_id
        HAVING
            AVG(rating) > (
                SELECT
                    AVG(rating)
                FROM
                    renting
            )
    );

== CORRELATED QUERIES == -- Select customers with less than 5 movie rentals
SELECT
    *
FROM
    customers as c
WHERE
    5 > (
        SELECT
            count(*)
        FROM
            renting as r
        WHERE
            r.customer_id = c.customer_id
    );

SELECT
    *
FROM
    customers c
WHERE
    4 > -- Select all customers with a minimum rating smaller than 4 
    (
        SELECT
            MIN(rating)
        FROM
            renting AS r
        WHERE
            r.customer_id = c.customer_id
    );

SELECT
    *
FROM
    movies AS m
WHERE
    8 < -- Select all movies with an average rating higher than 8
    (
        SELECT
            AVG(rating)
        FROM
            renting AS r
        WHERE
            r.movie_id = m.movie_id
    );

SELECT
    *
FROM
    customers c -- Select all customers with at least one rating
WHERE
    EXISTS (
        SELECT
            *
        FROM
            renting AS r
        WHERE
            rating IS NOT NULL
            AND r.customer_id = c.customer_id
    );

SELECT
    * -- Select the records from the table `actsin` of all actors who play in a Comedy
FROM
    actsin AS ai
    LEFT JOIN movies AS m ON ai.movie_id = m.movie_id
WHERE
    m.genre = 'Comedy';

SELECT
    a.nationality,
    COUNT(*) -- Report the nationality and the number of actors for each nationality
FROM
    actors AS a
WHERE
    EXISTS (
        SELECT
            ai.actor_id
        FROM
            actsin AS ai
            LEFT JOIN movies AS m ON m.movie_id = ai.movie_id
        WHERE
            m.genre = 'Comedy'
            AND ai.actor_id = a.actor_id
    )
GROUP BY
    a.nationality;

== UNION AND INTERSECT === 
-- UNION : not duplicate
-- INTERSECT : both table has the same value kinda like inner join 

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
UNION -- Select all actors who are not from the USA and all actors who are born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
INTERSECT -- Select all actors who are not from the USA and who are also born after 1990
SELECT name, 
       nationality, 
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;

SELECT movie_id
FROM movies
WHERE genre = 'Drama'
INTERSECT  -- Select the IDs of all dramas with average rating higher than 9
SELECT movie_id
FROM renting
GROUP BY movie_id
HAVING AVG(rating)>9;

SELECT *
FROM movies
WHERE movie_id IN-- Select all movies of genre drama with average rating higher than 9
   (SELECT movie_id
    FROM movies
    WHERE genre = 'Drama'
    INTERSECT
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating)>9);

== CUBE == 

SELECT gender, -- Extract information of a pivot table of gender and country for the number of customers
	   country,
	   COUNT(*)
FROM customers
GROUP BY CUBE (gender, country)
ORDER BY country;

SELECT genre,
       year_of_release,
       COUNT(*)
FROM movies
GROUP BY CUBE(genre,year_of_release)
ORDER BY year_of_release;

SELECT 
	country, 
	genre, 
	AVG(r.rating) AS avg_rating -- Calculate the average rating 
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY CUBE(country,genre); -- For all aggregation levels of country and genre

== ROLLUP == 
-- Count the total number of customers, the number of customers for each country, and the number of female and male customers for each country
SELECT country,
       gender,
	   COUNT(*)
FROM customers
GROUP BY ROLLUP (country, gender)
ORDER BY country, gender ; -- Order the result by country and gender

-- Group by each county and genre with OLAP extension
SELECT 
	c.country, 
	m.genre, 
	AVG(r.rating) AS avg_rating, 
	COUNT(*) AS num_rating
FROM renting AS r
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
GROUP BY ROLLUP(country,genre)
ORDER BY c.country, m.genre;

== grouping sets == 

SELECT 
	nationality, -- Select nationality of the actors
    gender, -- Select gender of the actors
    COUNT(*) -- Count the number of actors
FROM actors
GROUP BY GROUPING SETS ((nationality), (gender), ()); -- Use the correct GROUPING SETS operation

SELECT 
	c.country, 
    c.gender,
	AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
-- Report all info from a Pivot table for country and gender
GROUP BY GROUPING SETS ((country, gender), (country), (gender),());

SELECT a.nationality,
       a.gender,
	   AVG(r.rating) AS avg_rating,
	   COUNT(r.rating) AS n_rating,
	   COUNT(*) AS n_rentals,
	   COUNT(DISTINCT a.actor_id) AS n_actors
FROM renting AS r
LEFT JOIN actsin AS ai
ON ai.movie_id = r.movie_id
LEFT JOIN actors AS a
ON ai.actor_id = a.actor_id
WHERE r.movie_id IN ( 
	SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(rating) >= 4)
AND r.date_renting >= '2018-04-01'
GROUP BY CUBE(nationality,gender); -- Provide results for all aggregation levels represented in a pivot table