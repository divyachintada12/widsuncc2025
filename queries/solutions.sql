--✔ Finds the most interacted-with articles in a category
SELECT title, author, total_engagements,category_name
FROM medium_articles_authors.gold.medium_articles_gold
where category_name='Web Development'
ORDER BY total_engagements DESC
LIMIT 1;


--Finds author with most articles
SELECT author_name, total_articles
FROM medium_articles_authors.gold.medium_author_performance
ORDER BY total_articles DESC
LIMIT 1;

--Which topics/categories are gaining popularity in the month of 2024 March? Hint : DATE_TRUNC('month', publish_date)='2024-03-01'
--✔ Identifies rising trends in content categories.
SELECT 
    category_name, 
    DATE_TRUNC('month', publish_date) AS month, 
    AVG(recommendations) AS avg_recommendations
FROM medium_articles_gold
where DATE_TRUNC('month', publish_date)='2024-03-01'
GROUP BY category_name, month
ORDER BY AVG(recommendations) DESC
LIMIT 1;


