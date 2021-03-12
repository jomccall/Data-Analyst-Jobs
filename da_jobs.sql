/* #1. How many total rows?*/
SELECT COUNT(*)
FROM da_jobs;

/* #2. Look at first 10 rows.
What company associated with 10th post? (ExxonMobil)*/
SELECT *
FROM da_jobs
LIMIT 10;

/* #3. How many postings are in TN? 21
How many in either TN or KY? 27*/
SELECT COUNT(location) AS "TN_Postings"
FROM da_jobs
WHERE location = 'TN';

SELECT COUNT(location)
FROM da_jobs AS "TN_KY_Postings"
WHERE location = 'TN'
OR location = 'KY';

-- OR
SELECT COUNT(location)
FROM da_jobs AS "TN_KY_Postings"
WHERE location IN ('TN', 'KY');

/* #4. How many postings in TN have a star rating above 4?*/
SELECT COUNT(*) AS "TN_O4"
FROM da_jobs
WHERE location = 'TN'
AND star_rating >4;

/* #5. How many postings have rev count btw 500 and 1000? 151*/
SELECT COUNT(title) 
FROM da_jobs
WHERE review_count BETWEEN 500 AND 1000;

/* #6. Show average star rating by state. Call this "avg_rating".*/
SELECT location AS "state", AVG(star_rating) AS "avg_rating"
FROM da_jobs
GROUP BY location;

-- You can also round:
SELECT location AS state, ROUND(AVG(star_rating),3) AS avg_rating
FROM da_jobs
GROUP BY location
ORDER BY avg_rating DESC;

/* #7. Select and count unique job titles. (add or remove *COUNT* to show or count) 881*/
SELECT COUNT(DISTINCT title)
FROM da_jobs;

/* #8. How many unique job titles for CA companies? 230*/
SELECT COUNT(DISTINCT title) AS "CA_UniqueTitles"
FROM da_jobs
WHERE location = 'CA';

/* #9. Find name of company and avg. star rating for all companies
with more than 5,000 reviews from all locations. How many are there? */
SELECT DISTINCT company, AVG(star_rating) AS "Company_AVGRating"
FROM da_jobs
WHERE review_count > 5000
AND COMPANY IS NOT NULL
GROUP BY company
ORDER BY AVG(star_rating);

-- check a match
SELECT COUNT(DISTINCT company)
FROM da_jobs
WHERE review_count > 5000;

/* #10. Order the query from #9 from highest to lowest avg star rating.
Which company has the highest rating?: American Express through Unilever have same ratings,
just listed in alphabetical order.
*/
SELECT DISTINCT company, round(AVG(star_rating),8) AS "Company_AVGRating"
FROM da_jobs
WHERE review_count > 5000
AND company IS NOT NULL
AND star_rating IS NOT NULL
GROUP BY company
ORDER BY round(AVG(star_rating),8) DESC;

/* #11. Find all job titles containing word "Analyst" how many different titles are there?*/
SELECT COUNT(DISTINCT title)
FROM da_jobs
WHERE title ILIKE '%Analyst%';
-- 774

SELECT COUNT(DISTINCT title)
FROM da_jobs
WHERE title ILIKE '%Analytics';
-- 94

SELECT COUNT(DISTINCT title)
FROM da_jobs
WHERE title ILIKE '%Analytics'
OR title ILIKE '%Analyst%';
-- 827

SELECT COUNT(DISTINCT title)
FROM da_jobs
WHERE title ILIKE '%Analytics'
AND title ILIKE '%Analyst%';
-- 41

/* #12. How many job titles do not contain either the word "Analyst" or the word "Analytics"?
What word do these positions have in common? */
SELECT DISTINCT title
FROM da_jobs
WHERE title NOT ILIKE '%Analyst%'
AND title NOT ILIKE '%Analytics%';
-- There are four, most have tableau in the title/ are about viz

-- BONUS: Which jobs requiring SQL are hard to fill
-- Find # of jobs by industry that require SQL and have been
-- posted more than 3 weeks.

SELECT DISTINCT(domain) AS industry,
	COUNT(title) AS HTFjobs,
	MAX(skill) as skill,
	(AVG(days_since_posting)/7) AS weeks
FROM da_jobs
WHERE domain IS NOT NULL
AND skill ILIKE '%SQL%'
GROUP BY domain
HAVING (AVG(days_since_posting)/7) > 3
ORDER BY HTFjobs DESC;