USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- 1) Total number of rows in table movie
SELECT COUNT(*) FROM movie;

-- 2) Total number of rows in table genre
SELECT COUNT(*) FROM genre;

-- 3) Total number of rows in table ratings
SELECT COUNT(*) FROM ratings;

-- 4) Total number of rows in table director_mapping
SELECT COUNT(*) FROM director_mapping;

-- 5) Total number of rows in table names
SELECT COUNT(*) FROM names;

-- 6) Total number of rows in table role_mapping
SELECT COUNT(*) FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT sum(CASE when id IS NULL 
           then 1 else 0 
           END) AS id_null_count,
       sum(CASE when title IS NULL
           then 1 else 0
           END) AS title_null_count,
       sum(CASE when year IS NULL
		   then 1 else 0
		   END) AS year_null_count,
	   sum(CASE when date_published IS NULL 
           then 1 else 0
           END) AS date_publisted_null_count,
		sum(CASE when duration IS NULL 
           then 1 else 0
           END) AS duration_null_count,
        sum(CASE when country IS NULL 
           then 1 else 0
           END) AS country_null_count,   
        sum(CASE when worlwide_gross_income IS NULL 
           then 1 else 0
           END) AS worlwide_gross_income_null_count,
        sum(CASE when languages IS NULL 
           then 1 else 0
           END) AS languages_null_count,   
		sum(CASE when production_company IS NULL 
           then 1 else 0
           END) AS production_company_null_count
from movie;

-- Four columns in movie table has null values, worlwide_gross_income column gas highest number of null values

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT year,
    count(title) AS Number_of_movies
FROM movie
group by year;    

SELECT month(date_published) AS month_number,
      count(month(date_published)) AS NUMBER_OF_MOVIES
FROM movie
group by month_number
order by month_number
;      

-- From year 2017 to 2019 number of movies produced were decreasing
-- month-wise highest number of movies were produced in march

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT count(DISTINCT id) AS number_of_movies, year
from movie
Where (country LIKE '%INDIA%' OR country LIKE '%USA%')
AND year = 2019;

-- USA and INDIA prodcued 1059 movies in the year 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre,
      count(m.id) AS number_of_movies
FROM movie AS m
INNER JOIN genre AS g
where m.id = g.movie_id
group by genre
order by number_of_movies DESC 
LIMIT 1;     

-- 'DRAMA' genre had the highest number of movies produced among all genre

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH movies_with_one_genre AS 
                     (SELECT movie_id
                     from genre
                     group by movie_id
                     having count(DISTINCT genre) = 1)
SELECT count(*) AS movies_with_one_genre
from movies_with_one_genre;
     
-- There are 3289 movies has only one genre associated with them

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
    ROUND(Avg(duration),2) AS avg_duration
from movie AS m
inner join genre AS g
where m.id = g.movie_id
group by genre
order by avg_duration DESC;    

-- 'Action' genre movies has the average duration of 112.88 minutes
-- 'Horror' genre movies has the average duration of 92.72 minutes
-- 'Drama' genre movies has the average duration of 106.77 minutes('Drama' genre having highest number of movies in year 2019)

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH genre_summary AS
     (SELECT genre,
     count(movie_id) AS movie_count,
     RANK() OVER(order by count(movie_id) DESC) AS genre_rank
	 from genre
	 group by genre)
SELECT * from genre_summary
where genre = 'THRILLER'
;

-- ‘Thriller’ genre of movies has 3rd rank among all the genres in terms of number of movies produced

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
from ratings;    
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT title, avg_rating,
    RANK() OVER(order by avg_rating DESC) AS movie_rank
from ratings AS r
inner join movie AS m
ON m.id = r.movie_id limit 10;
      
-- Kirket', 'Love in Kilnerry' and 'Gini Hedila Kathe' are the top three movies based on their average ratings, their average ratings are 10, 10 and 9.8 respectively

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating,
   count(movie_id) as movie_count
FROM ratings
group by median_rating
order by movie_count DESC;   

-- Large number(2257) of movies got median rating 7

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_company_hit_movies_summary AS
      (SELECT production_company,
      count(movie_id) AS movie_count,
      RANK() OVER(order by count(movie_id) DESC) AS prod_company_rank
  from ratings AS r
  inner join movie AS m
  ON m.id = r.movie_id
  WHERE avg_rating > 8 AND Production_company IS NOT NULL
  GROUP BY PRODUCTION_COMPANY)

