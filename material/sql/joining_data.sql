#####################
--- INNER JOIN --- 
#####################
-- Select all columns from cities
SELECT
    *
FROM
    cities
SELECT
    *
FROM
    cities -- Inner join to countries
    INNER JOIN countries -- Match on country codes
    ON cities.country_code = countries.code -- Select name fields (with alias) and region 
SELECT
    cities.name AS city,
    countries.name AS country,
    countries.region
FROM
    cities
    INNER JOIN countries ON cities.country_code = countries.code;

-- Select fields with aliases
SELECT
    c.code AS country_code,
    c.name,
    e.year,
    e.inflation_rate
FROM
    countries AS c -- Join to economies (alias e)
    INNER JOIN economies e -- Match on code field using table aliases
    ON c.code = e.code
SELECT
    c.name AS country,
    l.name AS language,
    official
FROM
    countries AS c
    INNER JOIN languages AS l -- Match using the code column
    USING(code);

#####################
--- DEFINING RELATIONSHIPS --- 
#####################
-- Select country and language names, aliased
SELECT
    c.name AS country,
    l.name AS language -- From countries (aliased)
FROM
    countries c -- Join to languages (aliased)
    INNER JOIN languages l -- Use code as the joining field with the USING keyword
    USING(code);

#####################
--- MULTIPLE JOINS --- 
#####################
-- Select fields
SELECT
    name,
    e.year,
    fertility_rate,
    unemployment_rate
FROM
    countries AS c
    INNER JOIN populations AS p ON c.code = p.country_code -- Join to economies (as e)
    INNER JOIN economies AS e -- Match on country code
    USING(code);

SELECT
    name,
    e.year,
    fertility_rate,
    unemployment_rate
FROM
    countries AS c
    INNER JOIN populations AS p ON c.code = p.country_code
    INNER JOIN economies AS e ON c.code = e.code -- Add an additional joining condition such that you are also joining on year
    AND p.year = e.year;

#####################
--- LEFT JOIN AND RIGHT JOIN --- 
#####################
SELECT
    c1.name AS city,
    code,
    c2.name AS country,
    region,
    city_proper_pop
FROM
    cities AS c1 -- Join right table (with alias)
    LEFT JOIN countries AS c2 ON c1.country_code = c2.code
ORDER BY
    code DESC;

SELECT
    region,
    AVG(gdp_percapita) AS avg_gdp
FROM
    countries AS c
    LEFT JOIN economies AS e USING(code)
WHERE
    year = 2010
GROUP BY
    region -- Order by descending avg_gdp
ORDER BY
    2 DESC -- Return only first 10 records
LIMIT
    10;

-- Modify this query to use RIGHT JOIN instead of LEFT JOIN
SELECT
    countries.name AS country,
    languages.name AS language,
    percent
FROM
    countries
    RIGHT JOIN languages USING(code)
ORDER BY
    language;

#####################
--- FULL JOIN --- 
#####################
SELECT
    name AS country,
    code,
    region,
    basic_unit
FROM
    countries -- Join to currencies
    FULL
    JOIN currencies USING (code) -- Where region is North America or name is null
WHERE
    region = 'North America'
    OR name IS NULL
ORDER BY
    region;

SELECT
    c1.name AS country,
    region,
    l.name AS language,
    basic_unit,
    frac_unit
FROM
    countries as c1 -- Full join with languages (alias as l)
    FULL
    JOIN languages AS l USING(code) -- Full join with currencies (alias as c2)
    FULL
    JOIN currencies c2 USING(code)
WHERE
    region LIKE 'M%esia';

#####################
--- CROSS JOIN --- 
#####################
SELECT
    c.name AS country,
    l.name AS language
FROM
    countries AS c -- Perform a cross join to languages (alias as l)
    CROSS JOIN languages AS l
WHERE
    c.code in ('PAK', 'IND')
    AND l.code in ('PAK', 'IND');

