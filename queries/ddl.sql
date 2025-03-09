---> set the Role
USE ROLE accountadmin;

---> set the Warehouse
USE WAREHOUSE compute_wh;


-------------------------------------------------------------------------------------------
    -- Step 2: With context in place, let's now create a Database, Schema, and Table
        -- CREATE DATABASE: https://docs.snowflake.com/en/sql-reference/sql/create-database
        -- CREATE SCHEMA: https://docs.snowflake.com/en/sql-reference/sql/create-schema
        -- CREATE TABLE: https://docs.snowflake.com/en/sql-reference/sql/create-table
-------------------------------------------------------------------------------------------

---> create the Tasty Bytes Database
CREATE OR REPLACE DATABASE medium_articles_authors;

---> create medallion schema
CREATE OR REPLACE SCHEMA medium_articles_authors.bronze;

CREATE OR REPLACE SCHEMA medium_articles_authors.silver;

CREATE OR REPLACE SCHEMA medium_articles_authors.gold;

--CREATES stage

CREATE OR REPLACE STAGE medium_articles_authors.bronze.medium_stage
FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY='"', SKIP_HEADER=1);

CREATE OR REPLACE TABLE medium_articles_authors.bronze.medium_articles_bronze (
    article_id INT PRIMARY KEY,
    author STRING,
    title STRING,
    category STRING,
    publish_date STRING, -- Will convert later in Silver layer
    recommendations INT,
    read_ratio FLOAT,
    word_count INT,
    raw_text STRING -- Contains unstructured text
);

CREATE OR REPLACE TABLE medium_articles_authors.bronze.medium_authors_bronze (
    author_id INT PRIMARY KEY,
    author_name STRING,
    email STRING,
    address STRING,
    bio STRING,
    join_date STRING, -- Will convert to DATE in Silver layer
    total_followers INT
);

CREATE OR REPLACE TABLE medium_articles_authors.bronze.medium_engagement_bronze (
    engagement_id INT PRIMARY KEY,
    article_id INT, -- Foreign key reference to `medium_articles_bronze`
    user_id INT,
    engagement_type STRING,
    timestamp STRING -- Will convert to TIMESTAMP in Silver layer
);

CREATE OR REPLACE TABLE medium_categories_bronze (
    category_id INT PRIMARY KEY,
    category_code STRING UNIQUE,
    category_name STRING UNIQUE,
    description STRING
);

