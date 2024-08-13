CREATE DATABASE Salesdata;
CREATE TABLE IF NOT EXISTS Sales(
Invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
Branch VARCHAR(5) NOT NULL,
City VARCHAR(30) NOT NULL,
Customer_type VARCHAR(30) NOT NULL,
Gender VARCHAR(10) NOT NULL,
Product_line VARCHAR(100) NOT NULL,
Unit_price Decimal(10,2) NOT NULL,
Quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
Total DECIMAL(12,4) NOT NULL,
Date DATETIME NOT NULL,
Time TIME NOT NULL,
Payment_method	VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),	
gross_income DECIMAL(12,4) NOT NULL,
Rating FLOAT(2,1)
);





-- -------------- Feature Engineering ------------------ --

-- time_of_day
ALTER TABLE sales
DROP COLUMN Time_of_day;
SELECT Time,
(
CASE
WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END
) AS Time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN Time_of_day VARCHAR(20);
UPDATE sales
SET Time_of_day=
(
CASE
WHEN Time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END
);

-- Day_name --
SELECT Date,
dayname(Date) AS Day_name
FROM Sales;

ALTER TABLE sales ADD COLUMN Day_name VARCHAR(10);
UPDATE sales
SET Day_name=dayname(Date);

-- Month_name --
ALTER TABLE sales ADD COLUMN Month_name VARCHAR(10);
UPDATE sales
SET Month_name=monthname(Date);
-- ----------------------------------------------------------
-- ---------------------------------------------------------
-- -----------------------Generic----------------------------
-- ---------How many unique cities does the data have?--------------------------
SELECT DISTINCT City FROM sales;

-- -------------In which city is each branch?------
SELECT DISTINCT City, Branch FROM sales;


-- --------------Product-----------------------
-- -------------How many unique product lines does the data have?-------------
SELECT COUNT(DISTINCT Product_line) FROM sales;

-- ------------What is the most common payment method?------------
SELECT Payment_method, Count(Payment_method) AS Count FROM sales
GROUP BY Payment_method
ORDER BY Count DESC
LIMIT 1;

-- What is the most selling product line?
SELECT Product_line, SUM(Quantity) AS Qty FROM sales
GROUP BY Product_line
ORDER BY Qty DESC
;

-- What is the total revenue by month?
SELECT SUM(Total) AS Revenue, Month_name FROM sales
GROUP BY Month_name
ORDER BY REVENUE desc;

-- What month had the largest COGS
SELECT Month_name, SUM(Cogs) AS Cogs FROM sales
GROUP BY Month_name
ORDER BY Cogs DESC;

-- What product line had the largest revenue?
SELECT Product_line, SUM(Total) AS Total FROM sales
GROUP BY Product_line
ORDER BY Total DESC
;

-- What is the city with the largest revenue?
SELECT City, SUM(Total) AS Revenue FROM sales
GROUP BY City
ORDER BY Revenue DESC;

-- What product line had the largest VAT?
SELECT Product_line, AVG(VAT) AS Avg_VAT FROM sales
GROUP BY Product_line
ORDER BY Avg_VAT DESC;

-- Fetch each product line and add a column to those product lines showing "Good", and "Bad". Good if it's greater than average sales?
SELECT AVG(Quantity) AS Avg_qty FROM sales;
SELECT Product_line,
(
CASE
 WHEN AVG(Quantity) > 5.4995 THEN 'Good'
 ELSE 'Bad'
 END
) AS Remark FROM sales
GROUP BY Product_line;

-- Which branch sold more products than the average product sold?
SELECT Branch, SUM(Quantity) AS Qty FROM sales
GROUP BY Branch
HAVING QTY> AVG(Quantity);

-- What is the most common product line by gender?
SELECT Product_line, Gender, COUNT(Gender) AS Count FROM sales
GROUP BY Gender, Product_line
ORDER BY Gender, Count DESC;

-- What is the average rating of each product line?
SELECT ROUND(AVG(Rating),2) AS Avg, Product_line FROM sales
GROUP BY Product_line
ORDER BY Avg DESC;


-- --------------------Sales------------------
-- The number of sales made at each time of the day per weekday?
SELECT Time_of_day, Day_name, COUNT(*) AS Total_sales FROM sales
WHERE Day_name IN ('Monday', 'Tuesday', 'Wednesday', 'Thrusday', 'Friday')
GROUP BY Day_name, Time_of_day
ORDER BY 
CASE DAY_name
WHEN 'Monday' Then 1
WHEN 'Tuesday' Then 2
WHEN 'Wednesday' Then 3
WHEN 'Thrusday' Then 4
WHEN 'Friday' Then 5
END,
Total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT Customer_type, SUM(Total) AS Revenue FROM sales
GROUP BY Customer_type
ORDER BY Revenue DESC;

-- Which city has the largest tax percent/VAT ?
SELECT City, AVG(VAT) AS VAT FROM sales
Group BY City
ORDER BY VAT;

-- Which customer type pay the most in VAT?
SELECT Customer_type, AVG(VAT) AS VAT FROM sales
GROUP BY Customer_type
ORDER BY VAT;

-- ------------------------Cutomer----------------------
-- How many unique customer types does the data have?
SELECT DISTINCT(Customer_type) AS Unique_customer_type FROM Sales;

-- What is the most common customer type?
SELECT Customer_type, Count(Customer_type) AS Unique_customer_type FROM Sales
GROUP BY Customer_type;

-- which customer type buys the most?
SELECT Customer_type, sum(TOTAL) AS Sum From Sales
GROUP BY Customer_type
ORDER BY Sum Desc;

-- What is the gender of most of the customers
SELECT Gender, Count(Gender) AS Count FROM sales
GROUP BY Gender
ORDER BY Count DESC;

-- What is the gender distribution per branch?
SELECT Gender, Branch, Count(Branch) AS Count FROM sales
GROUP BY Gender, Branch
ORDER BY Count DESC;

-- which day of the week customers give most rating per branch?
SELECT Day_name, AVG(Rating) AS Avg FROM sales
WHERE Branch='c'
GROUP BY Day_name
ORDER BY Avg DESC;














