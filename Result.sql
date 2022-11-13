create database sql_project;
use sql_project;

select * from product_details;
select * from product_hierarchy;
select * from product_prices;
select * from sales;

-- What was the total quantity sold for all products?

select pd.product_name, sum(s.qty) as total_sales
from product_details pd
inner join sales s
on pd.product_id = s.prod_id
group by pd.product_name
order by total_sales desc

-- What is the total generated revenue for all products before discounts?

select sum(price * qty) as total_revenue from sales;

-- What was the total discount amount for all products?

select sum(price*discount * qty)/100 as total_discount from sales;

-- How many unique transactions were there?

SELECT  COUNT(DISTINCT txn_id) AS unique_transactions FROM sales;

-- What are the average unique products purchased in each transaction?

WITH cte AS (SELECT txn_id, COUNT(DISTINCT prod_id) AS product_count FROM sales GROUP BY txn_id)
SELECT ROUND(AVG(product_count)) AS avg_unique_products FROM cte;

-- What is the average discount value per transaction?

WITH cte AS (SELECT txn_id, SUM(price * qty * discount)/100 AS total_discount FROM sales GROUP BY txn_id)
SELECT ROUND(AVG(total_discount)) AS avg_unique_products FROM cte;

-- What is the average revenue for member transactions and non-member transactions?

WITH cte AS (SELECT member, txn_id, SUM(price * qty) AS revenue FROM sales GROUP BY  member, txn_id)
SELECT member,ROUND(AVG(revenue), 2) AS avg_revenue FROM cte GROUP BY member;

-- What are the top 3 products by total revenue before discount?


select pd.product_name,s.prod_id,sum(s.price * s.qty) as total_revenue 
from sales s
inner join product_details pd
on s.prod_id = pd.product_id
group by pd.product_name,s.prod_id 
order by total_revenue desc
limit 3;

-- What are the total quantity, revenue and discount for each segment?

SELECT 
	pd.segment_id,
	pd.segment_name,
	SUM(s.qty) AS total_quantity,
	SUM(s.qty * s.price) AS total_revenue,
	SUM(s.qty * s.price * s.discount)/100 AS total_discount
FROM sales AS s
INNER JOIN product_details AS pd
	ON s.prod_id = pd.product_id
GROUP BY 
	pd.segment_id,
	pd.segment_name
ORDER BY total_revenue DESC;

-- What is the top selling product for each segment?

SELECT 
	pd.segment_id,
	pd.segment_name,
	pd.product_id,
	pd.product_name,
	SUM(s.qty) AS product_quantity
FROM sales AS s
INNER JOIN product_details AS pd
	ON s.prod_id = pd.product_id
GROUP BY
	pd.segment_id,
	pd.segment_name,
	pd.product_id,
	pd.product_name
ORDER BY product_quantity DESC
LIMIT 5;

-- What are the total quantity, revenue and discount for each category?

SELECT 
	pd.category_id,
	pd.category_name,
	SUM(s.qty) AS total_quantity,
	SUM(s.qty * s.price) AS total_revenue,
	SUM(s.qty * s.price * s.discount)/100 AS total_discount
FROM sales AS s
INNER JOIN product_details AS pd
	ON s.prod_id = pd.product_id
GROUP BY 
	pd.category_id,
	pd.category_name
ORDER BY total_revenue DESC;

-- What is the top selling product for each category?

SELECT 
	pd.category_id,
	pd.category_name,
	pd.product_id,
	pd.product_name,
	SUM(s.qty) AS product_quantity
FROM sales AS s
INNER JOIN product_details AS pd
	ON s.prod_id = pd.product_id
GROUP BY
	pd.category_id,
	pd.category_name,
	pd.product_id,
	pd.product_name
ORDER BY product_quantity DESC
LIMIT 5;




