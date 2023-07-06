-- Select the count of ticker, 
-- subtract from the total number of rows, 
-- and alias as missing
SELECT count(*) - COUNT(ticker) AS missing
  FROM fortune500;
== COALESCE == between column 
-- Use coalesce
SELECT COALESCE(industry, sector, 'Unknown') AS industry2,
       -- Don't forget to count!
       COUNT(*)
  FROM fortune500
-- Group by what? (What are you counting by?)
 GROUP BY industry2
-- Order results to see most common first
 ORDER BY COUNT(*) DESC
-- Limit results to get just the one value you want
 LIMIT 1 ;

 SELECT company_original.name, title,rank
  -- Start with original company information
  FROM company AS company_original
       -- Join to another copy of company with parent
       -- company information
	   LEFT JOIN company AS company_parent
       ON company_original.parent_id = company_parent.id
       -- Join to fortune500, only keep rows that match
       INNER JOIN fortune500 
       -- Use parent ticker if there is one, 
       -- otherwise original ticker
       ON coalesce(company_parent.ticker, 
                   company_original.ticker) = 
             fortune500.ticker
 -- For clarity, order by rank
 ORDER BY rank; 

== CASTING ==
-- Select the original value
SELECT profits_change, 
	   -- Cast profits_change
       CAST(profits_change AS INT) AS profits_change_int
  FROM fortune500;

-- Divide 10 by 3
SELECT 10/3, 
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;

SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;

-- Select the count of each value of revenues_change
SELECT revenues_change, COUNT(*)
  FROM fortune500
 GROUP BY 1 
 -- order by the values of revenues_change
 ORDER BY 1;

 -- Select the count of each revenues_change integer value
SELECT revenues_change::integer, COUNT(*)
  FROM fortune500
GROUP BY revenues_change::integer
 -- order by the values of revenues_change
 ORDER BY 1;
 
 -- Count rows 
SELECT COUNT(*)
  FROM fortune500
 -- Where...
 WHERE revenues_change >0;