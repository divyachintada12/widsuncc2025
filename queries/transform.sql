

----------------------------------------------------------------------------------
-- SILVER
--✔ Removes extra spaces, standardizes text, and ensures all values are present.
--✔ Cleans and ensures proper formatting of author details.
CREATE OR REPLACE TABLE medium_articles_authors.silver.medium_authors_silver AS
SELECT 
    author_id,
    author_name,
    TO_DATE(join_date, 'YYYY-MM-DD') AS join_date,
    COALESCE(total_followers, 0) AS total_followers
FROM medium_articles_authors.bronze.medium_authors_bronze
WHERE author_name IS NOT NULL 
  AND join_date IS NOT NULL 
  AND total_followers IS NOT NULL;

-- ✔ Filters out NULL authors, titles, and publish dates.
-- ✔ Fixes negative recommendations.
-- ✔ Removes invalid read ratios (values outside 0-1 range).
CREATE OR REPLACE TABLE medium_articles_authors.silver.medium_articles_silver AS
SELECT 
    a.article_id,
    a.author,
    a.title,
    c.category_name,  -- Categories
    TO_DATE(a.publish_date, 'YYYY-MM-DD') AS publish_date,
    CASE 
        WHEN recommendations < 0 THEN 0 
        ELSE COALESCE(recommendations, 0) 
    END AS recommendations, -- Fix negative recommendations
    CASE 
        WHEN read_ratio < 0 OR read_ratio > 1 THEN 0.0 
        ELSE read_ratio 
    END AS read_ratio, -- Remove outliers in read_ratio
    COALESCE(word_count, 0) AS word_count
FROM medium_articles_authors.bronze.medium_articles_bronze a
JOIN medium_articles_authors.bronze.medium_categories_bronze c 
ON LOWER(a.category) = LOWER(c.category_code)
WHERE a.author IS NOT NULL 
  AND a.title IS NOT NULL 
  AND a.publish_date IS NOT NULL;


--formatting the date
CREATE OR REPLACE TABLE medium_articles_authors.silver.medium_engagement_silver AS
SELECT 
    engagement_id,
    article_id,
    user_id,
    LOWER(engagement_type) AS engagement_type,
    TO_TIMESTAMP(timestamp, 'YYYY-MM-DD HH24:MI:SS') AS engagement_timestamp
FROM medium_articles_authors.bronze.medium_engagement_bronze;




-----------------------------------------------------------------------------------
-- GOLD 
--Now, we integrate engagement insights into the Gold layer
-- ✔ Adds aggregated engagement metrics to the Gold layer.
-- ✔ Ensures no sensitive data is stored.
CREATE OR REPLACE TABLE medium_articles_authors.gold.medium_articles_gold AS
SELECT 
    a.article_id,
    a.title,
    a.category_name,
    a.author,
    auth.author_id,
    auth.total_followers,
    a.publish_date,
    a.recommendations,
    a.read_ratio,
    a.word_count,
    COUNT(e.engagement_id) AS total_engagements,
    COUNT(CASE WHEN e.engagement_type = 'like' THEN 1 END) AS total_likes,
    COUNT(CASE WHEN e.engagement_type = 'comment' THEN 1 END) AS total_comments,
    COUNT(CASE WHEN e.engagement_type = 'share' THEN 1 END) AS total_shares
FROM medium_articles_authors.silver.medium_articles_silver a
JOIN medium_articles_authors.silver.medium_authors_silver auth ON a.author = auth.author_name
LEFT JOIN medium_articles_authors.silver.medium_engagement_silver e ON a.article_id = e.article_id
GROUP BY a.article_id, a.title, a.category_name, a.author, auth.author_id, auth.total_followers, 
         a.publish_date, a.recommendations, a.read_ratio, a.word_count;

--✔ Aggregates key author performance metrics for hiring analysis.
CREATE OR REPLACE TABLE medium_articles_authors.gold.medium_author_performance AS
SELECT 
    a.author_id,
    a.author_name,
    a.total_followers,
    a.join_date,
    COUNT(ar.article_id) AS total_articles,
    SUM(ar.recommendations) AS total_recommendations,
    AVG(ar.read_ratio) AS avg_read_ratio,
    SUM(ar.word_count) AS total_words_written
FROM medium_articles_authors.silver.medium_authors_silver a
LEFT JOIN medium_articles_authors.silver.medium_articles_silver ar ON a.author_name = ar.author
GROUP BY a.author_id, a.author_name, a.total_followers,a.join_date;


