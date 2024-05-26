create table sales
( pizza_id	int8 PRIMARY KEY,
  order_id	int,
  pizza_name_id	VARCHAR(50),
  quantity int,
  order_date DATE, 
  order_time TIME,
  unit_price FLOAT,
  total_price FLOAT,
  pizza_size VARCHAR(10),
  pizza_category VARCHAR(25),
  pizza_ingredients	VARCHAR(250),
  pizza_name VARCHAR(100)

)

SELECT * FROM sales

COPY sales (pizza_id, order_id, pizza_name_id, quantity, order_date, order_time, unit_price, total_price, pizza_size,	pizza_category,	pizza_ingredients,	pizza_name)
FROM 'E:\databases\pizza_sales.csv'
DELIMITER ','
CSV HEADER;

select * from sales

--1) Total revenue generated.
SELECT SUM(total_price) AS Total_Revenue FROM sales

-- 2) Average Order value
SELECT SUM(total_price)/COUNT(DISTINCT order_id) AS Avg_order_value FROM sales

--3) Total pizzas sold
SELECT SUM(quantity) AS Total_pizzas_sold FROM sales

--4) Total orders placed
SELECT COUNT(DISTINCT order_id) AS Total_orders FROM sales

--5)Average Pizzas per order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) AS Avg_pizzas_per_order FROM sales

--6) Peak hours of Pizza Sales
SELECT 
    EXTRACT(HOUR FROM order_time) AS peak_hour,
    COUNT(*) AS order_count
FROM sales
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY order_count DESC;

	

							--B.	Daily Trends of Orders placed 
SELECT TO_CHAR(order_date, 'Day') AS order_day, COUNT(DISTINCT order_id) AS Total_orders FROM sales
GROUP BY order_day 

							--C) Monthly Trends of Orders placed
SELECT TRIM(TO_CHAR(order_date, 'Month')) AS order_month, COUNT(DISTINCT order_id) AS monthly_orders FROM sales
GROUP BY order_month
ORDER BY monthly_orders DESC

							-- D) % of sales by pizza_category
SELECT 
    pizza_category, 
    CAST(SUM(total_price) AS DECIMAL(10, 2)) AS total_revenue, 
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM sales WHERE EXTRACT(Month FROM order_date) = 1) AS DECIMAL(10, 2)) AS percent_sales_bycategory
FROM 
    sales 
WHERE 
    EXTRACT(Month FROM order_date) = 1 -- 1 corresponds to the first quarter
GROUP BY 
    pizza_category;
-- in place of EXTRACT(Month From...) we can also use TRIM(TO_CHAR(column_name,'Month')=1)

							
									   -- E)% of Sales by pizza sales(pizza sizes)
SELECT pizza_size, 
	CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
CAST(SUM(total_price)*100/(SELECT SUM(total_price) FROM sales WHERE EXTRACT(QUARTER FROM order_date)=1) AS DECIMAL(10,2)) AS percent_sales_by_sizes 
FROM sales
	WHERE EXTRACT(QUARTER FROM order_date)=1    -- filtering data on the basis of quarters
GROUP BY pizza_size
ORDER BY percent_sales_by_sizes DESC ;


							-- F) Total pizzas sold by pizza_category
SELECT pizza_category, SUM(quantity) AS total_pizzas_sold FROM sales
--WHERE EXTRACT(Month FROM order_date)=2
GROUP BY pizza_category
ORDER BY total_pizzas_sold DESC;


							-- G) Top 5 Best Selling Pizzas 
--by Revenue
SELECT pizza_name, CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue FROM sales
GROUP BY pizza_name
ORDER BY total_revenue DESC
LIMIT 5

--by Quantity
SELECT pizza_name, SUM(quantity) AS highest_quantity FROM sales
GROUP BY pizza_name
ORDER BY highest_quantity DESC
LIMIT 5

--by Count of order_ID
SELECT pizza_name, COUNT(DISTINCT order_id) AS highest_orders FROM sales
GROUP BY pizza_name
ORDER BY highest_orders DESC
LIMIT 5

	
								-- H) Bottom 5 Worst Selling Pizzas 
--by Revenue
SELECT pizza_name, CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue_worst FROM sales
GROUP BY pizza_name
ORDER BY total_revenue_worst ASC
LIMIT 5

--by Quantity
SELECT pizza_name, SUM(quantity) AS lowest_quantity FROM sales
GROUP BY pizza_name
ORDER BY lowest_quantity ASC
LIMIT 5

--by Count of order_ID
SELECT pizza_name, COUNT(DISTINCT order_id) AS lowest_orders FROM sales
GROUP BY pizza_name
ORDER BY lowest_orders ASC
LIMIT 5
 




