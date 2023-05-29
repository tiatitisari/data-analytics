#####################
--- CASE Statement -- 
#####################
-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT
    CASE
        WHEN hometeam_id = '10189' THEN 'FC Schalke 04'
        WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
        ELSE 'Other'
    END AS home_team,
    COUNT(id) AS total_matches
FROM
    matches_germany -- Group by the CASE statement alias
GROUP BY
    1;

SELECT
    -- Select the date of the match
    date,
    -- Identify home wins, losses, or ties
    CASE
        WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN 'Home loss :('
        ELSE 'Tie'
    END AS outcome
FROM
    matches_spain;

SELECT
    m.date,
    --Select the team long name column and call it 'opponent'
    t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
    CASE
        WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie'
    END AS outcome
FROM
    matches_spain AS m -- Left join teams_spain onto matches_spain
    LEFT JOIN teams_spain AS t ON m.awayteam_id = t.team_api_id;

SELECT
    m.date,
    t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
    CASE
        WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :('
        ELSE 'Tie'
    END AS outcome
FROM
    matches_spain AS m
    LEFT JOIN teams_spain AS t ON m.awayteam_id = t.team_api_id -- Filter for Barcelona as the home team
WHERE
    m.hometeam_id = '8634';

#####################
--- CASE Statement getting more complex -- 
#####################
SELECT
    date,
    -- Identify the home team as Barcelona or Real Madrid
    CASE
        WHEN hometeam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF'
    END AS home,
    -- Identify the away team as Barcelona or Real Madrid
    CASE
        WHEN awayteam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF'
    END AS away
FROM
    matches_spain
WHERE
    (
        awayteam_id = 8634
        OR hometeam_id = 8634
    )
    AND (
        awayteam_id = 8633
        OR hometeam_id = 8633
    );

SELECT
    date,
    CASE
        WHEN hometeam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF'
    END as home,
    CASE
        WHEN awayteam_id = 8634 THEN 'FC Barcelona'
        ELSE 'Real Madrid CF'
    END as away,
    -- Identify all possible match outcomes
    CASE
        WHEN home_goal > away_goal
        AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal
        AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal
        AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal
        AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!'
    END AS outcome
FROM
    matches_spain
WHERE
    (
        awayteam_id = 8634
        OR hometeam_id = 8634
    )
    AND (
        awayteam_id = 8633
        OR hometeam_id = 8633
    );

-- Select the season, date, home_goal, and away_goal columns
SELECT
    season,
    date,
    home_goal,
    away_goal
FROM
    matches_italy
WHERE
    -- Exclude games not won by Bologna
    CASE
        WHEN hometeam_id = 9857
        AND home_goal > away_goal THEN 'Bologna Win'
        WHEN awayteam_id = 9857
        AND away_goal > home_goal THEN 'Bologna Win'
    END IS NOT NULL;

SELECT
    c.name AS country,
    -- Count games from the 2012/2013 season
    COUNT(
        CASE
            WHEN m.season = '2012/2013' THEN m.id
            ELSE NULL
        END
    ) AS matches_2012_2013
FROM
    country AS c
    LEFT JOIN match AS m ON c.id = m.country_id -- Group by country name alias
GROUP BY
    1;

SELECT
    c.name AS country,
    -- Count matches in each of the 3 seasons
    COUNT(
        CASE
            WHEN m.season = '2012/2013' THEN m.id
        END
    ) AS matches_2012_2013,
    COUNT(
        CASE
            WHEN m.season = '2013/2014' THEN m.id
        END
    ) AS matches_2013_2014,
    COUNT(
        CASE
            WHEN m.season = '2014/2015' THEN m.id
        END
    ) AS matches_2014_2015
FROM
    country AS c
    LEFT JOIN match AS m ON c.id = m.country_id -- Group by country name alias
GROUP BY
    1;

SELECT
    c.name AS country,
    -- Sum the total records in each season where the home team won
    SUM(
        CASE
            WHEN m.season = '2012/2013'
            AND m.home_goal > m.away_goal THEN 1
            ELSE 0
        END
    ) AS matches_2012_2013,
    SUM(
        CASE
            WHEN m.season = '2013/2014'
            AND m.home_goal > m.away_goal THEN 1
            ELSE 0
        END
    ) AS matches_2013_2014,
    SUM(
        CASE
            WHEN m.season = '2014/2015'
            AND m.home_goal > m.away_goal THEN 1
            ELSE 0
        END
    ) AS matches_2014_2015
FROM
    country AS c
    LEFT JOIN match AS m ON c.id = m.country_id -- Group by country name alias
GROUP BY
    1;

SELECT
    c.name AS country,
    -- Count the home wins, away wins, and ties in each country
    COUNT(
        CASE
            WHEN m.home_goal > m.away_goal THEN m.id
        END
    ) AS home_wins,
    COUNT(
        CASE
            WHEN m.home_goal < m.away_goal THEN m.id
        END
    ) AS away_wins,
    COUNT(
        CASE
            WHEN m.home_goal = m.away_goal THEN m.id
        END
    ) AS ties
FROM
    country AS c
    LEFT JOIN matches AS m ON c.id = m.country_id
GROUP BY
    country;

SELECT
    c.name AS country,
    -- Calculate the percentage of tied games in each season
    AVG(
        CASE
            WHEN m.season = '2013/2014'
            AND m.home_goal = m.away_goal THEN 1
            WHEN m.season = '2013/2014'
            AND m.home_goal <> m.away_goal THEN 0
        END
    ) AS ties_2013_2014,
    AVG(
        CASE
            WHEN m.season = '2014/2015'
            AND m.home_goal = m.away_goal THEN 1
            WHEN m.season = '2014/2015'
            AND m.home_goal != m.away_goal THEN 0
        end
    ) AS ties_2014_2015
FROM
    country AS c
    LEFT JOIN matches AS m ON c.id = m.country_id
GROUP BY
    country;

SELECT
    c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
    Round(
        AVG(
            CASE
                WHEN m.season = '2013/2014'
                AND m.home_goal = m.away_goal THEN 1
                WHEN m.season = '2013/2014'
                AND m.home_goal != m.away_goal THEN 0
            END
        ),
        2
    ) AS pct_ties_2013_2014,
    ROUND(
        AVG(
            CASE
                WHEN m.season = '2014/2015'
                AND m.home_goal = m.away_goal THEN 1
                WHEN m.season = '2014/2015'
                AND m.home_goal != m.away_goal THEN 0
            END
        ),
        2
    ) AS pct_ties_2014_2015
FROM
    country AS c
    LEFT JOIN matches AS m ON c.id = m.country_id
GROUP BY
    country;

#####################
--- Subqueries in WHERE-- 
#####################
SELECT
    -- Select the date, home goals, and away goals scored
    date,
    home_goal,
    away_goal
FROM
    matches_2013_2014 -- Filter for matches where total goals exceeds 3x the average
WHERE
    (home_goal + away_goal) > (
        SELECT
            3 * AVG(home_goal + away_goal)
        FROM
            matches_2013_2014
    );

SELECT
    -- Select the team long and short names
    team_long_name,
    team_short_name
FROM
    team -- Exclude all values from the subquery
WHERE
    team_api_id NOT IN (
        SELECT
            DISTINCT hometeam_id
        FROM
            match
    );

SELECT
    -- Select the team long and short names
    team_long_name,
    team_short_name
FROM
    team -- Filter for teams with 8 or more home goals
WHERE
    team_api_id IN (
        SELECT
            hometeam_id
        FROM
            match
        WHERE
            home_goal >= 8
    );

#####################
--- Subqueries in FROM-- 
#####################
SELECT
    -- Select country, date, home, and away goals from the subquery
    subq.country,
    date,
    home_goal,
    away_goal
FROM
    -- Select country name, date, home_goal, away_goal, and total goals in the subquery
    (
        SELECT
            name AS country,
            m.date,
            m.home_goal,
            m.away_goal,
            (m.home_goal + m.away_goal) AS total_goals
        FROM
            match AS m
            LEFT JOIN country AS c ON m.country_id = c.id
    ) AS subq -- Filter by total goals scored in the main query
WHERE
    total_goals >= 10;

#####################
--- Subqueries in SELECT-- 
#####################
--- NEED TO RETURN SINGLE VALUE 
---Correct placement of your data's filters in both the main query and the subquery
SELECT
    l.name AS league,
    -- Select and round the league's total goals
    ROUND(avg(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (
        SELECT
            ROUND(AVG(home_goal + away_goal), 2)
        FROM
            match
        WHERE
            season = '2013/2014'
    ) AS overall_avg
FROM
    league AS l
    LEFT JOIN match AS m ON l.country_id = m.country_id -- Filter for the 2013/2014 season
WHERE
    m.season = '2013/2014'
GROUP BY
    1;

SELECT
    -- Select the league name and average goals scored
    l.name AS league,
    ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Subtract the overall average from the league average
    ROUND(
        AVG(m.home_goal + m.away_goal) - (
            SELECT
                AVG(home_goal + away_goal)
            FROM
                match
            WHERE
                season = '2013/2014'
        ),
        2
    ) AS diff
FROM
    league AS l
    LEFT JOIN match AS m ON l.country_id = m.country_id -- Only include 2013/2014 results
WHERE
    season = '2013/2014'
GROUP BY
    l.name;

#####################
--- Subqueries in SELECT FROM WHERE-- 
#####################
--- For text (--, /* */)  
SELECT
    -- Select the stage and average goals for each stage
    m.stage,
    ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND(
        (
            SELECT
                AVG(home_goal + away_goal)
            FROM
                match
            WHERE
                season = '2012/2013'
        ),
        2
    ) AS overall
FROM
    match AS m -- Filter for the 2012/2013 season
WHERE
    season = '2012/2013' -- Group by stage
GROUP BY
    1;

SELECT
    -- Select the stage and average goals from the subquery
    stage,
    ROUND(avg_goals, 2) AS avg_goals
FROM
    -- Select the stage and average goals in 2012/2013
    (
        SELECT
            stage,
            AVG(home_goal + away_goal) AS avg_goals
        FROM
            match
        WHERE
            season = '2012/2013'
        GROUP BY
            stage
    ) AS s
WHERE
    -- Filter the main query using the subquery
    s.avg_goals >= (
        SELECT
            AVG(home_goal + away_goal)
        FROM
            match
        WHERE
            season = '2012/2013'
    );

SELECT
    -- Select the stage and average goals from s
    stage,
    ROUND(avg_goals, 2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (
        SELECT
            AVG(home_goal + away_goal)
        FROM
            match
        WHERE
            season = '2012/2013'
    ) AS overall_avg
FROM
    -- Select the stage and average goals in 2012/2013 from match
    (
        SELECT
            stage,
            AVG(home_goal + away_goal) AS avg_goals
        FROM
            match
        WHERE
            season = '2012/2013'
        GROUP BY
            stage
    ) AS s
WHERE
    -- Filter the main query using the subquery
    s.avg_goals >= (
        SELECT
            AVG(home_goal + away_goal)
        FROM
            match
        WHERE
            season = '2012/2013'
    );

#####################
--- Correlated Subquery -- 
#####################
SELECT
    -- Select country ID, date, home, and away goals from match
    main.country_id,
    date,
    main.home_goal,
    main.away_goal
FROM
    match AS main
WHERE
    -- Filter the main query by the subquery
    (home_goal + away_goal) > (
        SELECT
            AVG((sub.home_goal + sub.away_goal) * 3)
        FROM
            match AS sub -- Join the main query to the subquery in WHERE
        WHERE
            main.country_id = sub.country_id
    );

SELECT
    -- Select country ID, date, home, and away goals from match
    main.country_id,
    date,
    main.home_goal,
    main.away_goal
FROM
    match AS main
WHERE
    -- Filter for matches with the highest number of goals scored
    (home_goal + away_goal) >= (
        SELECT
            AVG(sub.home_goal + sub.away_goal)
        FROM
            match AS sub
        WHERE
            main.country_id = sub.country_id
            AND main.season = sub.season
    );

#####################
--- NESTED QUERY -- 
#####################
SELECT
    -- Select the season and max goals scored in a match
    season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
    (
        SELECT
            MAX(home_goal + away_goal)
        FROM
            match
    ) AS overall_max_goals,
    -- Select the max number of goals scored in any match in July
    (
        SELECT
            MAX(home_goal + away_goal)
        FROM
            match
        WHERE
            id IN (
                SELECT
                    id
                FROM
                    match
                WHERE
                    EXTRACT(
                        MONTH
                        FROM
                            date
                    ) = 07
            )
    ) AS july_max_goals
FROM
    match
GROUP BY
    season;

SELECT
    c.name AS country,
    -- Calculate the average matches per season
    AVG(outer_s.matches) AS avg_seasonal_high_scores
FROM
    country AS c -- Left join outer_s to country
    LEFT JOIN (
        SELECT
            country_id,
            season,
            COUNT(id) AS matches
        FROM
            (
                SELECT
                    country_id,
                    season,
                    id
                FROM
                    match
                WHERE
                    home_goal >= 5
                    OR away_goal >= 5
            ) AS inner_s -- Close parentheses and alias the subquery
        GROUP BY
            country_id,
            season
    ) AS outer_s ON c.id = outer_s.country_id
GROUP BY
    country;

#####################
--- COMMON TABLE EXPRESSIONS -- 
#####################
-- Set up your CTE
WITH match_list AS (
    SELECT
        country_id,
        id
    FROM
        match
    WHERE
        (home_goal + away_goal) >= 10
) -- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM
    league AS l -- Join the CTE to the league table
    LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY
    l.name;

-- Set up your CTE
WITH match_list AS (
    -- Select the league, date, home, and away goals
    SELECT
        name AS league,
        date,
        home_goal,
        m.away_goal,
        (m.home_goal + m.away_goal) AS total_goals
    FROM
        match AS m
        LEFT JOIN league as l ON m.country_id = l.id
) -- Select the league, date, home, and away goals from the CTE
SELECT
    league,
    date,
    home_goal,
    away_goal
FROM
    match_list -- Filter by total goals
WHERE
    total_goals >= 10;

-- Set up your CTE
WITH match_list AS (
    SELECT
        country_id,
        (home_goal + away_goal) AS goals
    FROM
        match -- Create a list of match IDs to filter data in the CTE
    WHERE
        id IN (
            SELECT
                id
            FROM
                match
            WHERE
                season = '2013/2014'
                AND EXTRACT(
                    MONTH
                    FROM
                        date
                ) = 08
        )
) -- Select the league name and average of goals in the CTE
SELECT
    name AS league,
    AVG(goals)
FROM
    league AS l -- Join the CTE onto the league table
    LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY
    l.name;

#####################
--- Deciding on techniques to use -- 
#####################
-- Joins combine 2+ tables simple operations/aggregations 
-- correlated subqueries -- match subqueries & tables, avoid limits of joins, high processing time, 
-- multiple/nested subqueries -- multi-step transformation, improve accuracy and reproducibility 
-- CTE -- organize subqueries sequentially, can reference other CTEs 
-- what to use? depends on your database/question, use and reuse queries, generate clear and accurate results 
SELECT
    m.date,
    -- Get the home and away team names
    hometeam,
    awayteam,
    m.home_goal,
    m.away_goal
FROM
    match AS m -- Join the home subquery to the match table
    LEFT JOIN (
        SELECT
            match.id,
            team.team_long_name AS hometeam
        FROM
            match
            LEFT JOIN team ON match.hometeam_id = team.team_api_id
    ) AS home ON home.id = m.id -- Join the away subquery to the match table
    LEFT JOIN (
        SELECT
            match.id,
            team.team_long_name AS awayteam
        FROM
            match
            LEFT JOIN team -- Get the away team ID in the subquery
            ON match.awayteam_id = team.team_api_id
    ) AS away ON away.id = m.id;

WITH home AS (
    SELECT
        m.id,
        m.date,
        t.team_long_name AS hometeam,
        m.home_goal
    FROM
        match AS m
        LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id
),
-- Declare and set up the away CTE
away AS (
    SELECT
        m.id,
        m.date,
        t.team_long_name AS awayteam,
        m.away_goal
    FROM
        match AS m
        LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id
) -- Select date, home_goal, and away_goal
SELECT
    home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal -- Join away and home on the id column
FROM
    home
    INNER JOIN away ON away.id = home.id;

#####################
--- WINDOW FUNCTION  -- 
#####################
-- RANK() 
SELECT
    -- Select the league name and average goals scored
    name AS league,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    -- Rank leagues in descending order by average goals
    RANK () OVER(
        ORDER BY
            AVG(m.home_goal + m.away_goal) DESC
    ) AS league_rank
FROM
    league AS l
    LEFT JOIN match AS m ON l.id = m.country_id
WHERE
    m.season = '2011/2012'
GROUP BY
    l.name -- Order the query by the rank you created
ORDER BY
    league_rank;

--- OVER and PARTITION BY 
SELECT
    date,
    season,
    home_goal,
    away_goal,
    CASE
        WHEN hometeam_id = 8673 THEN 'home'
        ELSE 'away'
    END AS warsaw_location,
    -- Calculate the average goals scored partitioned by season
    AVG(home_goal) OVER(PARTITION BY season) AS season_homeavg,
    AVG(away_goal) OVER(PARTITION BY season) AS season_awayavg
FROM
    match -- Filter the data set for Legia Warszawa matches only
WHERE
    hometeam_id = 8673
    OR awayteam_id = 8673
ORDER BY
    (home_goal + away_goal) DESC;

SELECT
    date,
    season,
    home_goal,
    away_goal,
    CASE
        WHEN hometeam_id = 8673 THEN 'home'
        ELSE 'away'
    END AS warsaw_location,
    -- Calculate average goals partitioned by season and month
    AVG(home_goal) OVER(
        PARTITION BY season,
        EXTRACT(
            MONTH
            FROM
                date
        )
    ) AS season_mo_home,
    AVG(away_goal) OVER(
        PARTITION BY season,
        EXTRACT(
            MONTH
            FROM
                date
        )
    ) AS season_mo_away
FROM
    match
WHERE
    hometeam_id = 8673
    OR awayteam_id = 8673
ORDER BY
    (home_goal + away_goal) DESC;

--- SLIDING WINDOWS -- calculation running total, running average, running count 
-- ROWS BETWEEN <start> AND <finish> : ## PRECEDING, FOLLOWING (rows before or after the current row that you want to include in calculation)
-- UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING (every rows since the beginning or the end data set in your calculation)
-- CURRENT ROW (stop calculation at the current row )
SELECT
    date,
    home_goal,
    away_goal,
    -- Create a running total and running average of home goals
    SUM(home_goal) OVER(
        ORDER BY
            date ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) AS running_total,
    AVG(home_goal) OVER(
        ORDER BY
            date ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) AS running_avg
FROM
    match
WHERE
    hometeam_id = 9908
    AND season = '2011/2012';

#####################
--- BRINGING IT ALL TOGETHERS  -- 
#####################

SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		WHEN m.home_goal < m.away_goal THEN 'MU Loss'
        ELSE 'Tie' END AS outcome
FROM match AS m
-- Left join team on the home team ID and team API id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the home team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';

SELECT 
	m.id, 
    t.team_long_name,
    -- Identify matches as home/away wins or ties
	CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		WHEN m.home_goal < m.away_goal THEN 'MU Win'
        ELSE 'Tie' END AS outcome
-- Join team table to the match table
FROM match AS m
LEFT JOIN team AS t 
ON m.awayteam_id = t.team_api_id
WHERE 
	-- Filter for 2014/2015 and Manchester United as the away team
	season = '2014/2015'
	AND t.team_long_name = 'Manchester United';


-- Set up the home team CTE
WITH home AS  (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS  (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select team names, the date and goals
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal,
    m.away_goal
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND (home.team_long_name = 'Manchester United' 
           OR away.team_long_name = 'Manchester United');

-- Set up the home team CTE
WITH home AS  (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		   WHEN m.home_goal < m.away_goal THEN 'MU Win' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select columns and and rank the matches by goal difference
SELECT DISTINCT
    date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal, m.away_goal,
    RANK() OVER(ORDER BY ABS(home_goal - away_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
      OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));