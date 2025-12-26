-- Change over time analysis 

-- analyzing the sales performance over the time (yearly basis)
select	
	year(order_Date) as order_date_year,
	sum(sales_amount) as total_sales_amount,
	count(distinct customer_key) as total_Customers
from gold.fact_sales
where order_Date is not null
group by year(order_Date)
order by year(order_Date);

-- result: the sales amount and the customers were gradually increasing over the years, but the year 2014 faced a little decline than the previous year


-- cumulative analysis 

-- calculating the total sales per month and the running total of sales over the time
select 
	*,
	sum(total_Sales) over(partition by month_of_orderdate order by month_of_orderdate) as running_total_sales,
	avg(average_price) over(partition by month_of_orderdate order by month_of_orderdate) as running_Average
from 
(
select 
	datetrunc(month, order_Date) as month_of_orderdate,
	sum(sales_amount) as total_Sales,
	avg(price) as average_price
from gold.fact_sales
where order_date is not null
group by datetrunc(month, order_Date)
) as sub_query;


-- performance analysis

-- analyzing the yearly performance of products by comparing each products sales to both its average sale performance and the previous years sales
with yearly_product_Sales as
(
select 
	year(f.order_date) as year_of_orderdate,
	p.product_name,
	sum(f.sales_amount) as current_Sales_Amount
from gold.fact_sales f 
left join gold.dim_products p 
on p.product_key = f.product_key
where f.order_date is not null
group by year(f.order_date), p.product_name
)

select 
	year_of_orderdate,
	product_name,
	current_Sales_Amount,
	avg(current_Sales_Amount) over(partition by product_name) as average_Sales,
	current_Sales_amount - avg(current_Sales_Amount) over(partition by product_name) as difference_in_average,
	case 
		when current_Sales_amount - avg(current_Sales_Amount) over(partition by product_name) > 0 then 'Higher than average'
		when current_Sales_amount - avg(current_Sales_Amount) over(partition by product_name) < 0 then 'Below than average'
		else 'Average'
	end as average_status,
	lag(current_Sales_Amount) over (partition by product_name order by year_of_orderdate) as previous_year_salesAmount,
	current_Sales_Amount - lag(current_Sales_Amount) over (partition by product_name order by year_of_orderdate) as difference_in_salesamt_py,
	case
		when current_Sales_Amount - lag(current_Sales_Amount) over (partition by product_name order by year_of_orderdate) > 0 then 'Increasing'
		when current_Sales_Amount - lag(current_Sales_Amount) over (partition by product_name order by year_of_orderdate) < 0 then 'Decreasing'
		else 'No Change'
	end as sales_py_status
from yearly_product_Sales
order by product_name, year_of_orderdate; 


-- part to whole analysis

-- analyzing which category contributes the most to overall sales
with category_Sales as
(
select 
	p.category,
	sum(f.sales_amount) as total_Sales_amount
from gold.fact_sales f
left join gold.dim_products p 
on f.product_key = p.product_key
group by p.category
)

select 
	*,
	sum(total_Sales_Amount) over() as overall_Sales,
	concat(round((cast(total_Sales_Amount as float) / sum(total_Sales_Amount) over()) * 100,2), '%') as percentage_of_total
from category_Sales
order by total_Sales_amount desc;

-- result: The bike category contributes the most to the overall sales whereas the clothing category contributes the least.

