-- CREATE DATABASE SQL_project;

-- CREATE TABLE transactions_id	sale_date	sale_time	customer_id	gender	age	category	quantiy	price_per_unit	
-- cogs	total_sale

CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY,
	sale_date	DATE,
	sale_time	TIME,
	customer_id	INT,
	gender	VARCHAR(15),
	age	 INT,
	category VARCHAR(15),
	quantiy	INT,
	price_per_unit	FLOAT,
	cogs	FLOAT,
	total_sale FLOAT
);


SELECT * FROM retail_sales LIMIT 10;

-- DATA CLEANING 
-- COUNT
SELECT COUNT(*) FROM retail_sales;


-- Check for null values

SELECT * FROM retail_sales WHERE transactions_id IS NULL


-- Checking for null values

SELECT * FROM retail_sales 
	WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	gender IS NULL
	OR 
	sale_time IS NULL
	OR 
	quantiy IS NULL
	OR 
	total_sale IS NULL
	OR 
	cogs IS NULL


-- DELETE NULL VALUES


DELETE  FROM retail_sales 
	WHERE transactions_id IS NULL
	OR
	sale_date IS NULL
	OR 
	gender IS NULL
	OR 
	sale_time IS NULL
	OR 
	quantiy IS NULL
	OR 
	total_sale IS NULL
	OR 
	cogs IS NULL



-- 






-- DATA EXPLORATION 

-- HOW MANY SALES WE HAVAE

SELECT COUNT(*) AS total_sales FROM retail_sales 

-- HOW MANY CUSTOMER DO WE HAVE 

SELECT COUNT(customer_id) AS total_sales FROM retail_sales 

SELECT COUNT(DISTINCT customer_id) AS total_sales FROM retail_sales

-- Number of category 
SELECT COUNT(DISTINCT category) AS total_sales FROM retail_sales

SELECT  DISTINCT category FROM retail_sales

-- data analysis and business problems 


--  write sql query to retrieve all columns slaes made on 2022-11-05

SELECT * FROM retail_sales WHERE sale_date ='2022-11-05';


-- write sql  query to retrieve all transactions where category is 'clothing' and quantiy sold is more than 4 in
-- month of Nov -2022

SELECT * FROM retail_sales WHERE category ='Clothing'  AND TO_CHAR(sale_date ,'YYYY-MM') ='2022-11' AND quantiy >= 4;




-- write a sql query to calculate the total sales (total sales for each category)

SELECT category,SUM(total_sale) AS net_sale, COUNT(*) AS total_order FROM retail_sales GROUP BY 1;


-- wrire a sql query to find the average age of customer who purchased items from Beauty category


SELECT ROUND(AVG(age),2) AS ave_age FROM retail_sales WHERE category ='Beauty';



-- write a sql query to find all transactions where the toltal sales is greater than 1000

SELECT * FROM retail_sales WHERE total_sale > 1000;


--  write a sql query to find total, number of transactions(transaction_id) made by each gender category


SELECT category, gender ,COUNT(*) AS total_sales FROM retail_sales GROUP BY category,gender ORDER BY 1;

--  write a sql qury to calculate the aveerage sales for each month find out the best selling month in each year


SELECT * FROM retail_sales;


-- SELECT * FROM (
-- 	SELECT 
-- 		EXTRACT(YEAR FROM sale_date) AS year,
-- 		EXTRACT(MONTH FROM sale_date) AS month,
-- 		AVG(total_sale) AS  total_sale,
-- 		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS rank
-- 	FROM retail_sales GROUP BY 1,2  

-- ) AS t1 
-- WHERE rank = 1;



SELECT 
	year,
	month,
	avg_sale
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS  avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC ) AS rank
	FROM retail_sales GROUP BY 1,2  

) AS t1 
WHERE rank = 1;


-- write a sql query to find the top 5 cusomer based on the highest total sale



SELECT  customer_id,SUM(total_sale) FROM retail_sales GROUP BY 1 ORDER BY 2 DESC LIMIT 5 ;

-- write a sql query to find the number of unique customer who purchased itmes from each category

SELECT  category ,COUNT(DISTINCT customer_id) AS customer FROM retail_sales GROUP BY 1 ;


-- write a sql query to create each shift and number of order (Morning <12 Afternoon Between 12 & 17 Evening > 17)


WITH hour_sales AS (
	SELECT 
	*,
	
	CASE 
		WHEN EXTRACT (HOUR FROM sale_time ) < 12  THEN 'Morning'
		WHEN EXTRACT (HOUR FROM sale_time )BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift

FROM retail_sales

) 
SELECT shift,COUNT(*) AS total_order  FROM hour_sales GROUP BY shift;
