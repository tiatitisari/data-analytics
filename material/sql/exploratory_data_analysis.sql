-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT
  count(*) - COUNT(ticker) AS missing
FROM
  fortune500;

== COALESCE == between column -- Use coalesce
SELECT
  COALESCE(industry, sector, 'Unknown') AS industry2,
  -- Don't forget to count!
  COUNT(*)
FROM
  fortune500 -- Group by what? (What are you counting by?)
GROUP BY
  industry2 -- Order results to see most common first
ORDER BY
  COUNT(*) DESC -- Limit results to get just the one value you want
LIMIT
  1;

SELECT
  company_original.name,
  title,
  rank -- Start with original company information
FROM
  company AS company_original -- Join to another copy of company with parent
  -- company information
  LEFT JOIN company AS company_parent ON company_original.parent_id = company_parent.id -- Join to fortune500, only keep rows that match
  INNER JOIN fortune500 -- Use parent ticker if there is one, 
  -- otherwise original ticker
  ON coalesce(
    company_parent.ticker,
    company_original.ticker
  ) = fortune500.ticker -- For clarity, order by rank
ORDER BY
  rank;

== CASTING == -- Select the original value
SELECT
  profits_change,
  -- Cast profits_change
  CAST(profits_change AS INT) AS profits_change_int
FROM
  fortune500;

-- Divide 10 by 3
SELECT
  10 / 3,
  -- Cast 10 as numeric and divide by 3
  10 :: numeric / 3;

SELECT
  '3.2' :: numeric,
  '-123' :: numeric,
  '1e3' :: numeric,
  '1e-3' :: numeric,
  '02314' :: numeric,
  '0002' :: numeric;

-- Select the count of each value of revenues_change
SELECT
  revenues_change,
  COUNT(*)
FROM
  fortune500
GROUP BY
  1 -- order by the values of revenues_change
ORDER BY
  1;

-- Select the count of each revenues_change integer value
SELECT
  revenues_change :: integer,
  COUNT(*)
FROM
  fortune500
GROUP BY
  revenues_change :: integer -- order by the values of revenues_change
ORDER BY
  1;

-- Count rows 
SELECT
  COUNT(*)
FROM
  fortune500 -- Where...
WHERE
  revenues_change > 0;

-- Select average revenue per employee by sector
SELECT
  sector,
  AVG(revenues / employees :: numeric) AS avg_rev_employee
FROM
  fortune500
GROUP BY
  sector -- Use the column alias to order the results
ORDER BY
  2;

-- Divide unanswered_count by question_count
SELECT
  unanswered_count / question_count :: numeric AS computed_pct,
  -- What are you comparing the above quantity to?
  unanswered_pct
FROM
  stackoverflow -- Select rows where question_count is not 0
WHERE
  question_count != 0
LIMIT
  10;

== aggregate data == -- Select min, avg, max, and stddev of fortune500 profits
SELECT
  MIN(profits),
  AVG(profits),
  MAX(profits),
  STDDEV(profits)
FROM
  fortune500;

-- Select sector and summary measures of fortune500 profits
SELECT
  sector,
  MIN(profits),
  AVG(profits),
  MAX(profits),
  STDDEV(profits)
FROM
  fortune500 -- What to group by?
GROUP BY
  sector -- Order by the average profits
ORDER BY
  avg;

-- Compute standard deviation of maximum values
SELECT
  stddev(maxval),
  -- min
  MIN(maxval),
  -- max
  MAX(maxval),
  -- avg
  AVG(maxval) -- Subquery to compute max of question_count by tag
FROM
  (
    SELECT
      tag,
      MAX(question_count) AS maxval
    FROM
      stackoverflow -- Compute max by...
    GROUP BY
      1
  ) AS max_results;

-- alias for subquery
== EXPLORING DISTRIBUTIONS == -- trunc(value_to_truncate, places_to_truncate)
-- Truncate employees
SELECT
  trunc(employees, -5) AS employee_bin,
  -- Count number of companies with each truncated value
  COUNT(*)
