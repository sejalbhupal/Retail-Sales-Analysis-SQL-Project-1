-- Sql Retail Sales Analysis -P1

create database sql_project_p1;
use sql_project_p1;

create table retail_sales_tb
(
 transactions_id int primary key ,
 sale_date date,
 sale_time time,
 customer_id int ,
 gender varchar(15) ,
 age int ,
 category varchar(15),
 quantiy int,
 price_per_unit float,
 cogs float ,
 total_sale float 
);


select* from retail_sales_tb;

create database retail_sales_p2
;

select* from retail_sql limit 10;
select count(*) from retail_sql;

select* from retail_sql where ï»¿transactions_id is null ;

select* from retail_sql where sale_date is null or
 sale_time is null or
 gender is null  or
category is null or quantiy is null or price_per_unit is null or cogs is null or total_sale is null;

-- DATA EXPLORATION

-- how many sales we have ?
select count(*) as total_sale from retail_sql;

-- how many UNIQUE customer we have ?
select count(distinct customer_id) as customer from retail_sql;

select distinct category customer from retail_sql;


-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Main data analysis or Decision making
 My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sql where sale_date ='05-11-2022';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select category, sum(quantiy) from retail_sql
where category ="Clothing"
and date_format(sale_date,'%m-%Y')='11-2022' 
AND quantiy>=4;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select avg(age) as avg_age from retail_sql where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select ï»¿transactions_id from retail_sql where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category ,gender,count(*) as total_trans from retail_sql
group by category,gender
order by 1
;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select
year,month,avg_sale
 from(
select
extract(YEAR from sale_date)as year,
extract(MONTH from sale_date) as month,
avg(total_sale) as avg_sale,
rank()over(
partition by extract(YEAR from sale_date) 
order by avg(total_sale)desc
)
as rnk 
from retail_sql
group by 
extract(YEAR from sale_date),
extract(MONTH from sale_date)
)as t 
where rnk=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) from retail_sql
group by customer_id,total_sale order by total_sale desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project