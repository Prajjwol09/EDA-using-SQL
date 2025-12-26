-- Customer Report 
/*

Purpose: This report consolidates key customer metrics and behaviors

Highlights: 
	1. gather essential fields such  as names, ages and transaction details.
	2. segments customer into categories (VIP, REGULAR, NEW) and age groups
	3. aggregates customer-level metrics:
			- total orders
			- total sales
			- total quantity purchased
			- total products
			- lifespan (in months) 
	4. calculates valuable KPIs:
			- recency (months since last order)
			- average order value
			- average monthly spend 
*/


-- Step 1: Retrieving core columns from tables

create view customer_report as
with base_query as(
select 
	c.customer_key,
	c.customer_number,
	concat(c.first_name, ' ', c.last_name) as cus_name,
	f.product_key,
	f.order_number,
	f.order_date,
	f.quantity,
	f.sales_amount,
	datediff(year, c.birthdate, getdate()) as cus_age
from gold.fact_sales f
left join gold.dim_customers c
on f.customer_key = c.customer_key
where order_date is not null
), 
customer_aggregations as 
(
select 
	customer_key,
	customer_number,
	cus_name,
	cus_age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_Sales,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order,
	datediff(month, min(order_Date), max(order_Date)) as lifespan
from base_query
group by customer_key,customer_number,cus_name,cus_age
)

select 
	customer_key,
	customer_number,
	cus_name,
	cus_age,
	case 
		when cus_age < 20 then 'Under 20'
		when cus_age between 20 and 29 then '20-29'
		when cus_age between 30 and 39 then '30-39'
		when cus_age between 40 and 49 then '40-49'
		else '50 and above'
	end as age_group,
	total_orders,
	total_Sales,
-- computing average order value
	case 
		when total_orders = 0 then 0
		else (total_Sales / total_orders)
	end as avg_order_value,
-- computing average monthly spend
	case 
		when lifespan = 0 then total_Sales
		else (total_Sales / lifespan)
	end as avg_monthly_Spend,
	case 
		when lifespan >= 12 and lifespan > 5000 then 'Vip'
		when lifespan >=12 and lifespan <= 5000 then 'Regular'
		else 'New'
	end as cus_segmentation,
	total_products,
	total_quantity,
	last_order,
	datediff(month, last_order, getdate()) as recency,
	lifespan
from customer_aggregations;