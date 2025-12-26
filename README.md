## Project Overview

This project demonstrates **end-to-end Exploratory Data Analysis (EDA) using SQL** on a structured **sales data warehouse**.
The objective is to explore customer behavior, product performance, and sales trends using **pure SQL**, following analytical best practices commonly used in real-world BI and analytics teams.

The analysis is performed on a **star-schema-based data warehouse** consisting of fact and dimension tables, enabling scalable and repeatable business analysis without external BI tools.

---

## Dataset & Schema Design

The database is built as **`DataWarehouseAnalytics`** with a dedicated **`gold` schema**, representing curated, analytics-ready data.

### Tables Used

**Fact Table**

* `gold.fact_sales`

  * Order-level transactional data
  * Measures: `sales_amount`, `quantity`, `price`
  * Dates: `order_date`, `shipping_date`, `due_date`

**Dimension Tables**

* `gold.dim_customers`

  * Customer demographics (country, gender, birthdate, marital status)
* `gold.dim_products`

  * Product attributes (category, subcategory, cost, product line)

This design supports efficient **aggregation, filtering, and time-based analysis**.

---

## Data Loading

* Source data is provided as CSV files.
* Tables are populated using **`BULK INSERT`** for performance.
* Existing tables are truncated before loading to ensure data consistency.

---

## Analysis Workflow

The EDA follows a **structured analytical flow**, moving from basic understanding to advanced insights.

---

### 1️⃣ Database & Schema Exploration

* Inspected all tables and columns using `INFORMATION_SCHEMA`
* Verified key columns, data types, and relationships
* Ensured completeness of core analytical fields

---

### 2️⃣ Dimension Exploration

* Customer distribution by country and gender
* Product hierarchy analysis:

  * Category
  * Subcategory
  * Individual products

This step establishes **data coverage and dimensional richness**.

---

### 3️⃣ Date & Time Analysis

* Identified:

  * Earliest and latest order dates
  * Total years of available sales data
* Analyzed customer age distribution using birthdates

This confirms the **temporal scope and historical depth** of the dataset.

---

### 4️⃣ Core Business Metrics (Measures)

Calculated key KPIs including:

* Total sales revenue
* Total quantity sold
* Average selling price
* Total orders
* Total customers
* Total products

A consolidated KPI report is generated using `UNION ALL`, simulating a **dashboard-ready metrics table**.

---

### 5️⃣ Magnitude Analysis

Measured business volume across dimensions:

* Customers by country and gender
* Products by category
* Revenue by category
* Revenue by customer
* Items sold by country

This highlights **where the business volume is concentrated**.

---

### 6️⃣ Ranking Analysis

Used both `TOP` queries and **window functions** to:

* Identify top and bottom-performing products
* Find customers with the fewest orders
* Rank products by revenue contribution

This enables **performance comparison and prioritization**.

---

### 7️⃣ Change Over Time Analysis

* Yearly sales and customer growth trends
* Monthly sales aggregation
* Running totals and cumulative averages using window functions

These queries reveal **growth patterns, seasonality, and anomalies** over time.

---

### 8️⃣ Performance & Comparative Analysis

Using CTEs and window functions:

* Compared yearly product sales against:

  * Product’s historical average
  * Previous year performance
* Classified trends as:

  * Increasing
  * Decreasing
  * No change

This simulates **real business performance monitoring logic**.

---

### 9️⃣ Part-to-Whole Analysis

* Calculated each product category’s contribution to total revenue
* Expressed results as percentages of overall sales

This answers **which segments drive the business most**.

---

### 🔟 Segmentation Analysis

**Product Segmentation**

* Grouped products by cost ranges
* Identified distribution across pricing tiers

**Customer Segmentation**

* Customers classified as:

  * **VIP**
  * **Regular**
  * **New**
* Based on lifespan and total spending behavior

This supports **targeted marketing and retention strategies**.

---

## Analytical Reports (Views)

Two reusable SQL views were created for reporting and BI use:

### 🧑 Customer Report (`customer_report`)

Includes:

* Customer demographics & age groups
* Order and spending metrics
* Average order value
* Average monthly spend
* Recency & lifespan
* Behavioral segmentation

### 📦 Product Report (`product_report`)

Includes:

* Product hierarchy and cost
* Revenue-based performance segmentation
* Order, sales, and customer metrics
* Recency & lifespan
* Average order revenue
* Average monthly revenue

These views are **analytics-ready and dashboard-friendly**.

---

## SQL Techniques Used

* Star schema modeling
* CTEs (`WITH`)
* Window functions (`ROW_NUMBER`, `LAG`, `AVG OVER`, `SUM OVER`)
* Aggregations & grouping
* Date functions (`DATEDIFF`, `DATETRUNC`)
* Conditional logic (`CASE WHEN`)
* Ranking & cumulative analysis

---

## Key Insights Summary

* Sales and customer base generally grow over time with minor declines in later years
* Bikes category dominates total revenue
* Majority of customers fall into the “New” segment
* High-value customers contribute disproportionately to revenue
* Product performance varies significantly year-over-year

---

## Conclusion

This project showcases how **SQL alone can be used to perform deep, structured exploratory data analysis** on a warehouse-style dataset.
It reflects real-world analytical thinking, scalable query design, and business-focused insights.
