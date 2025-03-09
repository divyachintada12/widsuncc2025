--after loading into bronze, inspect the tables

COPY INTO medium_articles_authors.bronze.medium_articles_bronze
FROM @medium_stage/medium/medium_articles_bronze.csv
FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY='"', SKIP_HEADER=1)
ON_ERROR = CONTINUE;

COPY INTO medium_articles_authors.bronze.medium_authors_bronze
FROM @medium_stage/medium/medium_authors_bronze.csv
FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY='"', SKIP_HEADER=1)
ON_ERROR = CONTINUE;

COPY INTO medium_articles_authors.bronze.medium_engagement_bronze
FROM @medium_stage/medium/medium_engagement_bronze.csv
FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY='"', SKIP_HEADER=1)
ON_ERROR = CONTINUE;

COPY INTO medium_articles_authors.bronze.medium_categories_bronze
FROM @medium_stage/medium_categories_bronze.csv
FILE_FORMAT = (TYPE = CSV, FIELD_OPTIONALLY_ENCLOSED_BY='"', SKIP_HEADER=1)
ON_ERROR = CONTINUE;