FROM
  fortune500 -- Use alias to group
GROUP BY
  1 -- Use alias to order
ORDER BY
  1;

-- Truncate employees
SELECT
  trunc(employees, -4) AS employee_bin,
  -- Count number of companies with each truncated value
  COUNT(*)
FROM
  fortune500 -- Limit to which companies?
WHERE
  trunc(employees, -4) < 100000 -- Use alias to group
GROUP BY
  employee_bin -- Use alias to order
ORDER BY
  employee_bin;

== = CREATING BINS == -- Select the min and max of question_count
SELECT
  MIN(question_count),
  --2315
  MAX(question_count) --3072
  -- From what table?
FROM
  stackoverflow -- For tag dropbox
WHERE
  tag = 'dropbox';

--  	
-- Create lower and upper bounds of bins
SELECT
  generate_series(2200, 3050, 50) AS lower,
  generate_series(2250, 3100, 50) AS upper;

-- Bins created in Step 2
WITH bins AS (
  SELECT
    generate_series(2200, 3050, 50) AS lower,
    generate_series(2250, 3100, 50) AS upper
),
-- Subset stackoverflow to just tag dropbox (Step 1)
dropbox AS (
  SELECT
    question_count
  FROM
    stackoverflow
  WHERE
    tag = 'dropbox'
) -- Select columns for result
-- What column are you counting to summarize?
SELECT
  lower,
  upper,
  count(question_count)
FROM
  bins -- Created above
  -- Join to dropbox (created above), 
  -- keeping all rows from the bins table in the join
  LEFT JOIN dropbox -- Compare question_count to lower and upper
  ON question_count >= lower
  AND question_count < upper -- Group by lower and upper to count values in each bin
GROUP BY
  lower,
  upper -- Order by lower to put bins in order
ORDER BY
  lower;

== = MORE SUMMARY FUNCTIONS == -- percentile_disc --> always returns a value from colum 
-- percentile_cont --> interpolates between values 
-- common issues : error codes: 9, 99, -99, missing value codes: NA, NaN, N/A, #N/A, 0 = missing or 0? outlier(extreme) values-- really high or low? negtiive values? , not really a number
-- Correlation between revenues and profit
SELECT
  corr(revenues, profits) AS rev_profits,
  -- Correlation between revenues and assets
  corr(revenues, assets) AS rev_assets,
  -- Correlation between revenues and equity
  corr(revenues, equity) AS rev_equity
FROM
  fortune500;

-- What groups are you computing statistics by?
SELECT
  sector,
  -- Select the mean of assets with the avg function
  AVG(assets) AS mean,
  -- Select the median
  percentile_disc(0.5) WITHIN GROUP (
    ORDER BY
      assets
  ) AS median
FROM
  fortune500 -- Computing statistics for each what?
GROUP BY
  1 -- Order results by a value of interest
ORDER BY
  1;

== = CREATING TEMPORARY TABLES == 
CREATE TEMP TABLE new_tablename AS
select
  column1,
  column2
FROM
  table;

SELECT
  column1,
  column2 INTO TEMP TALBE new_tablename
FROM
  table;

-- To clear table if it already exists;
-- fill in name of temp table
DROP TABLE IF EXISTS profit80;

-- Create the temporary table
CREATE TEMP TABLE profit80 AS 
  -- Select the two columns you need; alias as needed
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    -- What table are you getting the data from?
    FROM fortune500
   -- What do you need to group by?
   GROUP BY 1 ;
   
-- See what you created: select all columns and rows 
-- from the table you created
SELECT * 
  FROM profit80;

  -- Code from previous step
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS
  SELECT sector, 
         percentile_disc(0.8) WITHIN GROUP (ORDER BY profits) AS pct80
    FROM fortune500 
   GROUP BY sector;

-- Select columns, aliasing as needed
SELECT title, fortune500.sector, 
       profits, profits/pct80 AS ratio
