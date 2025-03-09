# widsuncc2025
# **Medium Data Engineering Pipeline**
This repository contains a **data engineering workflow** to process **Medium articles data** from **raw ingestion (Bronze)** to **cleaned, analytics-ready tables (Gold).**  
It helps students understand **data quality issues, PII handling, and business insights.**

---

## 📂 **Dataset Overview**
This dataset simulates **real-world Medium article data**, including:
- **Articles** (titles, categories, publish dates, recommendations, etc.)
- **Authors** (names, follower count, PII like email & address)
- **User Engagement** (likes, reads, shares, comments)

🚀 **Total Records:**
- 3,000 unique articles 📑
- 50 authors ✍️
- 20,000+ user engagement records 💬

---

## 🔄 **ETL Process (Bronze → Silver → Gold)**
### **1️⃣ Bronze Layer (Raw Data)**
- Raw **CSV files** with **inconsistencies & PII**
- Contains **NULL values, duplicate titles, missing categories, and anomalies**

### **2️⃣ Silver Layer (Cleaned Data)**
- **Removes PII** (emails, addresses)
- **Filters out invalid records** (NULL values, negative numbers, unknown categories)
- **Ensures consistency** (date formatting, category standardization)

### **3️⃣ Gold Layer (Final Analytics Tables)**
- **Joins authors, articles, and engagement data**
- **Aggregates metrics** (total engagements, most popular authors)
- **Optimized for business insights & dashboards**

---

## 📊 **Business Insights Queries**
Here are some sample SQL queries to analyze the cleaned data:

### **🔹 Most Popular Authors**
```sql
SELECT author_name, total_followers, total_recommendations
FROM medium_author_performance
ORDER BY total_recommendations DESC
LIMIT 10;

