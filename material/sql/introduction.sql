-- Selecting field -- 
SELECT name, member_year
FROM database; 

-- Selecting all fields -- 
SELECT * FROM database; 

-- Aliasing -- 
SELECT name AS first_name, year_hired 
FROM employees; 

-- Unique data -- 
SELECT DISTINCT year_hired 
FROM employees; 

-- Create views -- 
CREATE VIEW employee_hire_years AS 
SELECT id, name, year_hired 
FROM employees; 

-- limit number -- 
## postgre ## 
SELECT genre 
FROM books LIMIT 10; 

## sql server ## 
SELECT TOP 10 genre 
FROM books 