-- What tables do you need to join?  
  FROM fortune500 
       LEFT JOIN profit80
-- How are the tables joined?
       ON fortune500.sector=profit80.sector
-- What rows do you want to select?
 WHERE profits > pct80;

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

-- Create temp table syntax
CREATE TEMP TABLE startdates AS
-- Compute the minimum date for each what?
SELECT tag,
       MIN(date) AS mindate
  FROM stackoverflow
 -- What do you need to compute the min date for each tag?
 GROUP BY 1 ;
 
 -- Look at the table you created
 SELECT * 
   FROM startdates;

-- To clear table if it already exists
DROP TABLE IF EXISTS startdates;

CREATE TEMP TABLE startdates AS
SELECT tag, min(date) AS mindate
  FROM stackoverflow
 GROUP BY tag;
 
-- Select tag (Remember the table name!) and mindate
SELECT startdates.tag, 
       mindate, 
       -- Select question count on the min and max days
	   so_min.question_count AS min_date_question_count,
       so_max.question_count AS max_date_question_count,
       -- Compute the change in question_count (max- min)
       so_max.question_count - so_min.question_count AS change
  FROM startdates
       -- Join startdates to stackoverflow with alias so_min
       INNER JOIN stackoverflow AS so_min
          -- What needs to match between tables?
          ON startdates.tag = so_min.tag
         AND startdates.mindate = so_min.date
       -- Join to stackoverflow again with alias so_max
       INNER JOIN stackoverflow AS so_max
       	  -- Again, what needs to match between tables?
          ON startdates.tag = so_max.tag
         AND so_max.date = '2018-09-25';

DROP TABLE IF EXISTS correlations;

-- Create temp table 
CREATE TEMP TABLE correlations AS
-- Select each correlation
SELECT 'profits'::varchar AS measure,
       -- Compute correlations
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

-- Add a row for profits_change
-- Insert into what table?
INSERT INTO correlations
-- Follow the pattern of the select statement above
-- Using profits_change instead of profits
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Repeat the above, but for revenues_change
INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

-- -- Select each column, rounding the correlations
SELECT measure, 
       ROUND(profits::numeric,2) AS profits,
       ROUND(profits_change::numeric,2) AS profits_change,
       ROUND(revenues_change::numeric,2) AS revenues_change
  FROM correlations;

== CHARACTER DATA TYPES AND COMMON ISSUES == 
-- Find values of zip that appear in at least 100 rows
-- Also get the count of each value
SELECT zip, COUNT(*)
  FROM evanston311
 GROUP BY zip
HAVING COUNT(*)>=100; 

-- Find values of source that appear in at least 100 rows
-- Also get the count of each value
SELECT source, COUNT(*)
  FROM evanston311
 GROUP BY source
HAVING COUNT(*) >=100;

-- Find the 5 most common values of street and the count of each
SELECT street, COUNT(*)
  FROM evanston311
 GROUP BY 1
 ORDER BY COUNT(*) DESC
 LIMIT 5;

== CASES AND SPACES == 
SELECT distinct street,
       -- Trim off unwanted characters from street
       trim(street,'0123456789#/. ') AS cleaned_street
  FROM evanston311
 ORDER BY street;

 -- Count rows
SELECT COUNT(*)
  FROM evanston311
 -- Where description includes trash or garbage
 WHERE description ILIKE '%trash%'
    OR description ILIKE '%garbage%';

-- Count rows
SELECT COUNT(*)
  FROM evanston311 
 -- description contains trash or garbage (any case)
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
 -- category does not contain Trash or Garbage
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%';

  -- Count rows with each category
SELECT category,COUNT(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%'
    OR description ILIKE '%garbage%') 
   AND category NOT LIKE '%Trash%'
   AND category NOT LIKE '%Garbage%'
 -- What are you counting?
 GROUP BY 1
 --- order by most frequent values
 ORDER BY COUNT(*) DESC
 LIMIT 10;

 == SPLITTING AND CONCATENATING TEXT == 
