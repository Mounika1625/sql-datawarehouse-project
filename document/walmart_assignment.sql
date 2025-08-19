create database walmart;
use walmart;
select *  from  `walmartsales`;
#Create a column to classify time into Morning, Afternoon, and Evening.
select *,
  case
    when hour(time) between 5 and 11 then 'Morning'
    when hour(time) between 12 AND 17 then 'Afternoon'
    else 'Evening'
  end as Time_of_Day
from `walmartsales`;
#Extract the day of the week from the date.
SELECT Date,
       DAYNAME(Date) AS Day_of_Week
FROM walmartsales;
#Extract the month name from the date.
select date, monthname(date)as month_name from walmartsales;

#Exploratory Data Analysis (EDA)
# Generic Questions
# How many distinct cities are present in the dataset?
select count(distinct city) from walmartsales;
# In which city is each branch situated?
select distinct branch,city from walmartsales;
# Product Analysis
# How many distinct product lines are there in the dataset?
select count(distinct `product line`)as no_of_lines from walmartsales;
# What is the most common payment method?
select payment from walmartsales group by payment order by count(payment) desc limit 1;
#- What is the most selling product line?
select `product line` from walmartsales group by `product line` order by count(`gross income`) desc limit 1;
#What is the total revenue by month?
select monthname(date)as month_name,round(sum(total),2)as revenue_per_month from walmartsales group by month_name;
#Which month recorded the highest Cost of Goods Sold (COGS)?
select  monthname(date)as month_name,round(sum(cogs),2)as highest_cogs from walmartsales group by month_name order by highest_cogs desc limit 1;
#Which product line generated the highest revenue?
select `product line`,round(sum(total),2)as highest_revenue from walmartsales group by `product line` order by highest_revenue desc limit 1;
#Which city has the highest revenue?
select city,round(sum(total),2)as highest_city_revenue from walmartsales group by city order by highest_city_revenue desc limit 1;
#Which product line incurred the highest VAT?
select `product line`,round(sum(`tax 5%`),2)as highest_vat from walmartsales group by `product line` order by highest_vat desc limit 1;
#Retrieve each product line and add a column 'product_category', indicating 'Good' or 'Bad,' based on whether its sales are above the average.
 SELECT `Product line`,SUM(Total) AS Total_Sales,CASE WHEN SUM(Total) > (SELECT AVG(line_sales) FROM (SELECT SUM(Total) AS line_sales
FROM walmartsales GROUP BY `Product line`) AS sub) THEN 'Good'ELSE 'Bad'END AS product_category FROM walmartsales GROUP BY `Product line`;
#Which branch sold more products than average product sold?
SELECT Branch, COUNT(*) AS Total_Products_Sold FROM walmartsales GROUP BY Branch HAVING COUNT(*) > (SELECT AVG(product_count) FROM (SELECT COUNT(*) AS product_count 
FROM walmartsales GROUP BY Branch) AS avg_table);
#What is the most common product line by gender?
SELECT Gender, `Product line`, COUNT(*) AS Count FROM walmartsales GROUP BY Gender, `Product line`ORDER BY Gender, Count DESC;
#What is the average rating of each product line?
SELECT `Product line`, ROUND(AVG(Rating), 2) AS Avg_Rating FROM walmartsales GROUP BY `Product line`;
#Number of sales made in each time of the day per weekday (excluding weekends)
SELECT DAYNAME(Date) AS Weekday,CASE 
    WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS Time_of_Day,
COUNT(*) AS Num_Sales FROM walmartsales WHERE DAYNAME(Date) NOT IN ('Saturday', 'Sunday')GROUP BY Weekday, Time_of_Day ORDER BY FIELD(Weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday');
#Identify the customer type that generates the highest revenue
SELECT `Customer type`, SUM(Total) AS Total_Revenue FROM walmartsales GROUP BY `Customer type` ORDER BY Total_Revenue DESC LIMIT 1;
#Which city has the largest tax percent/VAT (Value Added Tax)?
SELECT City, SUM(`Tax 5%`) AS Total_Tax FROM walmartsales GROUP BY City ORDER BY Total_Tax DESC LIMIT 1;
#Which customer type pays the most in VAT?
SELECT `Customer type`, SUM(`Tax 5%`) AS Total_VAT FROM walmartsales GROUP BY `Customer type`ORDER BY Total_VAT DESC LIMIT 1;
#Customer Analysis- How many unique customer types does the data have?
SELECT COUNT(DISTINCT `Customer type`) AS Unique_Customer_Types
FROM walmartsales;
#How many unique payment methods does the data have?
SELECT COUNT(DISTINCT Payment) AS Unique_Payment_Methods
FROM walmartsales;
 #Which is the most common customer type?
SELECT `Customer type`, COUNT(*) AS Count FROM walmartsales GROUP BY `Customer type` ORDER BY Count DESC LIMIT 1;
#Which customer type buys the most (by total revenue and total count)?
-- By total revenue
SELECT Customer type, SUM(total) AS Total_Revenue FROM walmartsales GROUP BY `Customer type` ORDER BY Total_Revenue DESC LIMIT 1;
-- By total count
SELECT `Customer type`, COUNT(*) AS Total_Count FROM walmartsales GROUP BY `Customer type` ORDER BY Total_Count DESC LIMIT 1;
#What is the gender of most of the customers?
SELECT Gender, COUNT(*) AS Count FROM walmartsales GROUP BY Gender ORDER BY Count DESC LIMIT 1;
#What is the gender distribution per branch?
SELECT Branch, Gender, COUNT(*) AS Count FROM walmartsales GROUP BY Branch, Gender ORDER BY Branch;
#Which time of the day do customers give most ratings?
SELECT CASE 
    WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS Time_of_Day,
COUNT(Rating) AS Rating_Count FROM walmartsales GROUP BY Time_of_Day ORDER BY Rating_Count DESC LIMIT 1;
#Which time of the day do customers give most ratings per branch?
SELECT Branch,CASE 
    WHEN HOUR(Time) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN HOUR(Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS Time_of_Day,
count(Rating) AS Rating_Count FROM walmartsales GROUP BY Branch, Time_of_Day ORDER BY Branch, Rating_Count DESC;
#Which day of the week has the best average ratings?
SELECT DAYNAME(Date) AS Weekday,ROUND(AVG(Rating), 2) AS Avg_Rating FROM walmartsales GROUP BY Weekday ORDER BY Avg_Rating DESC LIMIT 1;
#Which day of the week has the best average ratings per branch?
SELECT Branch,DAYNAME(Date) AS Weekday,ROUND(AVG(Rating), 2) AS Avg_Rating FROM walmartsales GROUP BY Branch, Weekday ORDER BY Branch, Avg_Rating DESC;


