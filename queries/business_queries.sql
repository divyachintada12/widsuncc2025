--Authors with the Highest Read Ratio
SELECT author_name, avg_read_ratio 
FROM medium_articles_authors.gold.medium_author_performance
ORDER BY avg_read_ratio DESC
LIMIT 1;

--Which articles have the highest engagement but a low read ratio(less than 0.3)?
--✔ Useful for understanding why certain articles don’t get fully read.
SELECT 
    title, 
FROM medium_articles_gold
WHERE read_ratio < 0.3 -- Low Read Ratio
ORDER BY total_engagements DESC
LIMIT 1;


--Which articles got the highest engagement in the first 24 hours?
SELECT 
    a.title, 
    a.author, 
    COUNT(e.engagement_id) AS engagement_24h
FROM medium_articles_gold a
JOIN medium_articles_authors.silver.medium_engagement_silver e ON a.article_id = e.article_id
WHERE e.engagement_timestamp <= a.publish_date + INTERVAL '1 DAY'
GROUP BY a.title, a.author
ORDER BY engagement_24h DESC
LIMIT 10;


--For visualization (Dashboard)
--- Monthly Publishing Trend (Line Chart)
SELECT publish_date, COUNT(*) AS num_articles
FROM medium_articles_authors.gold.medium_articles_silver
GROUP BY publish_date
ORDER BY publish_date;

--Most Engaging Articles (Bar Chart)
SELECT title, author, total_engagements 
FROM medium_articles_authors.gold.medium_articles_gold
ORDER BY total_engagements DESC
LIMIT 10;


--Popular Authors by Recommendations (Bar Chart)
SELECT author_name, total_recommendations 
FROM medium_articles_authors.gold.medium_author_performance
ORDER BY total_recommendations DESC
LIMIT 10;