-- -- Concatenate house_num, a space, and street
-- -- and trim spaces from the start of the result
SELECT TRIM(CONCAT(house_num,' ', street)) AS address
  FROM evanston311;

-- Select the first word of the street value
SELECT split_part(street,' ',1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY 1
 ORDER BY count DESC
 LIMIT 20;

 -- Select the first 50 chars when length is greater than 50
SELECT CASE WHEN length(description) > 50
            THEN LEFT(description, 50) || '...'
       -- otherwise just select description
       ELSE description
       END
  FROM evanston311
 -- limit to descriptions that start with the word I
 WHERE description LIKE 'I %'
 ORDER BY description;

 == STRATEGIES FOR MULTIPLE TRANSFORMATIONS == 
 -- Fill in the command below with the name of the temp table
DROP TABLE IF EXISTS recode;

-- Create and name the temporary table
CREATE TEMP TABLE recode AS
-- Write the select query to generate the table 
-- with distinct values of category and standardized values
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-',1)) AS standardized
    -- What table are you selecting the above values from?
    FROM evanston311;
    
-- Look at a few values before the next step
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';

-- Code from previous step
DROP TABLE IF EXISTS recode;

CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
    FROM evanston311;

-- Update to group trash cart values
UPDATE recode 
   SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

-- Update to group snow removal values
UPDATE recode 
   SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
    
-- Examine effect of updates
SELECT DISTINCT standardized 
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';

-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');
-- Code from previous step
DROP TABLE IF EXISTS recode;
CREATE TEMP TABLE recode AS
  SELECT DISTINCT category, 
         rtrim(split_part(category, '-', 1)) AS standardized
  FROM evanston311;
UPDATE recode SET standardized='Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';
UPDATE recode SET standardized='Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';
UPDATE recode SET standardized='UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE...Trash Cart', 
               '(DO NOT USE) Water Bill',
               'DO NOT USE Trash', 'NO LONGER IN USE');

-- Select the recoded categories and the count of each
SELECT standardized, COUNT(*)
-- From the original table and table with recoded values
  FROM evanston311
       LEFT JOIN recode
       -- What column do they have in common?
       ON evanston311.category = recode.category
 -- What do you need to group by to count?
 GROUP BY standardized
 -- Display the most common val values first
 ORDER BY COUNT(*) DESC;

 -- To clear table if it already exists
DROP TABLE IF EXISTS indicators;

-- Create the temp table
CREATE TEMP TABLE indicators AS
  SELECT id, 
         CAST (description LIKE '%@%' AS integer) AS email,
         CAST (description LIKE '%___-___-____%' AS integer) AS phone 
    FROM evanston311;
  
-- Select the column you'll group by
SELECT priority,
       -- Compute the proportion of rows with each indicator
       SUM(email)/COUNT(*)::numeric AS email_prop, 
       SUM(phone)/COUNT(*)::numeric AS phone_prop
  -- Tables to select from
  FROM evanston311
       LEFT JOIN indicators
       -- Joining condition
       ON evanston311.id=indicators.id
 -- What are you grouping by?
 GROUP BY 1;

 == DATE/TIME TYPES AND FORMATS == 
 -- UTC = Coordinated Universal Time 
 -- Count requests created on January 31, 2017
SELECT count(*) 
  FROM evanston311
 WHERE date_created::date = '2017-01-31';

 -- Count requests created on February 29, 2016
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29' 
   AND date_created < '2016-03-01';

-- Add 100 days to the current timestamp
SELECT now()+ '100 days'::interval;

-- Select the current timestamp, 
-- and the current timestamp + 5 minutes
SELECT now(), 
now()+ '5 minutes':: interval;


-- Count requests created on March 13, 2017
SELECT count(*)
  FROM evanston311
 WHERE date_created >= '2017-03-13'
   AND date_created < '2017-03-13'::date + 1;

-- Subtract the min date_created from the max
SELECT MAX(date_created)-MIN(date_created)
  FROM evanston311;

