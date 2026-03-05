-- Netflix Project
DROP TABLE IF EXISTS Netflix;
CREATE TABLE Netflix
(
Show_id VARCHAR (6) ,
type VARCHAR(10) ,
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR (1000),
country VARCHAR (150),
date_added VARCHAR (50) ,
release_year INT,
rating VARCHAR (10),
duration VARCHAR (15) ,
listed_in VARCHAR (100),
description VARCHAR (250)

);

SELECT * FROM Netflix;


SELECT
     COUNT(*) as total_contect
FROM Netflix;


SELECT
     DISTINCT TYPE
FROM Netflix;

-- Business Problems

-- 1. Count the number of Movies vs TV Shows 

SELECT type, COUNT(*) AS Total_Content
FROM Netflix
GROUP by TYPE;


-- 2. Find the most common rating for movies and TV shows

SELECT 
     type,
	 rating,
	 
SELECT 
      type,
	  rating,
	  ranking
FROM
(
SELECT
      type,
	  rating,
	  COUNT(*),
	  RANK()OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC ) as ranking
FROM Netflix
GROUP BY 1,2 ) AS T1
WHERE ranking = 1
;

-- 3. List all movies released in a specific year(2020)

SELECT *
FROM Netflix
WHERE 
     type = 'Movie' 
	 AND 
	 release_year = 2020
;


--4. Find the top 5 countries with the most content on Netflix

SELECT UNNEST(STRING_TO_ARRAY(country, ',')) as new_country, 
       COUNT(show_id) AS total_content 
FROM Netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;

SELECT 
     UNNEST(STRING_TO_ARRAY(country, ',')) as new_country
FROM Netflix


--5. Identify the longest movie

SELECT 
      CAST(SPLIT_PART(duration, ' ', 1)AS INT) as new_duration
FROM Netflix
WHERE duration LIKE '%min%'
;


SELECT 
      type,
      CAST(SPLIT_PART(duration, ' ', 1)AS INT) as new_duration
FROM Netflix
WHERE type = 'Movie' 
             AND 
			 duration LIKE '%min%'
ORDER BY new_duration DESC
LIMIT 1
;


--6. Find content added the last 5 years

SELECT 
     *,
	 TO_DATE(date_added, 'Month DD, YYYY')       
FROM Netflix
;

SELECT 
     *      
FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY')>= CURRENT_DATE - INTERVAL '5 years'
;


SELECT CURRENT_DATE - INTERVAL '5 years'


--7. Find all the movies/TV shows by direct ' Rajiv Chilaka'

SELECT 
     type, 
	 director 
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%'
;


-- 8. List all TV shows with more than 5 seasons

SELECT 
      *,
      SPLIT_PART(duration,' ', 1) AS new_seasons
FROM Netflix


SELECT *
FROM Netflix
WHERE 
     type = 'TV Show'
	 AND 
	 SPLIT_PART(duration,' ', 1) :: numeric > 5
;


--9. Count the number of content items in each genre

SELECT 
	 UNNEST(STRING_TO_ARRAY(listed_in, ',')) as new_listed_in,
	 COUNT(show_id) as total_content 
FROM Netflix
GROUP BY 1
;


-- 10. Find each year and the average number of content release by United States on Netflix, Return top 5 years with higest average content release

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
	  COUNT(*),
	  COUNT(*)::numeric/(
                         SELECT COUNT(*)
						 FROM Netflix
						 WHERE country = 'United States') ::numeric *100 AS avg_content_per_year
FROM Netflix
WHERE country = 'United States' 
      AND 
      date_added  IS NOT NULL
GROUP BY 1
ORDER BY avg_content_per_year DESC
LIMIT 5
;


-- 11.List all movies that are documentries

SELECT *
FROM Netflix
WHERE  listed_in ILIKE '%documentaries%' AND type = 'Movie'
;

--12. Find all content wthout a director

SELECT 
     type,
	 director
FROM Netflix
WHERE 
    director IS NULL
;


--13. Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT 
     type,
	 casts,
	 release_year
FROM Netflix
WHERE release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
	  AND 
	  casts ILIKE '%Salman Khan%'
	  AND
	  type = 'Movie'
;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in United States.

SELECT 
      'Movie' AS type,
      UNNEST(STRING_TO_ARRAY(casts,' ,')) as actor,	
	  COUNT(show_id) AS total_content
FROM Netflix
WHERE type = 'Movie'
GROUP BY 2
ORDER BY total_content
LIMIT 10
;


-- 15. Categorize the content based on the presence of the keywords 'kill' and 'violance' in 
the discripion field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


WITH new_table
AS
(
SELECT 
     * ,
	 CASE 
	     WHEN description ILIKE '%kill%' OR
	     description ILIKE '%violance%' THEN 'Bad_Content'
	     ELSE 'Good_Content'
	 END category
FROM Netflix
)

SELECT
      category,
	  COUNT(*) AS total_count
FROM new_table
GROUP BY 1



WHERE 
     description ILIKE '%kill%' 
	 OR
	 description ILIKE '%violance%' 
;















	 








