== Relational Databases == 
1. Define relationships between tables of data inside the database 
2. Database can store much more data than Excel 
3. More secured because encryption 

== SQL == 
1. Structured Query Language 
2. The most widely used programming language for databases 
3. Free and paid, paid one SQL server and oracle
4. PostgreSQL free and open source relational database system (Limit)
5. SQL Server to limit using top 

== Tables == 
1. Table rows == records (unlimited), table columns == fields (limited)
2. Table name should be lowercase, no spaces
3. Field name should be lowercase, no spaces, singluar non plural, must be different from other field names, must be different from the table name 
4. Table need unique identifier to identify each records from other

== Data == 
1. Type: 
    a. VARCHAR to store String data (sequence of characters such as letters or punctuation up to 250 characters)
    b. INT to store integer data (whole number)
    c. NUMERIC to store float data (include fractional part of number)
2. Schema : Scheme of field type 
3. Storage : Place to stored data (harddisk of a server/cloud )

== How SQL works == 
1. SQL is not processed in its written order 
    a. FROM 
    b. JOIN 
    c. WHERE 
    d. GROUP BY 
    e. HAVING
    f. SELECT
    g. WINDOW FUNCTION
    h. ORDER BY 
    i. LIMIT 
2. Formatting is not required 
3. Best practices : 
    a. Keyword capitalization 
    b. New line 
    c. Semicolon at the end of query 
4. Holywell's style guide: https://www.sqlstyle.guide/
5. Windows function available in PostgreSQL, Oracle, MySQL, SQL Server but not SQLite

== A few reminders == 
1. NULL >> MISSING DATA 
2. PUT IS NULL, IS NOT NULL .. DON'T USE = NULL 
3. COUNT(*) >> COUNTING NUMBER OF ROWS INCLUDING NULL VALUES 
4. COUNT(column_name) >> COUNTING NUMBER OF NON-NULL VALUES 
5. COUNT(DISTINCT column_name) >> COUNTING OF DIFFERENT NON-NULL VALUES 
6. SELECT DISTINCT column_name >> DISTINCT VALUES, INCLUDING NULL 