-- How old is the most recent request?
SELECT NOW() - MAX(date_created)
  FROM evanston311;

-- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed-date_created) AS completion_time
  FROM evanston311
  GROUP BY 1
-- Order the results
 ORDER BY 1 ;

-- Select the category and the average completion time by category
SELECT category, 
       AVG(date_completed-date_created) AS completion_time
  FROM evanston311
  GROUP BY category
-- Order the results
 ORDER BY completion_time DESC;

 == date/time components and aggregation == 
 -- date_part == extract 
 -- data trunc produced date/time 
 -- Extract the month from date_created and count requests
SELECT date_part('month', date_created) AS month, 
       COUNT(*)
  FROM evanston311
 -- Limit the date range
 WHERE date_created >= '2016-01-01'
   AND date_created < '2018-01-01'
 -- Group by what to get monthly counts?
 GROUP BY 1;

-- Count requests completed by hour
SELECT date_part('hour',date_completed) AS hour,
       COUNT(*)
  FROM evanston311
 GROUP BY 1 
 ORDER BY 1 DESC;

-- Select name of the day of the week the request was created 
SELECT to_char(date_created, 'day') AS day, 
       -- Select avg time between request creation and completion
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 -- Group by the name of the day of the week and 
 -- integer value of day of week the request was created
 GROUP BY day, EXTRACT(DOW FROM date_created)
 -- Order by integer value of the day of the week 
 -- the request was created
 ORDER BY EXTRACT(DOW FROM date_created);

-- Aggregate daily counts by month
SELECT date_trunc('month',day) AS month,
avg(count)
  -- Subquery to compute daily counts
  FROM (SELECT date_trunc('day',date_created) AS day,
               COUNT(*) AS count
          FROM evanston311
         GROUP BY 1) AS daily_count
 GROUP BY 1
 ORDER BY month;

== aggregating with date/time series == 
SELECT day
-- 1) Subquery to generate all dates
-- from min to max date_created
  FROM (SELECT generate_series(min(date_created),
                              max(date_created),
                               '1 day')::date AS day
          -- What table is date_created in?
          FROM evanston311) AS all_dates
-- 4) Select dates (day from above) that are NOT IN the subquery
 WHERE day NOT IN  
       -- 2) Subquery to select all date_created values as dates
       (SELECT date_created::date
          FROM evanston311);

-- Generate 6 month bins covering 2016-01-01 to 2018-06-30

-- Create lower bounds of bins
SELECT generate_series('2016-01-01',  -- First bin lower value
                       '2018-06-30',  -- Last bin lower value
                       '6 months'::interval) AS lower,
-- Create upper bounds of bins
       generate_series('2016-07-01',  -- First bin upper value
                       '2018-12-31',  -- Last bin upper value
                       '6 months'::interval) AS upper;

-- Count number of requests made per day
SELECT day, COUNT(date_created) AS count
-- Use a daily series from 2016-01-01 to 2018-06-30 
-- to include days with no requests
  FROM (SELECT generate_series('2016-01-01',  -- series start date
                               '2018-06-30',  -- series end date
                               '1 day'::interval)::date AS day) AS daily_series
       LEFT JOIN evanston311
       -- match day from above (which is a date) to date_created
       ON day = date_created::date
 GROUP BY day;

-- Bins from Step 1
WITH bins AS (
	 SELECT generate_series('2016-01-01',
                            '2018-01-01',
                            '6 months'::interval) AS lower,
            generate_series('2016-07-01',
                            '2018-07-01',
                            '6 months'::interval) AS upper),
-- Daily counts from Step 2
     daily_counts AS (
     SELECT day, count(date_created) AS count
       FROM (SELECT generate_series('2016-01-01',
                                    '2018-06-30',
                                    '1 day'::interval)::date AS day) AS daily_series
            LEFT JOIN evanston311
            ON day = date_created::date
      GROUP BY day)
