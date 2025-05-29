SELECT COUNT (*)
FROM retail_sales;

--How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) 
AS unique_customers
FROM retail_sales;

--How many transaction were done over the sales period..
SELECT COUNT (*) AS total_transactions
FROM retail_sales;



--viewing the data

SELECT * FROM retail_sales
LIMIT 5;

-- listing out all the category names from the data frame..
SELECT DISTINCT category
FROM retail_sales;

-- Lets proceed to solve some business problems...

-- Data analysis and Business key problems and answers..

--some of the questions are as follows..
--1. Write an SQL query to retrieve all columns for sales made on '2022-11-05'
--2.Write an SQL quey to retrieve all transactions where the category is 'CLotjing'


-- Q1 Write an SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


--Q2 Write an SQL query to retrieve all transactions where the category is 'Clothing'and the quantity old is more than 10 in the month of NOV-2022
SELECT 
	category,
	SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	
GROUP BY 1; 

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY 1 


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;

-- Q3 Write an SQL query ti calculate the total sales (total sale) for each category
SELECT category, SUM(total_sale) AS total_sales 
FROM retail_sales
GROUP BY category;
	
	
	-- including the total orders as well...
SELECT
	category,
	SUM (total_sale) AS total_sales,
	COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;

--Q4 write an SQL query to find the average age of customers who purchased items from the 'Beauty category'
SELECT category,AVG(age) AS average_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- alternatively...

SELECT
	ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

--average age of customer who purchased from the Beauty Category..


--Q5 Write an SQL query to find all transactions where the total sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale >1000;

--Q6 Write an sql query to find the total number of transactions (transactions_id) made by each gender in  each category.
SELECT gender, COUNT(*) AS total_transactions_bygender
FROM retail_sales
GROUP BY gender;

-- we missed out on the category..
SELECT
	category,
	gender,
	COUNT(*) AS total_transactions_bygender
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY category;

--Q7 Write an sql query to find out the average sale for each month, Find out best selling month in each year..
	--using extract year functions..
	
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, avg_sale DESC;

-- alternatively..
SELECT
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	AVG(total_sale) AS avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)
FROM retail_sales
GROUP BY 1, 2;

-- modifying the code a bit ..
SELECT * FROM 
	(SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
	) AS t1
WHERE  rank =1;

--this has been asked alot in interviews

SELECT
	year,
	month,
	avg_sale
FROM
(SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
	) AS t1
WHERE  rank =1;

--Q8 Write an sql query to find the top 5 customers based on the highest total sales
SELECT
	customer_id,
	SUM(total_sale) AS total_sales_bycust
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales_bycust DESC
LIMIT 5;

--Q9 Write an sql query to find the number of unique customers who purchased items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) AS cnt_unique_customers
FROM retail_sales
GROUP BY 1;

--Q10 Write an SQL query to create each shift and number of orders(example Morning<=12, Afternoon Between 12 & 17, Evening>17)
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)

SELECT
	shift,
	COUNT(transactions_id) AS total_orders
	FROM hourly_sale
GROUP BY shift;

--end of project