SELECT * from production_company_hit_movies_summary
where prod_company_rank = 1;

-- Dream Warrior Pictures or National Theatre Live or both having most number of hit movies with average rating > 8

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre,
    count(id) as movie_count
    from movie as m
    inner join genre as g
       ON m.id = g.movie_id
	inner join ratings as r
       ON m.id = r.movie_id
where year =2017 AND month(date_published) = 3 AND country like '%USA%' AND total_votes > 1000
group by genre
order by movie_count DESC;

-- 24 'Drama' genre Movies released in march 2017 in USA with more than 1000 votes

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
    from movie as m
    INNER JOIN genre as g
       ON m.id = g.movie_id
    INNER JOIN ratings as r
       ON M.ID = R.MOVIE_ID
 WHERE title like 'The%' AND avg_rating > 8
group by title
order by avg_rating DESC;  



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT median_rating,
    count(*) AS movie_count
  from movie as m
  INNER JOIN ratings as r
     ON m.id = r.movie_id
  where date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating = 8
  group by median_rating
  order by movie_count DESC;

-- what is the right syntax to use particular date? how to check it in manual?



-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, sum(total_votes) AS TOTAL_VOTES
   FROM movie as m
   INNER JOIN ratings as r
      ON m.id = r.movie_id
	WHERE country = 'GERMANY' OR country = 'ITALY'
group by country
order by TOTAL_VOTES DESC;

-- SO THE TOTAL VOTES FOR GERMAN MOVIES IS MORE THAN ITALIAN MOVIES HENCE ANSWER IS 'YES'

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
 
SELECT count(*) AS name_nulls
from names
where name IS NULL;

SELECT count(*) AS height_nulls
from names
where height IS NULL;

SELECT count(*) AS date_of_birth_nulls
from names
where date_of_birth IS NULL;

SELECT count(*) AS known_for_movies_nulls
from names 
where known_for_movies IS NULL;

-- There are no null values in column 'name', other columns have null values.

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genre_ranks AS
(
SELECT genre, count(id) AS movie_count,
    RANK() OVER(order by count(id) DESC) AS genre_rank
from movie AS M
INNER JOIN genre AS g
  ON m.id = g.movie_id
INNER JOIN ratings as r
  ON m.id = r.movie_id
WHERE avg_rating > 8
group by genre limit 3
) 

SELECT name AS director_name, count(movie_id) AS movie_count
   from director_mapping AS d
   INNER JOIN genre 
      using (movie_id)
   INNER JOIN names as n   
      ON n.id = d.name_id
   INNER JOIN ratings 
      using (movie_id)
  INNER JOIN top_3_genre_ranks
      using (genre)
 
where avg_rating > 8
group by name
order by movie_count DESC limit 3;

-- James Mangold has directed most number of top rated movies in top three genres

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name AS actor_name, count(movie_id) AS movie_count
   from role_mapping AS rm
INNER JOIN movie as m
   ON m.id = rm.movie_id
INNER JOIN names as n 
   ON n.id = rm.name_id
INNER JOIN ratings 
   USING (movie_id)
where median_rating >= 8 AND category = 'Actor'
group by actor_name
order by movie_count DESC limit 2;

-- 'Mammootty' and 'Mohanlal' are the top two actors whose movies has median rating >= 8

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
      sum(total_votes) AS TOTAL_VOTES_COUNT,
      RANK() OVER(order by sum(total_votes) DESC) as PRODUCTION_COMPANY_RANK
from movie as m
INNER JOIN ratings as r
    ON m.id = r.movie_id
group by production_company limit 3;

-- Marvel Studios is the top production house bases on the number of votes followed by Twentieth Century Fox and Warner Bros 

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ACTORS_SUMMARY AS
(
SELECT name as actors_name, count(r.movie_id) as movie_count, total_votes,
	ROUND(sum(total_votes*avg_rating)/sum(total_votes), 2) as ACTOR_AVERAGE_RATING
from movie as m
INNER JOIN role_mapping as rm
   ON m.id = rm.movie_id
INNER JOIN ratings AS r
   ON m.id = r.movie_id
INNER JOIN names as n
   ON rm.name_id = N.ID
where category = 'Actor' AND Country = 'India'
group by name
HAVING movie_count >=5
)
SELECT *, RANK() OVER(order by ACTOR_AVERAGE_RATING DESC) AS ACTOR_RANK 
FROM ACTORS_SUMMARY;