-- Select bin bounds 
SELECT lower, 
       upper, 
       -- Compute median of count for each bin
       percentile_disc(0.5) WITHIN GROUP (ORDER BY count) AS median
  -- Join bins and daily_counts
  FROM bins
       LEFT JOIN daily_counts
       -- Where the day is between the bin bounds
       ON day >= lower
          AND day < upper
 -- Group by bin bounds
 GROUP BY 1, 2
 ORDER BY lower;

-- generate series with all days from 2016-01-01 to 2018-06-30
WITH all_days AS 
     (SELECT generate_series('2016-01-01',
                             '2018-06-30',
                             '1 day'::interval) AS date),
     -- Subquery to compute daily counts
     daily_count AS 
     (SELECT date_trunc('day', date_created) AS day,
             count(*) AS count
        FROM evanston311
       GROUP BY day)
-- Aggregate daily counts by month using date_trunc
SELECT date_trunc('month',date) AS month,
       -- Use coalesce to replace NULL count values with 0
       avg(coalesce(count, 0)) AS average
  FROM all_days
       LEFT JOIN daily_count
       -- Joining condition
       ON all_days.date=daily_count.day
 GROUP BY month
 ORDER BY month; 

 === time between events == 
 -- LAG -- previous data for current data 
 -- LEAD -- future data for current data 
 -- Compute the gaps
WITH request_gaps AS (
        SELECT date_created,
               -- lead or lag
               LAG(date_created) OVER (ORDER BY date_created) AS previous,
               -- compute gap as date_created minus lead or lag
               date_created - LAG(date_created) OVER (ORDER BY date_created) AS gap
          FROM evanston311)
-- Select the row with the maximum gap
SELECT *
  FROM request_gaps
-- Subquery to select maximum gap from request_gaps
 WHERE gap = (SELECT MAX(gap)
                FROM request_gaps);

-- Truncate the time to complete requests to the day
SELECT DATE_TRUNC('day',date_completed-date_created) AS completion_time,
-- Count requests with each truncated time
       COUNT(date_created)
  FROM evanston311
-- Where category is rats
 WHERE category = 'Rodents- Rats'
-- Group and order by the variable of interest
 GROUP BY 1
 ORDER BY 2 DESC;

SELECT category, 
       -- Compute average completion time per category
       AVG(date_completed - date_created) AS avg_completion_time
  FROM evanston311
-- Where completion time is less than the 95th percentile value
 WHERE date_completed-date_created < 
-- Compute the 95th percentile of completion time in a subquery
         (SELECT percentile_disc(0.95) WITHIN GROUP (ORDER BY date_completed - date_created)
            FROM evanston311)
 GROUP BY category
-- Order the results
 ORDER BY avg_completion_time DESC;


-- Compute correlation (corr) between 
-- avg_completion time and count from the subquery
SELECT corr(avg_completion, count)
  -- Convert date_created to its month with date_trunc
  FROM (SELECT date_trunc('month', date_created) AS month, 
               -- Compute average completion time in number of seconds           
               avg(EXTRACT(epoch FROM date_completed - date_created)) AS avg_completion, 
               -- Count requests per month
               count(*) AS count
          FROM evanston311
         -- Limit to rodents
         WHERE category='Rodents- Rats' 
         -- Group by month, created above
         GROUP BY month) 
         -- Required alias for subquery 
         AS monthly_avgs;

-- Compute monthly counts of requests created
WITH created AS (
       SELECT DATE_TRUNC('month', date_created) AS month,
              count(*) AS created_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month),
-- Compute monthly counts of requests completed
      completed AS (
       SELECT DATE_TRUNC('month', date_completed) AS month,
              count(*) AS completed_count
         FROM evanston311
        WHERE category='Rodents- Rats'
        GROUP BY month)
-- Join monthly created and completed counts
SELECT created.month, 
       created_count, 
       completed_count
  FROM created
       INNER JOIN completed
       ON created.month=completed.month
 ORDER BY created.month;
