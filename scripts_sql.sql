-- 1 Retrieve specific data using SELECT statements with variousconditions.
--1.1 books with ratings
SELECT title, "ratingsCount"
FROM books_data 
WHERE "ratingsCount" IS NOT NULL;

--1.2 Which is the maximun number of ratingsCount
SELECT title, "ratingsCount"
FROM books_data
WHERE "ratingsCount" = (SELECT MAX("ratingsCount") AS max_ratings
FROM books_data);

--1.3 top 10 -grafica
SELECT title, "ratingsCount"
FROM books_data
WHERE "ratingsCount" IS NOT NULL
ORDER BY "ratingsCount" DESC
LIMIT 10;
--1.4 Which publisher has more books with more ratings 
SELECT publisher, COUNT(*) AS books_with_ratings, SUM ("ratingsCount") AS total_ratings
FROM books_data
WHERE "ratingsCount" IS NOT NULL
GROUP BY publisher
ORDER BY total_ratings DESC
LIMIT 100;

--2. Perform JOIN operations to combine data from multiple tables.
SELECT b1.title AS book1, b2.title AS book2, b1.publisher
FROM books_data b1
JOIN books_data b2
	ON b1.publisher = b2.publisher
	AND b1.title <> b2.title
LIMIT 50;
--2.2  Perform JOIN operations to combine data from multiple tables.
SELECT 
	b1.publisher,
	b1.title AS book_1,
	b2.title AS book_2,
	b1."ratingsCount" AS ratings_1,
	b2."ratingsCount" AS ratings_2
FROM books_data b1
JOIN books_data b2
ON b1.publisher = b2.publisher
AND b1.title <> b2.title
WHERE b1."ratingsCount" > 100 AND b2."ratingsCount" > 100
ORDER BY b1.publisher
LIMIT 50;
--3 Use GROUP BY and aggregation functions (SUM, AVG, COUNT) to analyze data.
-- publisher with more books
SELECT publisher, COUNT (*) AS total_books
FROM books_data
WHERE "publisher" IS NOT NULL
GROUP BY publisher
ORDER BY total_books DESC
LIMIT 50;
-- Average of ratings per publisher -  GRAFICA 
SELECT publisher, AVG("ratingsCount") AS avg_ratings
FROM books_data
WHERE "ratingsCount" IS NOT NULL
GROUP BY publisher
ORDER BY avg_ratings DESC
LIMIT 10;

-- ratings per category - grafica
SELECT categories, SUM ("ratingsCount") AS total_ratings
FROM books_data
WHERE "ratingsCount" IS NOT NULL
GROUP BY categories
ORDER BY total_ratings DESC
LIMIT 10;


-- Implement subqueries and nested queries. Grafica
-- How many books were published and rated per year and per category (help us to detect tendecies)
SELECT 
	year,
	categories,
	COUNT(*) AS books_count
	FROM (
		SELECT *, EXTRACT (YEAR FROM "publishedDate") AS year
		FROM books_data
		WHERE "ratingsCount" IS NOT NULL AND "categories" IS NOT NULL
	) AS sub 
	GROUP BY year, categories
	ORDER BY year, books_count DESC;
	