-- Top actor is 'Vijay Sethupathi' based on the average rating

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ACTRESSES_SUMMARY AS
(
SELECT name as actress_name, count(r.movie_id) as movie_count, total_votes,
	ROUND(sum(total_votes*avg_rating)/sum(total_votes), 2) as ACTRESSES_AVERAGE_RATING
from movie as m
INNER JOIN role_mapping as rm
   ON m.id = rm.movie_id
INNER JOIN ratings AS r
   ON m.id = r.movie_id
INNER JOIN names as n
   ON rm.name_id = N.ID
where category = 'Actress' AND Country = 'India' AND languages like '%HINDI%'
group by name
HAVING movie_count >=3
)
SELECT *, RANK() OVER(order by ACTRESSES_AVERAGE_RATING DESC) AS ACTRESS_RANK 
FROM ACTRESSES_SUMMARY
LIMIT 5;

-- 'Taapsee Pannu' is the top actress with average rating of 7.74

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH THRILLER_MOVIES
AS
(
SELECT DISTINCT title, avg_rating
   from movie as m
INNER JOIN genre as g
    ON m.id = g.movie_id
INNER JOIN ratings as r
    ON m.id = r.movie_id
WHERE genre = 'THRILLER'
)
SELECT *, CASE
          WHEN avg_rating > 8 THEN 'SUPERHIT MOVIES'
		   WHEN avg_rating BETWEEN 7 AND 8 THEN 'HIT MOVIES'
           WHEN avg_rating BETWEEN 5 AND 7 THEN 'ONE-TIME-WATCH MOVIES'
           ELSE 'FLOP MOVIES'
           END 
           AS AVERAGE_RATING_CATEGORY
FROM THRILLER_MOVIES;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT genre,
  ROUND(AVG(DURATION),2) AS avg_duration,
  SUM(ROUND(AVG(DURATION),2)) OVER(order by genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
  AVG(ROUND(AVG(DURATION),2)) OVER(order by genre ROWS 10 PRECEDING) as moving_avg_duration
FROM movie as m
INNER JOIN GENRE AS G
    ON M.ID = G.MOVIE_ID
GROUP BY GENRE 
ORDER BY GENRE;



-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


-- Cannot able to query the code for this question







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH PRODUCTION_COMPANY_SUMMARY AS
(
SELECT production_company, count(*) as movie_count
     from movie as m
     INNER JOIN ratings as r
         ON m.id = r.movie_id
     WHERE median_rating >= 8 AND production_company IS not NULL
			AND POSITION(',' IN languages)> 0
group by production_company
order by movie_id DESC
)
SELECT *, RANK() OVER(order by movie_count DESC) as prod_company_rank
from PRODUCTION_COMPANY_SUMMARY
LIMIT 2;

-- 'Star Cinema' and 'Twentieth Century Fox' are top two production companies which have produced highest number of multilingual movies with with median rating >=8

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH ACTRESSES_SUMMARY
AS
(
SELECT name as Actress_name, SUM(total_votes) AS TOTAL_VOTES, COUNT(r.movie_id) AS MOVIE_COUNT,
       ROUND(SUM(avg_rating*total_votes)/SUM(total_votes) , 2) AS ACTRESS_AVG_RATING
   FROM movie as m
   INNER JOIN role_mapping as rm
      ON m.id = rm.movie_id
   INNER JOIN genre as g 
      ON m.id = g.movie_id
   INNER JOIN ratings as r
	  ON m.id = r.movie_id
   INNER JOIN names as n
      ON rm.name_id = n.id
WHERE avg_rating > 8 AND genre = 'DRAMA' AND category = 'ACTRESS'
GROUP BY name
)
SELECT *, RANK() OVER(order by movie_count DESC) AS actress_rank
from ACTRESSES_SUMMARY
LIMIT 3;

-- 'Parvathy Thiruvothu', 'Susan Brown', 'Amanda Lawrence' are the top three actresses bases on the number of superhit movies in drama genre

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


-- Cannot able to query the code for this question