#####################
--- SELF JOIN --- 
#####################
--- compare parts of the same table 
SELECT
    p1.country_code,
    p1.size AS size2010,
    p2.size AS size2015
FROM
    populations AS p1
    INNER JOIN populations AS p2 ON p1.country_code = p2.country_code
WHERE
    p1.year = 2010 -- Filter such that p1.year is always five years before p2.year
    AND p1.year = p2.year -5;

#####################
--- Set theory for SQL Joins --- 
#####################
--- UNION, INTERSECT, EXCEPT 
--- UNION WILL DELETE duplicate record, while UNION ALL not deleting duplicate record 
-- Select all fields from economies2015
SELECT
    *
FROM
    economies2015 -- Set operation
UNION
-- Select all fields from economies2019
SELECT
    *
FROM
    economies2019
ORDER BY
    code,
    year;

-- Query that determines all pairs of code and year from economies and populations, without duplicates
SELECT
    code,
    year
FROM
    economies
UNION
SELECT
    country_code,
    year
FROM
    populations
SELECT
    code,
    year
FROM
    economies -- Set theory clause
UNION
ALL
SELECT
    country_code,
    year
FROM
    populations
ORDER BY
    code,
    year;

#####################
--- INTERSECT --- 
#####################
-- Return all cities with the same name as a country
SELECT
    name
FROM
    countries
INTERSECT
SELECT
    name
FROM
    cities #####################
    --- EXCEPT --- 
    #####################
    -- between two tables only exist in 1 table not the other table 
    -- Return all cities that do not have the same name as a country
SELECT
    name
FROM
    cities
EXCEPT
SELECT
    name
FROM
    countries
ORDER BY
    name;

#####################
--- Subquerying WITH semi joins AND anti joins --- 
#####################
--- semi join chooses records in the first table where a condition is met in the second table. anti join is otherwise
--- or subqueries
SELECT
    DISTINCT name
FROM
    languages -- Add syntax to use bracketed subquery below as a filter
WHERE
    code IN (
        SELECT
            code
        FROM
            countries
        WHERE
            region = 'Middle East'
    )
ORDER BY
    name;

SELECT
    code,
    name
FROM
    countries
WHERE
    continent = 'Oceania' -- Filter for countries not included in the bracketed subquery
    AND code NOT IN (
        SELECT
            code
        FROM
            currencies
    );

#####################
--- Subquerying inside SELECT 
#####################    
SELECT
    countries.name AS country,
    -- Subquery that provides the count of cities   
    (
        SELECT
            COUNT(name)
        FROM
            cities
        WHERE
            cities.country_code = countries.code
    ) AS cities_num
FROM
    countries
ORDER BY
    cities_num DESC,
    country
LIMIT
    9;

#####################
--- Subquerying inside FROM 
##################### 
-- Select local_name and lang_num from appropriate tables
SELECT local_name, lang_num 
FROM countries, 
  (SELECT code, COUNT(*) AS lang_num
  FROM languages
  GROUP BY code) AS sub
-- Where codes match
WHERE countries.code = sub.code 
ORDER BY lang_num DESC;

-- Select relevant fields
SELECT code, inflation_rate, unemployment_rate
FROM economies 
WHERE year = 2015 
  AND code NOT IN
-- Subquery returning country codes filtered on gov_form
	(SELECT code 
  FROM countries
  WHERE gov_form LIKE '%Republic%'
  OR gov_form LIKE '%Monarchy%' )
ORDER BY inflation_rate;

-- Select fields from cities
SELECT name, country_code, city_proper_pop, metroarea_pop, city_proper_pop / metroarea_pop * 100 AS city_perc
-- Use subquery to filter city name
FROM cities 
WHERE name NOT IN 
(SELECT name 
FROM 
countries 
WHERE continent LIKE '%Europe%'
OR continent LIKE '%America%')
-- Add filter condition such that metroarea_pop does not have null values
AND metroarea_pop IS NOT NULL 
-- Sort and limit the result
ORDER BY city_perc DESC 
LIMIT 10;