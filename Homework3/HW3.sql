
 USE prestigecars;

-- PRESTIGE CARS DATABASE
-- Question 1
-- Suppose the sales director wants to see the list of cars (make and model) bought on July 25, 2015. 
-- Write a SQL query to create this list.

SELECT 
    ma.MakeName, mo.ModelName, st.DateBought
FROM
    prestigecars.make ma
        JOIN
    prestigecars.model mo USING (makeID)
        JOIN
    prestigecars.Stock st USING (ModelID)
WHERE
    st.DateBought = '2015-07-25';



-- Question 2
-- The sales director now wants to see a list of all the cars (make and model) bought between July 15, 2018 and August 31, 2018.
--  Write a SQL query to create this list.
SELECT 
    ma.MakeName, mo.ModelName, st.DateBought
FROM
    prestigecars.make ma
        JOIN
    prestigecars.model mo USING (makeID)
        JOIN
    prestigecars.Stock st USING (ModelID)
WHERE
    st.DateBought BETWEEN '2018-07-15' AND '2018-08-31'
ORDER BY st.DateBought;

-- Question 3
-- The finance director is keen to ensure that cars do not stay on the firm’s books too long —it ties up expensive capital. 
-- So, the finance director wants a list of the makes and models and the number of days that each vehicle remained, unsold, 
-- on the lot until they were bought by a customer. Create this list. The director wants to see this list in such a way that 
-- the cars which remained on the lot the most longer appears on the top.
SELECT mk.MakeName, md.ModelName, DATEDIFF(s.SaleDate, st.DateBought) AS DaysUnsold
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
ORDER BY DaysUnsold DESC;

-- Question 4
-- Suppose the CFO wants to know the average daily purchase spend on cars over a six- month period. 
-- Create this list. Choose the period from July 1, 2015 through December 31, 2015.

SELECT 
    SaleDate, AVG(TotalSalePrice) AS avg_daily_spend
FROM
    prestigecars.Sales
WHERE
    SaleDate BETWEEN '2015-07-01' AND '2015-12-31'
GROUP BY SaleDate;




-- Question 5
-- As Prestige Cars has been selling cars for several years, the finance director wants to isolate the records for a specific year. 
-- In particular, the director wants to see a list of cars (make and model) sold in the year 2015. Create this list.
SELECT mk.MakeName, md.ModelName
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2015;



-- Question 6
-- Now that the director has the sales list for 2015 from the previous part,
--  he wants to compare the list of makes and models sold in both 2015 and in 2016. Create this list in an ordered fashion.
SELECT DISTINCT 
    mk1.MakeName, 
    m1.ModelName
FROM 
    sales AS s1
JOIN 
    salesdetails AS sd1 ON s1.SalesID = sd1.SalesID
JOIN 
    stock AS st1 ON sd1.StockID = st1.StockCode
JOIN 
    model AS m1 ON st1.ModelID = m1.ModelID
JOIN 
    make AS mk1 ON m1.MakeID = mk1.MakeID
WHERE 
    YEAR(s1.SaleDate) = 2015
AND EXISTS (
    SELECT 1 
    FROM sales AS s2
    JOIN salesdetails AS sd2 ON s2.SalesID = sd2.SalesID
    JOIN stock AS st2 ON sd2.StockID = st2.StockCode
    JOIN model AS m2 ON st2.ModelID = m2.ModelID
    JOIN make AS mk2 ON m2.MakeID = mk2.MakeID
    WHERE 
        YEAR(s2.SaleDate) = 2016
        AND m1.ModelID = m2.ModelID
        AND mk1.MakeID = mk2.MakeID
)
ORDER BY 
    mk1.MakeName, m1.ModelName;



-- Question 7
-- The CEO is convinced that some months are better for sales than others. 
-- She has asked for the sales for July 2015 to check out her hunch. List the vehicles (makes and models) sold during July 2015.
SELECT mk.MakeName, md.ModelName
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE MONTH(s.SaleDate)=7 and YEAR(s.SaleDate) = 2015;

-- Question 8
-- The CEO was disappointed about the sales in July 2015 from the previous question. 
-- Now, she wants to see sales for the entire third quarter of 2015. Generate this list.
-- 2
SELECT mk.MakeName, md.ModelName
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE MONTH(s.SaleDate)IN (7,8,9) and YEAR(s.SaleDate) = 2015;

-- Question 9
-- The sales director wants to do an analysis of sales on a particular day of the week. 
-- So, you are asked to create a list of the vehicles sold on Fridays in the year 2016. Create this list.
SELECT mk.MakeName, md.ModelName/*, DAYNAME(s.SaleDate), dayofweek(s.SaleDate)*/
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE  YEAR(s.SaleDate) = 2016 AND dayofweek(s.SaleDate)=6 /*DAYNAME(s.SaleDate) LIKE '%Friday'*/;


-- Question 10
-- The sales director was pleased with your list of vehicles sold on Fridays from the previous question. 
-- He now wants to take a look at the sales for the 26th week of 2017. Create such a list.
SELECT mk.MakeName, md.ModelName/*, DAYNAME(s.SaleDate), dayofweek(s.SaleDate)*/
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE  YEAR(s.SaleDate) = 2017 AND weekofyear(s.SaleDate) = 26 /*DAYNAME(s.SaleDate) LIKE '%Friday'*/;

-- Question 11
-- The HR manager needs to see how sales vary across days of the week. 
-- He has explained that he needs to forecast staff requirements for busy days. 
-- He wants to see, overall, which were the weekdays where Prestige Cars made the most sales in 2015. Create this list.
SELECT DAYOFWEEK(s.SaleDate) AS WeekdayNumber, COUNT(*) AS SalesCount
FROM Sales s
WHERE YEAR(s.SaleDate) = 2015
GROUP BY WeekdayNumber
ORDER BY SalesCount DESC;


-- Question 12
-- The HR manager liked the information you gave him in the previous question. 
-- However, the list in the previous question was a little too cryptic for him. 
-- He has requested that you display the weekday name instead of the weekday number. 
##Regenerate the list from the previous question with this new request.
SELECT DAYNAME(s.SaleDate) AS Weekday, COUNT(*) AS SalesCount
FROM Sales s
WHERE YEAR(s.SaleDate) = 2015
GROUP BY Weekday
ORDER BY SalesCount DESC;

-- Question 13
-- The sales manager has had another of her ideas. 
-- You can tell by her smile as she walks over to you in the cafeteria while you were having lunch.
--  Her idea, fortunately, is unlikely to spoil your meal. What she wants is the total 
-- and average sales for each day of the year since Prestige Cars started trading. Create this list for her.

SELECT 
    DAYOFYEAR(s.SaleDate) AS 'DayYear',
    SUM(s.TotalSalePrice) AS Total_Sales,
    AVG(s.TotalSalePrice) AS Avg_Sales
FROM
    prestigecars.Sales s
GROUP BY DAYOFYEAR(s.SaleDate)
ORDER BY DAYOFYEAR(s.SaleDate) ASC;

-- Question 14
-- The CEO wants you to give her the total and average sales for each day of the month for all sales, ever. 
-- Create this list for the CEO.

SELECT DAY(s.SaleDate) AS DayOfMonth, 
       SUM(s.TotalSalePrice) AS TotalSales, 
       AVG(s.TotalSalePrice) AS AvgSales
FROM Sales s
GROUP BY DayOfMonth
ORDER BY DayOfMonth;


-- Question 15
-- Just as you are about to leave for home, the CEO flags you down on your way out of the office and insists 
-- that she needs the number of vehicles sold per month in 2018. Create this list showing the month number, month name, 
-- and the number of vehicles sold per month.
SELECT month(s.SaleDate) AS month_number, monthname(s.SaleDate) as month_name,
      COUNT(*) AS SalesCount
FROM Sales s
WHERE YEAR(s.SaleDate) = 2018
GROUP BY month_number, month_name
ORDER BY month_number;

-- Question 16
-- The HR manager has emailed another request. He needs to calculate the final bonus of a salesperson
--  who is leaving the company and consequently needs to see the accumulated sales made by this staff member for a 
-- 75 day period up to July 25, 2015. The salesperson sold Jaguars for Prestige Cars.

##need to check this

SELECT 
    SUM(sd.SalePrice) Total_Sales
FROM
    prestigecars.make ma
        JOIN
    prestigecars.model mo USING (makeID)
        JOIN
    prestigecars.Stock st USING (ModelID)
        JOIN
    prestigecars.Salesdetails sd ON sd.StockID = st.StockCode
        JOIN
    prestigecars.Sales s USING (SalesID)
WHERE
    ma.MakeName = 'jaguar'
        AND (DATEDIFF('2015-07-25', s.SaleDate) BETWEEN 0 AND 75);


-- Question 17
-- The CEO has a single list of all customers. However, there is a problem with the list. 
-- She doesn’t like the address split into many columns. She seeks your help. 
-- Recreate the customer list for the CEO with the address neatly formatted into one column with a 
-- dash (-) between the address and the PostCode. Since the list is for the CEO, you want the list to be as polished as possible.
--  For instance, avoid NULLs in concatenated output.
SELECT CONCAT_WS(' - ', 
                 CONCAT_WS(', ', Address1, Address2, Town), 
                 PostCode) AS FormattedAddress
FROM Customer;

-- Question 18
-- The sales manager now wants a list of all the different make and model combinations that have ever been sold
-- with the total sale price for each combination. However, this time, she wants the make and model output as a single column. 
-- She knows that this is an easy request for you, so she decides to hover near your desk. Write a query to create this list.
SELECT 
    CONCAT(m.MakeName, ' ', mo.ModelName) AS MakeModel,  -- Combine make and model into a single column
    SUM(s.TotalSalePrice) AS TotalSalePrice  -- Calculate the total sale price for each combination from the sales table
FROM 
    prestigecars.sales s
JOIN 
    prestigecars.salesdetails sd ON s.SalesID = sd.SalesID  -- Join sales and salesdetails on SalesID
JOIN 
    prestigecars.stock st ON sd.StockID = st.StockCode  -- Join salesdetails to stock on StockID
JOIN 
    prestigecars.model mo ON st.ModelID = mo.ModelID  -- Join stock to model on ModelID
JOIN 
    prestigecars.make m ON mo.MakeID = m.MakeID  -- Join model to make on MakeID
GROUP BY 
    MakeModel  -- Group the data by the concatenated make and model
ORDER BY 
    TotalSalePrice DESC;  -- Order by total sale price in descending order
-- Question 19
-- The marketing director thinks that some text are too long. She wants you to show the make names as acronyms 
-- using the first three letters of each make in a catalog of products. 
-- Create a list. For your list, create a single column showing the model name with the acronym for the make name in the parentheses.
SELECT DISTINCT
    CONCAT(mo.ModelName,
            ' (',
            SUBSTRING(ma.MakeName, 1, 3),
            ')') AS 'Model (Make)'
FROM
    prestigecars.make ma
        JOIN
    prestigecars.model mo USING (makeID)
        JOIN
    prestigecars.Stock st USING (ModelID);

-- Question 20
-- The finance director wants you to show only the three characters at the right of the invoice number. 
-- Write a query to display this list.
select right(InvoiceNumber,3) as details
from sales;

-- Question 21
-- In the Prestige Cars IT system, the fourth and fifth characters of the invoice number indicate the country 
-- where the vehicles were shipped. Knowing this, the sales director wants to extract only these characters 
-- from the invoice number field in order to analyze destination countries. Create such a list.
select substr(InvoiceNumber,4,2) as country_code
from sales;

-- Question 22
-- The sales director has requested a list of sales where the invoice was paid in Euros. Display this list.
-- NEED TO CHECK
SELECT 
    *
FROM
    prestigecars.sales
WHERE
    SUBSTRING(invoicenumber, 1, 3) = 'EUR';


-- Question 23
-- The sales director now wants to see all the cars shipped to France but made in Italy.
SELECT DISTINCT
    ma.MakeName, mo.ModelName
FROM
    prestigecars.make ma
        JOIN
    prestigecars.model mo USING (makeID)
        JOIN
    prestigecars.Stock st USING (ModelID)
        JOIN
    prestigecars.Salesdetails sd ON sd.StockID = st.StockCode
        JOIN
    prestigecars.Sales s USING (SalesID)
WHERE
    SUBSTRING(s.invoicenumber, 4, 2) = 'FR'
        AND ma.MakeCountry = 'ITA';


-- Question 24
-- The sales director wants a “quick list” of all vehicles sold and the destination country. Generate such a list.
SELECT CONCAT(mk.MakeName, ' ', md.ModelName) AS Vehicle, c.Country AS DestinationCountry
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
JOIN Customer c ON s.CustomerID = c.CustomerID;


-- Question 25
-- The sales director wants you to make some reports that you send directly from MySQL to appear looking slightly easier to read. 
-- She wants you to display the cost from the stock table with a thousands separator and two decimals.
-- Create a report with this column in the requested format.
SELECT *, FORMAT(Cost, 2) AS FormattedCost
FROM STOCK;

-- Question 26
-- The sales director is rushing to a meeting with the CEO. 
-- In a rush she requests you to create a report showing the make, model, and the sale price.
-- The sale price in the report should include thousands separators, two decimals, and a British pound symbol. Create this report.

SELECT mk.MakeName, md.ModelName, CONCAT('£', FORMAT(s.TotalSalePrice, 2)) as sales_price
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
JOIN Customer c ON s.CustomerID = c.CustomerID;

-- Question 27
-- The CEO wants the sale price that you displayed in the previous question (with thousands separators and two decimals)
-- to be now in German style —that is with a period as the thousands separator and a comma as the decimal. Create such a list.
SELECT mk.MakeName, md.ModelName, CONCAT(REPLACE(FORMAT(s.TotalSalePrice, 2), ',', '.'), ' €') as sales_price
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
JOIN Customer c ON s.CustomerID = c.CustomerID;

-- Question 28
-- Suppose the CEO requests a report showing the invoice number and the sale date, but the sale date needs to be in a 
-- specific format —first the day, then the abbreviation for the month, and finally the year in four figures —in this occurrence.
-- Create this report.
select InvoiceNumber, date_format(SaleDate,'%d-%b-%Y')
from sales;


-- Question 29
-- Suppose the CEO requests the report in the previous question showing the invoice number and the sale date,
--  but this time the sale date needs to be in the ISO format. Create this report.
SELECT s.InvoiceNumber, 
       DATE_FORMAT(s.SaleDate, '%Y-%m-%d') AS ISOFormattedDate
FROM Sales s;


-- Question 30
-- The CEO, who is very happy with your work, now requests the report in the previous question to show the invoice number 
-- and the time at which the sale was made. The time needs to be in hh:mm:ss format showing AM or PM after it. Create this report.
SELECT s.InvoiceNumber, 
       DATE_FORMAT(s.SaleDate, '%r') AS SaleTime
FROM Sales s;

-- Question 31
-- Keeping track of costs is an essential part of any business. 
-- Suppose that the finance director of Prestige Cars Ltd. wants a report that flags any car ever bought 
-- where the parts cost was greater than the cost of repairs. In your report, the finance director wants you 
-- to flag such costs with an alert. Write a query to generate such a report.
SELECT st.StockCode, st.ModelID, st.PartsCost, st.RepairsCost,
       CASE
           WHEN st.PartsCost > st.RepairsCost THEN 'Alert!'
           ELSE 'OK'
       END AS CostAlert
FROM Stock st;



-- Question 32
-- The sales director wants some customer feedback. She knows that the sales database has comments from clients in it.
-- But she does not need —or want —to display all the text in the comments. All she wants is to display the first 25 characters
-- and then use ellipses (. . . ) to indicate that the text has been shortened. Write an SQL query to display the comments in this format.
SELECT 
    sales.CustomerID,
    CONCAT(SUBSTRING(stock.BuyerComments, 1, 25), '...') AS ShortenedComments
FROM 
    sales
JOIN 
    salesdetails ON sales.SalesID = salesdetails.SalesID
JOIN 
    stock ON salesdetails.StockID = stock.StockCode
WHERE 
    stock.BuyerComments IS NOT NULL
ORDER BY 
    sales.CustomerID;
-- Question 33
-- This time, the sales director wants you to look at the profit on each car sold and flag any sale 
-- where the profit figure is less than 10 percent of the purchase cost —while at the same time 
-- the repair cost is at least twice the parts cost! Flag such records with a cost alert such as “Warning!”. 
-- Other sales need to be flagged as “OK”. Write a SQL query to generate this report.
SELECT st.StockCode, s.TotalSalePrice, st.Cost, st.RepairsCost, st.PartsCost,
       CASE
           WHEN (s.TotalSalePrice - st.Cost) < 0.1 * st.Cost 
                AND st.RepairsCost >= 2 * st.PartsCost THEN 'Warning!'
           ELSE 'OK'
       END AS CostAlert
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode;

-- Question 34
-- The sales director looks at your previous result and becomes overjoyed thinking that SQL might be able to do much more! 
-- In addition to the cost alert displayed in the previous question, she wants to flag the costs as “Acceptable” 
-- if the net margin is greater than 10 percent, but less than 50 percent of the sale price. 
-- Otherwise, flag the cost as “OK”. Write an SQL query.

SELECT st.StockCode, s.TotalSalePrice, st.Cost,
       CASE
           WHEN (s.TotalSalePrice - st.Cost) > 0.1 * s.TotalSalePrice
                AND (s.TotalSalePrice - st.Cost) < 0.5 * s.TotalSalePrice THEN 'Acceptable'
           ELSE 'OK'
       END AS CostAlert
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode;


-- Question 35
-- The finance director needs to manage exchange rate risk. So, he wants you to add each client’s currency area to the printout.
-- Unfortunately, the database doesn’t have a field that holds the currency area. The currency areas that the director 
-- wants are “Eurozone” for countries in Europe, “Pound Sterling” for the United Kingdom, “Dollar” for the United States, 
-- and “Other” for all other regions. Write an SQL query to generate a report showing the country name and the corresponding 
-- currency region.
SELECT c.CountryName,
       CASE
           WHEN c.CountryName in ( "Belgium" , "Switzerland", "Germany", "Spain", "France", "Italy" ) THEN 'Eurozone'
           WHEN c.CountryName = 'United Kingdom' THEN 'Pound Sterling'
           WHEN c.CountryName = 'United States' THEN 'Dollar'
           ELSE 'Other'
       END AS CurrencyRegion
FROM Country c;

-- select * from country;

-- Question 36
-- The finance director is overjoyed that you solved his previous conundrum and were able to add currency areas to the output. 
-- So, now he wants to take this one step further and has asked you for a report that counts the makes of the car according 
-- to the geographical zone where they were built. Divide the countries in which the cars were built into three regions: 
-- European, American, and British. Create such a report using SQL.
SELECT 
    CASE
        WHEN mk.MakeCountry IN ("GER", "FRA", "ITA") THEN 'European'
        WHEN mk.MakeCountry = 'GBR' THEN 'British'
        WHEN mk.MakeCountry = 'USA' THEN 'American'
        ELSE 'Other'
    END AS Region,
    COUNT(DISTINCT mk.MakeID) AS MakeCount
FROM Make mk
GROUP BY 
 Region;

-- Question 37
-- The sales director would like you to create a report that breaks down total sales values into a set of custom bandings by value
--  (Under 5000, 5000-50000, 50001-100000, 100001- 200000, Over 200000) and show how many vehicles have been sold in each category. 
-- Write an SQL query to create such a report.
SELECT 
    CASE
        WHEN s.TotalSalePrice < 5000 THEN 'Under 5000'
        WHEN s.TotalSalePrice between 5000 and 50000 THEN ' 5000-50000'
        WHEN s.TotalSalePrice between 50001 and 100000 THEN '50001-100000'
        WHEN s.TotalSalePrice between 100001 and 200000 THEN '100001- 200000'
        ELSE 'Over 200000'
    END AS Band,
    COUNT( s.salesid) AS TotalSale
FROM Sales s
GROUP BY 
 Band;


-- Question 38
-- The sales director wants to make it clear in which season a vehicle is sold. The seasons are: Winter (Nov - Feb), Spring (Mar, Apr), 
-- Summer (May, Jun, Jul, Aug), and Autumn (Sept, Oct). Create a report showing the month number, sale date, and the sale season.
SELECT MONTH(s.SaleDate) AS MonthNumber, s.SaleDate,
       CASE
           WHEN MONTH(s.SaleDate) IN (11, 12, 1, 2) THEN 'Winter'
           WHEN MONTH(s.SaleDate) IN (3, 4) THEN 'Spring'
           WHEN MONTH(s.SaleDate) IN (5, 6, 7, 8) THEN 'Summer'
           WHEN MONTH(s.SaleDate) IN (9, 10) THEN 'Autumn'
       END AS SaleSeason
FROM Sales s;


-- Question 39
-- The sales director has asked you to find all the sales for the top five bestselling makes. Write an SQL query to display such a list.
--  Order by sale price descending. Write the query without using any window functions.

SELECT
	*
FROM
	make
  INNER JOIN model ON make.MakeID = model.MakeID
  INNER JOIN stock ON model.ModelID = stock.ModelID
  INNER JOIN salesdetails ON stock.StockCode = salesdetails.StockID
  INNER JOIN (
  	SELECT
			make.MakeID AS bestSellerMakeID,
			COUNT(*) AS SalesCountPerMake
		FROM
			make
		  INNER JOIN model ON make.MakeID = model.MakeID
		  INNER JOIN stock ON model.ModelID = stock.ModelID
		  INNER JOIN salesdetails ON stock.StockCode = salesdetails.StockID
		 GROUP BY 1
		 ORDER BY 2 DESC
		 LIMIT 5
  ) AS bestSellers ON make.MakeID = bestSellers.bestSellerMakeID
ORDER BY salesdetails.SalePrice;






-- Question 40
-- Suppose you are asked to show which colors sell the most. In addition, you also want to find the percentage of cars purchased by value
--  for each color of vehicle. Write an SQL query to show this result set. Write the query without using any window functions.
SELECT st.Color, count(*) AS TotalSales,
 CONCAT(format((SUM(s.TotalSalePrice) * 100.0 / (SELECT SUM(TotalSalePrice) FROM Sales)),2),'%') AS Percentage
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
group by st.Color
ORDER BY TotalSales DESC;





-- Question 41
-- The CEO requests a list of all the vehicle makes and models sold this year but not in the previous year.  
-- Write an SQL query to create this list. Write the query without using any window functions.
SELECT
    ma.MakeName,
    mo.ModelName
FROM 
    sales s
JOIN
    salesdetails sd ON sd.SalesID = s.SalesID
JOIN
    stock st ON st.StockCode = sd.StockID
JOIN 
    model mo ON st.ModelID = mo.ModelID
JOIN 
    make ma ON mo.MakeID = ma.MakeID
WHERE 
    YEAR(s.SaleDate) = 2018
    AND NOT EXISTS (
        SELECT 1
        FROM 
            sales s_sub
        JOIN
            salesdetails sd_sub ON sd_sub.SalesID = s_sub.SalesID
        JOIN
            stock st_sub ON st_sub.StockCode = sd_sub.StockID
        JOIN 
            model mo_sub ON st_sub.ModelID = mo_sub.ModelID
        JOIN 
            make ma_sub ON mo_sub.MakeID = ma_sub.MakeID
        WHERE
            YEAR(s_sub.SaleDate) = 2017
            AND ma.MakeName = ma_sub.MakeName
            AND mo.ModelName = mo_sub.ModelName
    )
ORDER BY
    ma.MakeName,
    mo.ModelName;




-- Question 42
-- The sales manager wants to see a list of all vehicles sold in 2017, with the percent- age of sales each sale represents
--  for the year as well as the deviation of sales from the average sales figure. Hint: To simplify writing this query, 
-- you can use a view named salesbycountry included in the database. You can use the view like the source table. 
-- Write the query without using any window functions.
SELECT 
    s.InvoiceNumber,
    s.SalePrice,
    CONCAT(ROUND((s.SalePrice / (SELECT SUM(SalePrice) FROM salesbycountry WHERE YEAR(SaleDate) = 2017)) * 100, 2), '%') AS PercentageOfTotalSales,
    ROUND(s.SalePrice - (SELECT AVG(SalePrice) FROM salesbycountry WHERE YEAR(SaleDate) = 2017), 2) AS DeviationFromAverage
FROM 
    salesbycountry AS s
WHERE 
    YEAR(s.SaleDate) = 2017
ORDER BY 
    s.SalePrice DESC;


-- Question 43
-- Classifying product sales can be essential for an accurate understanding of which products sell best. At least that is what the CEO 
-- said when she requested a report showing sales for 2017 ranked in order of importance by make. Write an SQL query to generate this report.


SELECT mk.MakeName, SUM(s.TotalSalePrice) AS TotalSales
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
WHERE YEAR(s.SaleDate) = 2017
GROUP BY mk.MakeName
ORDER BY TotalSales DESC;


-- Question 44
-- Buyer psychology is a peculiar thing. To better understand Prestige Cars’ clients, the sales director has decided that she wants 
-- to find the bestselling color for each make sold. Write an SQL query to create this list.
SELECT mk.MakeName, st.Color, COUNT(*) AS SalesCount
FROM Sales s
JOIN SalesDetails sd ON s.SalesID = sd.SalesID
JOIN Stock st ON sd.StockID = st.StockCode
JOIN Model md ON st.ModelID = md.ModelID
JOIN Make mk ON md.MakeID = mk.MakeID
GROUP BY mk.MakeName, st.Color
HAVING COUNT(*) = (
    SELECT MAX(SalesCount)
    FROM (
        SELECT st2.Color, COUNT(*) AS SalesCount
        FROM Sales s2
        JOIN SalesDetails sd2 ON s2.SalesID = sd2.SalesID
        JOIN Stock st2 ON sd2.StockID = st2.StockCode
        JOIN Model md2 ON st2.ModelID = md2.ModelID
        JOIN Make mk2 ON md2.MakeID = mk2.MakeID
        WHERE mk2.MakeName = mk.MakeName
        GROUP BY st2.Color
    ) AS Subquery
);

-- Question 45
-- Prestige Cars caters to a wide range of clients, and the sales director does not want to forget about the 80% that are outside
--  the top 20% of customers. She wants you to take a closer look at the second quintile of customers —those making up the second 20% of sales.
--  Her exact request is this “Find the sales details for the top three selling makes in the second 20% of sales.” 
-- Write an SQL query to create this result set.

WITH CustomerSales AS (
    SELECT 
        c.CustomerID,
        SUM(sd.SalePrice) AS TotalSales
    FROM 
        sales s
    JOIN 
        salesdetails sd ON s.SalesID = sd.SalesID
    JOIN 
        customer c ON s.CustomerID = c.CustomerID
    GROUP BY 
        c.CustomerID
),
RankedCustomers AS (
    SELECT 
        CustomerID,
        TotalSales,
        NTILE(5) OVER (ORDER BY TotalSales DESC) AS Quintile
    FROM 
        CustomerSales
),
SecondQuintileSales AS (
    SELECT 
        s.SalesID,
        mk.MakeName,
        sd.SalePrice
    FROM 
        sales s
    JOIN 
        salesdetails sd ON s.SalesID = sd.SalesID
    JOIN 
        stock st ON sd.StockID = st.StockCode
    JOIN 
        model md ON st.ModelID = md.ModelID
    JOIN 
        make mk ON md.MakeID = mk.MakeID
    JOIN 
        RankedCustomers rc ON s.CustomerID = rc.CustomerID
    WHERE 
        rc.Quintile = 2
),
MakeSales AS (
    SELECT 
        MakeName,
        COUNT(SalesID) AS SalesCount,
        SUM(SalePrice) AS TotalSales
    FROM 
        SecondQuintileSales
    GROUP BY 
        MakeName
),
TopMakes AS (
    SELECT 
        MakeName
    FROM 
        MakeSales
    ORDER BY 
        TotalSales DESC
    LIMIT 3
)
SELECT 
    sq.SalesID,
    sq.MakeName,
    sq.SalePrice
FROM 
    SecondQuintileSales sq
JOIN 
    TopMakes tm ON sq.MakeName = tm.MakeName
ORDER BY 
    sq.MakeName, sq.SalesID;


-- Question 46
-- The CEO is interested in analyzing key metrics over time. Her latest request is that you obtain the total sales to each date 
-- and then display the running total of sales by value for each year. Write an SQL query to fulfill her request.
SELECT s.SaleDate, 
       SUM(s.TotalSalePrice) AS DailyTotal,
       SUM(SUM(s.TotalSalePrice)) OVER (PARTITION BY YEAR(s.SaleDate) ORDER BY s.SaleDate) AS RunningTotal
FROM Sales s
GROUP BY s.SaleDate
ORDER BY s.SaleDate;


-- Question 47
-- Sales at the company are increasing and senior management is convinced that effective analytics is a key factor of corporate success.
--  The latest request to arrive in your inbox is for a report that shows both the first order and the last four sales for each customer. 
-- Write an SQL query to generate this result set.

SELECT
    DISTINCT cu.CustomerID,
    FIRST_VALUE(sd.SalePrice) 
        OVER (PARTITION BY cu.CustomerID 
              ORDER BY s.SaleDate 
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS FirstOrder,
    FIRST_VALUE(sd.SalePrice) 
        OVER (PARTITION BY cu.CustomerID 
              ORDER BY s.SaleDate DESC 
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS LastOrder,
    NTH_VALUE(sd.SalePrice, 2) 
        OVER (PARTITION BY cu.CustomerID 
              ORDER BY s.SaleDate DESC 
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS '2ndLastOrder',
    NTH_VALUE(sd.SalePrice, 3) 
        OVER (PARTITION BY cu.CustomerID 
              ORDER BY s.SaleDate DESC 
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS '3rdLastOrder',
NTH_VALUE(sd.SalePrice, 4) 
        OVER (PARTITION BY cu.CustomerID 
              ORDER BY s.SaleDate DESC 
              RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS '4thLastOrder'
FROM
    customer cu
JOIN
    sales s ON s.CustomerID = cu.CustomerID
JOIN
    salesdetails sd ON sd.SalesID = s.SalesID;



-- Question 48
-- The sales manager is on a mission to find out if certain weekdays are better for sales than others. 
-- Write a query so that she can analyze sales for each day of the week (but not weekends) in 2017 where there was a sale.

SELECT DAYNAME(s.SaleDate) AS Weekday, COUNT(*) AS SalesCount
FROM Sales s
WHERE YEAR(s.SaleDate) = 2017 AND DAYOFWEEK(s.SaleDate) BETWEEN 2 AND 6
GROUP BY Weekday
ORDER BY FIELD(Weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday');


-- Question 49
-- You are doing an amazing job writing queries! The senior management of Prestige Cars is super-impressed with UC Davis MSBA graduates
--  and their ability to write the queries. So, the senior management wants more. The sales manager wants you find the top five vehicles 
-- sold by value (meaning, sale price) in the color of the most expensive car sold. Write a query to generate this list.

WITH MaxPriceColor AS (
    SELECT st.Color
    FROM Sales s
    JOIN SalesDetails sd ON s.SalesID = sd.SalesID
    JOIN Stock st ON sd.StockID = st.StockCode
    ORDER BY s.TotalSalePrice DESC
    LIMIT 1
),
TopVehicles AS (
    SELECT mk.MakeName, md.ModelName, st.Color, s.TotalSalePrice
    FROM Sales s
    JOIN SalesDetails sd ON s.SalesID = sd.SalesID
    JOIN Stock st ON sd.StockID = st.StockCode
    JOIN Model md ON st.ModelID = md.ModelID
    JOIN Make mk ON md.MakeID = mk.MakeID
    WHERE st.Color = (SELECT Color FROM MaxPriceColor)
    ORDER BY s.TotalSalePrice DESC
    LIMIT 5
)
SELECT *
FROM TopVehicles;


-- Question 50
-- The sales manager not only wants to see vehicle sales for each country by value (Total- SalePrice) but also wants to get an idea 
-- of the percentile in the sale hierarchy for each vehicle sold. Write the SQL query to deliver exactly this.
WITH SalesRanked AS (
    SELECT s.SalesID, s.TotalSalePrice, c.Country AS SaleCountry,
           NTILE(100) OVER (PARTITION BY c.Country ORDER BY s.TotalSalePrice DESC) AS Percentile
    FROM Sales s
    JOIN Customer c ON s.CustomerID = c.CustomerID
)
SELECT SaleCountry, SalesID, TotalSalePrice, Percentile
FROM SalesRanked
ORDER BY SaleCountry, Percentile, TotalSalePrice DESC;

-- COLONIAL DATABASE

 USE COLONIAL;
 
-- Question 1
-- List the reservation ID, trip ID, and trip date for reservations for a trip in Maine (ME).
--  Write this query one way using JOIN and two ways using subqueries. 
-- In total, you will write three queries returning the same result set. One query will use only JOINs and no subqueries. 
-- The other two will use subqueries (with or without joins, if applicable.)
SELECT r.ReservationID, r.TripID, r.TripDate
FROM Reservation r
JOIN Trip t ON r.TripID = t.TripID
WHERE t.State = 'ME';

SELECT ReservationID, TripID, TripDate
FROM Reservation
WHERE TripID IN (
    SELECT TripID
    FROM Trip
    WHERE State = 'ME'
);

SELECT r.ReservationID, r.TripID, r.TripDate
FROM Reservation r
JOIN (
    SELECT TripID
    FROM Trip
    WHERE State = 'ME'
) AS MaineTrips ON r.TripID = MaineTrips.TripID;


-- Question 2
-- Find the trip ID and trip name for each trip whose maximum group size is greater than the maximum group size of every trip that has the type Hiking.
SELECT TripID, TripName
FROM Trip
WHERE MaxGrpSize > (
    SELECT MAX(MaxGrpSize)
    FROM Trip
    WHERE Type = 'Hiking'
);


-- Question 3
-- Find the trip ID and trip name for each trip whose maximum group size is greater than the maximum group size of at least one trip that has the type Biking.
SELECT TripID, TripName
FROM Trip
WHERE MaxGrpSize > ANY (
    SELECT MaxGrpSize
    FROM Trip
    WHERE Type = 'Biking'
);

 USE  EntertainmentAgencyExample;
 
-- ENTERTAINMENT AGENCY DATABASE
-- Question 1
-- Display all the entertainers who played engagements for customers Berg and Hallmark. 
-- For this question, write the query in two different ways - each way will use subqueries (with joins.)
--  So in all you will write two different queries - each returning the same resultset.
SELECT DISTINCT e.entertainerid, e.`EntStageName`
FROM Entertainers e
JOIN Engagements eng ON e.EntertainerID = eng.EntertainerID
where eng.customerid in 
 (select CustomerID from Customers WHERE CustLastName in ("Hallmark","Berg")) ;

SELECT DISTINCT e.entertainerid
FROM Entertainers e
JOIN Engagements eng ON e.EntertainerID = eng.EntertainerID
WHERE eng.customerid IN (
    SELECT c.customerid
    FROM Customers c
    WHERE c.CustLastName IN ('Berg', 'Hallmark')
);

SELECT  e.`EntStageName`
FROM Entertainers e
WHERE e.entertainerid IN (
    SELECT eng.entertainerid
    FROM Engagements eng
    WHERE eng.customerid IN (
        SELECT customerid
        FROM Customers
        WHERE CustLastName IN ('Berg', 'Hallmark')
    )
);


-- Question 2
-- What is the average salary of a booking agent?
select avg(Salary) as avg_salary
from Agents ;

-- Question 3
-- Display the engagement numbers for all engagements that have a contract price greater than or equal to the overall average contract price.
SELECT eng.`EngagementNumber`
FROM Engagements eng
WHERE eng.`ContractPrice` >= (
    SELECT AVG(`ContractPrice`)
    FROM Engagements
);


-- Question 4
-- How many of our entertainers are based in Bellevue?
select count(distinct EntertainerID)
from Entertainers
where EntCity ="Bellevue";


-- Question 5
-- Display which engagements occur earliest in October 2017.
SELECT
    *
FROM
    Engagements
WHERE
    StartDate = (
        SELECT
            MIN(StartDate)
        FROM 
            Engagements
        WHERE
            StartDate >= '2017-10-01'
    )
    AND
    StartTime = (
        SELECT
            MIN(StartTime)
        FROM
            Engagements
    )
ORDER BY
    StartDate;


-- Question 6
-- Display all entertainers and the count of each entertainer’s engagements.
--   9
select a.EntertainerID, a.EntStageName , count(b.EngagementNumber) as engagement_count
from `Entertainers` as a left join Engagements as b 
on a.EntertainerID=b.EntertainerID
group by EntertainerID, EntStageName
ORDER BY engagement_count DESC;

-- Question 7
-- List customers who have booked entertainers who play country or country rock. Use subqueries (including JOINS if applicable.)
-- need to check this

SELECT DISTINCT c.CustFirstName, c.CustLastName
FROM Customers c
WHERE c.CustomerID IN (
    SELECT DISTINCT en.CustomerID
    FROM Engagements en
    JOIN Entertainers e ON en.EntertainerID = e.EntertainerID
    WHERE e.EntertainerID IN (
        SELECT es.EntertainerID
        FROM Entertainer_Styles es
        JOIN Musical_Styles ms ON es.StyleID = ms.StyleID
        WHERE ms.StyleName IN ('Country', 'Country Rock')
    )
);

-- Question 8
-- Rewrite 7 using ONLY JOINs and no subqueries.
SELECT DISTINCT c.CustFirstName, c.CustLastName
FROM Customers c
JOIN Engagements en ON c.CustomerID = en.CustomerID
JOIN Entertainers e ON en.EntertainerID = e.EntertainerID
JOIN Entertainer_Styles es ON e.EntertainerID = es.EntertainerID
JOIN Musical_Styles ms ON es.StyleID = ms.StyleID
WHERE ms.StyleName IN ('Country', 'Country Rock');


-- Question 9
-- Find the entertainers who played engagements for customers Berg or Hallmark. Use subqueries (and JOINs.) There is only one query to write.
SELECT DISTINCT e.EntStageName
FROM Entertainers e
WHERE e.EntertainerID IN (
    SELECT DISTINCT en.EntertainerID
    FROM Engagements en
    WHERE en.CustomerID IN (
        SELECT c.CustomerID
        FROM Customers c
        WHERE c.CustLastName IN ('Berg', 'Hallmark')
    )
);


-- Question 10
-- Repeat 9. No subqueries but only JOINs.
SELECT DISTINCT e.EntStageName
FROM Entertainers e
JOIN Engagements en ON e.EntertainerID = en.EntertainerID
JOIN Customers c ON en.CustomerID = c.CustomerID
WHERE c.CustLastName IN ('Berg', 'Hallmark');



-- Question 11
-- Display agents who haven’t booked an entertainer. Answer in two different ways both ways using subqueries. 
-- So, in all, you will write two different queries (each using sub- queries) showing the same result set.
SELECT AgtFirstName, AgtLastName
FROM Agents
WHERE AgentID NOT IN (
    SELECT DISTINCT AgentID 
    FROM Engagements
);

SELECT AgtFirstName, AgtLastName
FROM Agents a
WHERE NOT EXISTS (
    SELECT 1
    FROM Engagements e
    WHERE e.AgentID = a.AgentID
);


-- Question 12
-- Repeat 11 using ONLY JOINs and no subqueries.
SELECT A.AgtFirstName, A.AgtLastName
FROM Agents A
LEFT JOIN Engagements E ON A.AgentID = E.AgentID
WHERE E.AgentID IS NULL;


-- Question 13
-- Display all customers and the date of the last booking each made. Use subqueries.
SELECT CustFirstName, CustLastName, 
       (SELECT MAX(StartDate) 
        FROM Engagements 
        WHERE CustomerID = C.CustomerID) AS LastBookingDate
FROM Customers C;

-- Question 14
-- List the entertainers who played engagements for customer Berg. Write the query in two different ways using subqueries.
-- So, in all, you will write two different queries (each using subqueries) returning the same result set.
SELECT EntStageName
FROM Entertainers
WHERE EntertainerID IN (
    SELECT EntertainerID
    FROM Engagements
    WHERE CustomerID = (
        SELECT CustomerID
        FROM Customers
        WHERE CustLastName = 'Berg'
    )
);

-- 
SELECT EntStageName
FROM Entertainers
WHERE EntertainerID IN (
    SELECT E.EntertainerID
    FROM Engagements E
    JOIN Customers C ON E.CustomerID = C.CustomerID
    WHERE C.CustLastName = 'Berg'
);


-- Question 15
-- Rewrite the query in Question 14 using only JOINs (and no subqueries.)
SELECT DISTINCT E.EntStageName
FROM Entertainers E
JOIN Engagements EN ON E.EntertainerID = EN.EntertainerID
JOIN Customers C ON EN.CustomerID = C.CustomerID
WHERE C.CustLastName = 'Berg';

-- Question 16
-- Using a subquery, list the engagement number and contract price of all engagements that have a contract price 
-- larger than the total amount of all contract prices for the entire month of November 2017.
-- 10
SELECT EngagementNumber, ContractPrice
FROM Engagements
WHERE ContractPrice > (
    SELECT SUM(ContractPrice)
    FROM Engagements
    WHERE StartDate BETWEEN '2017-11-01' AND '2017-11-30'
);


-- Question 17
-- Using a subquery, list the engagement number and contract price of contracts that occur on the earliest date.
SELECT EngagementNumber, ContractPrice
FROM Engagements
WHERE StartDate = (
    SELECT MIN(StartDate)
    FROM Engagements
);


-- Question 18
-- What was the total value of all engagements booked in October 2017?
SELECT SUM(ContractPrice) AS TotalValue
FROM Engagements
WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31';


-- Question 19
-- List customers with no engagement bookings. Use only JOINs and NOT subqueries.
SELECT C.CustFirstName, C.CustLastName
FROM Customers C
LEFT JOIN Engagements E ON C.CustomerID = E.CustomerID
WHERE E.CustomerID IS NULL;



-- Question 20
-- Repeat number 19. Write the query in two different ways returning the same result set. Each way will use a subquery.
SELECT CustFirstName, CustLastName
FROM Customers
WHERE CustomerID NOT IN (
    SELECT CustomerID
    FROM Engagements
);
-- 
SELECT C.CustFirstName, C.CustLastName
FROM Customers C
WHERE NOT EXISTS (
    SELECT 1
    FROM Engagements E
    WHERE C.CustomerID = E.CustomerID
);

-- Question 21
-- For each city where our entertainers live, display how many different musical styles are represented.
--  Display using subtotals and grand totals.
-- need to check this

SELECT e.EntCity, COUNT(DISTINCT es.StyleID) AS StylesRepresented
FROM Entertainers e
JOIN Entertainer_Styles es ON e.EntertainerID = es.EntertainerID
GROUP BY e.EntCity
WITH ROLLUP ;

-- Question 22
-- Which agents booked more than $3,000 worth of business in December 2017?
SELECT A.AgtFirstName, A.AgtLastName, SUM(E.ContractPrice) AS TotalBusiness
FROM Agents A
JOIN Engagements E ON A.AgentID = E.AgentID
WHERE E.StartDate BETWEEN '2017-12-01' AND '2017-12-31'
GROUP BY A.AgentID
HAVING SUM(E.ContractPrice) > 3000;

-- Question 23
-- Display the entertainers who have more than two overlapped bookings.
SELECT e.EntStageName
FROM Entertainers e
JOIN Engagements en1 ON e.EntertainerID = en1.EntertainerID
JOIN Engagements en2 ON e.EntertainerID = en2.EntertainerID
WHERE en1.StartDate <= en2.EndDate AND en2.StartDate <= en1.EndDate AND en1.EngagementNumber != en2.EngagementNumber
GROUP BY e.EntStageName
HAVING COUNT(DISTINCT en1.EngagementNumber) > 2;


-- Question 24
-- Show each agent’s name, the sum of the contract price for the engagements booked, and
-- the agent’s total commission for agents whose total commission is more than $1,000.
SELECT A.AgtFirstName, A.AgtLastName, SUM(E.ContractPrice) AS TotalSales, 
       SUM(E.ContractPrice * A.CommissionRate) AS TotalCommission
FROM Agents A
JOIN Engagements E ON A.AgentID = E.AgentID
GROUP BY A.AgentID
HAVING SUM(E.ContractPrice * A.CommissionRate) > 1000;

-- Question 25
-- Display agents who have never booked a Country or Country Rock group.


SELECT A.AgtFirstName, A.AgtLastName
FROM Agents A
WHERE NOT EXISTS (
    SELECT 1
    FROM Engagements E
    JOIN Entertainers ET ON E.EntertainerID = ET.EntertainerID
    JOIN Entertainer_Styles ES ON ET.EntertainerID = ES.EntertainerID
    JOIN Musical_Styles MS ON ES.StyleID = MS.StyleID
    WHERE MS.StyleName IN ('Country', 'Country Rock') AND E.AgentID = A.AgentID
);


-- Question 26
-- Display the entertainers who did not have a booking in the 90 days preceding May 1,
-- 2018.
Select EntertainerID, EntStageName
FROM entertainmentagencyexample.Entertainers 
WHERE EntertainerID NOT IN (
    Select DISTINCT EntertainerID
    FROM entertainmentagencyexample.Engagements
    WHERE DATEDIFF('2018-05-01', StartDate) BETWEEN 1 AND 90) ;


-- Question 27
-- List the entertainers who play the Jazz, Rhythm and Blues, and Salsa styles. Answer
-- this question using two queries - one with subqueries (with or without joins) and another
-- using only JOINs. In sum, two queries returning the same resultset.

SELECT
    e.EntertainerID,
    e.EntStageName
FROM
    Entertainers e
WHERE
	e.EntertainerID IN (
		SELECT
			es.EntertainerID
		FROM
			Entertainer_Styles es
		JOIN
			Musical_Styles ms ON ms.StyleID = es.StyleID
        GROUP BY
			es.EntertainerID
		HAVING
			SUM(CASE WHEN ms.StyleName IN ('Jazz', 'Rhythm and Blues', 'Salsa') THEN 1 ELSE 0 END) = 3
);

SELECT
    e.EntertainerID,
    e.EntStageName
FROM
    Entertainers e
JOIN
    Entertainer_Styles es ON es.EntertainerID = e.EntertainerID
JOIN
    Musical_Styles ms ON ms.StyleID = es.StyleID
GROUP BY
    e.EntertainerID,
    e.EntStageName
HAVING
    SUM(CASE WHEN ms.StyleName IN ('Jazz', 'Rhythm and Blues', 'Salsa') THEN 1 ELSE 0 END) = 3;




-- Question 28
-- List the customers who have booked Carol Peacock Trio, Caroline Coie Cuartet, and
-- Jazz Persuasion. Write this query in three ways - each way uses subqueries of some sort
-- - all returning the same resultset. In all, you will write three diﬀerent queries, each one
-- returning the same result set.

-- Q28a
SELECT cu.CustomerID, cu.CustFirstName, cu.CustLastName
FROM entertainmentagencyexample.customers cu
WHERE cu.CustomerID IN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Carol Peacock Trio'
)
AND cu.CustomerID IN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Caroline Coie Cuartet'
)
AND cu.CustomerID IN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Jazz Persuasion'
);
-- Q28b
SELECT cu.CustomerID, cu.CustFirstName, cu.CustLastName
FROM entertainmentagencyexample.customers cu
WHERE EXISTS (
    SELECT 1
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE eng.CustomerID = cu.CustomerID
    AND ent.EntStageName = 'Carol Peacock Trio'
)
AND EXISTS (
    SELECT 1
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE eng.CustomerID = cu.CustomerID
    AND ent.EntStageName = 'Caroline Coie Cuartet'
)
AND EXISTS (
    SELECT 1
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE eng.CustomerID = cu.CustomerID
    AND ent.EntStageName = 'Jazz Persuasion'
);
-- Q28c
SELECT distinct cu.CustomerID, cu.CustFirstName, cu.CustLastName
FROM entertainmentagencyexample.customers cu
JOIN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Carol Peacock Trio'
) AS cp ON cu.CustomerID = cp.CustomerID
JOIN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Caroline Coie Cuartet'
) AS cc ON cu.CustomerID = cc.CustomerID
JOIN (
    SELECT eng.CustomerID
    FROM entertainmentagencyexample.engagements eng
    JOIN entertainmentagencyexample.entertainers ent ON eng.EntertainerID = ent.EntertainerID
    WHERE ent.EntStageName = 'Jazz Persuasion'
) AS jp ON cu.CustomerID = jp.CustomerID;


-- Question 29
-- Display customers and groups where the musical styles of the group match all of the
-- musical styles preferred by the customer.
SELECT C.CustFirstName, C.CustLastName, EN.EntStageName
FROM Customers C
JOIN Musical_Preferences MP ON C.CustomerID = MP.CustomerID
JOIN Entertainer_Styles ES ON MP.StyleID = ES.StyleID
JOIN Entertainers EN ON ES.EntertainerID = EN.EntertainerID
GROUP BY C.CustomerID, EN.EntertainerID
HAVING COUNT(DISTINCT MP.StyleID) = (
    SELECT COUNT(DISTINCT StyleID)
    FROM Musical_Preferences
    WHERE CustomerID = C.CustomerID
);


-- Question 30
-- Display the entertainer groups that play in a jazz style and have more than three members.

SELECT E.EntStageName
FROM Entertainers E
JOIN Entertainer_Styles ES ON E.EntertainerID = ES.EntertainerID
JOIN Musical_Styles MS ON ES.StyleID = MS.StyleID
JOIN Entertainer_Members EM ON E.EntertainerID = EM.EntertainerID
WHERE MS.StyleName = 'Jazz'
GROUP BY E.EntStageName
HAVING COUNT(EM.MemberID) > 3;


-- Question 31
-- Display Customers and their preferred styles, but change 50’s, 60’s, 70’s, and 80’s music
-- to ‘Oldies’. This query should return 36 rows. Use CASE...WHEN...THEN.
SELECT C.CustFirstName, C.CustLastName, 
       CASE 
           WHEN MS.StyleName IN ('50’s', '60’s', '70’s', '80’s') THEN 'Oldies'
           ELSE MS.StyleName
       END AS StyleCategory
FROM Customers C
JOIN Musical_Preferences MP ON C.CustomerID = MP.CustomerID
JOIN Musical_Styles MS ON MP.StyleID = MS.StyleID;


-- Question 32
-- Display all the engagements in October 2017 that start between noon and 5 p.m. Note:
-- This database already has fields using the correct datatypes (date and time). Assume
-- the dates and times were stored as strings. Write this query under such an assumption.
-- This query should return 17 rows.

SELECT EngagementNumber, StartDate, StartTime
FROM Engagements
WHERE StartDate BETWEEN '2017-10-01' AND '2017-10-31'
  AND StartTime >= '12:00:00'
  AND StartTime <= '17:00:00';


-- Question 33
-- List entertainers and display whether the entertainer was booked (on the job) on Christ-
-- mas 2017 (December 25th). For this, you have to display three columns – EntertainerID,
-- Entertainer Stage Name, and a new column indicating if the engagement was booked on
-- Christmas or not. The query should return 13 rows. Use CASE...WHEN...THEN.
SELECT E.EntertainerID, E.EntStageName, 
       CASE 
           WHEN EXISTS (
               SELECT 1 
               FROM Engagements EN 
               WHERE EN.EntertainerID = E.EntertainerID 
                 AND EN.StartDate = '2017-12-25'
           ) THEN 'Yes'
           ELSE 'No'
       END AS BookedOnChristmas
FROM Entertainers E;



-- Question 34
-- Find customers who like Jazz but not Standards. The query should return 2 rows. Use
-- CASE...WHEN...THEN.
SELECT C.CustFirstName, C.CustLastName,
       CASE
           WHEN EXISTS (
               SELECT 1
               FROM Musical_Preferences MP
               JOIN Musical_Styles MS ON MP.StyleID = MS.StyleID
               WHERE C.CustomerID = MP.CustomerID AND MS.StyleName = 'Jazz'
           ) AND NOT EXISTS (
               SELECT 1
               FROM Musical_Preferences MP
               JOIN Musical_Styles MS ON MP.StyleID = MS.StyleID
               WHERE C.CustomerID = MP.CustomerID AND MS.StyleName = 'Standards'
           )
           THEN 'Likes Jazz but not Standards'
           ELSE 'Other'
       END AS Preference
FROM Customers C
HAVING Preference = 'Likes Jazz but not Standards';


-- Question 35
-- For each customer, display the CustomerID, name of the customer (First name and Last
-- name separated by a space), StyleName (style of music each customer prefers), and the
-- total number of preferences for each customer.
SELECT C.CustomerID, 
       CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName, 
       MS.StyleName, 
       COUNT(MP.StyleID) AS TotalPreferences
FROM Customers C
JOIN Musical_Preferences MP ON C.CustomerID = MP.CustomerID
JOIN Musical_Styles MS ON MP.StyleID = MS.StyleID
GROUP BY C.CustomerID, MS.StyleName;



-- Question 36
-- For each customer, display the CustomerID, name of the customer (First name and Last
-- name separated by a space), StyleName (style of music each customer prefers), the total
-- number of preferences for each customer, and a running total of the number of styles
-- selected for all the customers. Display the results sorted by Customer Name.
WITH CTE AS (
    SELECT C.CustomerID, 
           CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName, 
           MS.StyleName, 
           COUNT(MP.StyleID) OVER (PARTITION BY C.CustomerID) AS TotalPreferences,
           ROW_NUMBER() OVER (ORDER BY COALESCE(C.CustFirstName, '') || ' ' || COALESCE(C.CustLastName, '')) AS RunningTotal
    FROM Customers C
    JOIN Musical_Preferences MP ON C.CustomerID = MP.CustomerID
    JOIN Musical_Styles MS ON MP.StyleID = MS.StyleID
)
SELECT * FROM CTE ORDER BY FullName;


-- Question 37
-- Display the Customer City, Customer, Number of Preferences of Music Styles, and a
-- running total of preferences for each city overall.
SELECT C.CustCity,
	   CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName,
       COUNT(MP.StyleID) AS NumPreferences,
       SUM(COUNT(MP.StyleID)) OVER (PARTITION BY C.CustCity) AS RunningTotal
FROM Customers C
JOIN Musical_Preferences MP ON C.CustomerID = MP.CustomerID
GROUP BY C.CustCity, C.CustomerID;


-- Question 38
-- Assign a row number for each customer. Display their CustomerID, their combined (First
-- and Last) name, and their state. Return the customers in alphabetical order.
SELECT C.CustomerID,
	   CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName,
       C.CustState,
       ROW_NUMBER() OVER (ORDER BY COALESCE(C.CustFirstName, '') || ' ' || COALESCE(C.CustLastName, '')) AS RowNumber
FROM Customers C;


-- Question 39
-- Assign a number for each customer within each city in each state. Display their Cus-
-- tomer ID, their combined name (First and Last), their city, and their state. Return the
-- customers in alphabetical order.
SELECT C.CustomerID,
       CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName,
       C.CustCity,
       C.CustState,
       ROW_NUMBER() OVER (PARTITION BY C.CustCity, C.CustState ORDER BY COALESCE(C.CustFirstName, '') || ' ' || COALESCE(C.CustLastName, '')) AS CityRank
FROM Customers C;



-- Question 40
-- Show a list of all engagements. Display the start date for each engagement, the name
-- of the customer, and the entertainer. Number the entertainers overall and number the
-- engagements within each start date.
SELECT E.StartDate,
       CONCAT(C.CustFirstName, ' ', C.CustLastName) AS FullName,
       EN.EntStageName,
       ROW_NUMBER() OVER (PARTITION BY E.StartDate ORDER BY EN.EntStageName) AS EngagementNumber
FROM Engagements E
JOIN Customers C ON E.CustomerID = C.CustomerID
JOIN Entertainers EN ON E.EntertainerID = EN.EntertainerID;


-- Question 41
-- Rank all the entertainers based on the number of engagements booked for each. Arrange
-- the entertainers into three groups (buckets). Remember to include any entertainers who
-- haven’t been booked for any engagements.
WITH EngagementCounts AS (
    SELECT EN.EntertainerID, EN.EntStageName, COUNT(E.EngagementNumber) AS NumEngagements
    FROM Entertainers EN
    LEFT JOIN Engagements E ON EN.EntertainerID = E.EntertainerID
    GROUP BY EN.EntertainerID, EN.EntStageName
)
SELECT EntertainerID, EntStageName, NumEngagements,
       NTILE(3) OVER (ORDER BY NumEngagements DESC) AS EngagementRank
FROM EngagementCounts;


-- Question 42
-- Rank all the agents based on the total dollars associated with the engagements that
-- they’ve booked. Make sure to include any agents that haven’t booked any acts.
WITH AgentTotals AS (
    SELECT A.AgentID, A.AgtFirstName, A.AgtLastName, 
           COALESCE(SUM(E.ContractPrice), 0) AS TotalDollars
    FROM Agents A
    LEFT JOIN Engagements E ON A.AgentID = E.AgentID
    GROUP BY A.AgentID
)
SELECT AgentID, AgtFirstName, AgtLastName, TotalDollars,
       RANK() OVER (ORDER BY TotalDollars DESC) AS AgentRank
FROM AgentTotals;


-- Question 43
-- Display a list of all of the engagements our entertainers are booked for. Display the
-- entertainer’s stage name, the customer’s (combined) name, and the start date for each
-- engagements, as well as the total number of engagements booked for each entertainer.
WITH EngagementCounts AS (
    SELECT EN.EntertainerID, EN.EntStageName, COUNT(E.EngagementNumber) AS TotalEngagements
    FROM Entertainers EN
    LEFT JOIN Engagements E ON EN.EntertainerID = E.EntertainerID
    GROUP BY EN.EntertainerID
)
SELECT EN.EntStageName,
       CONCAT(C.CustFirstName, ' ', C.CustLastName) AS CustomerName,
       E.StartDate,
       EC.TotalEngagements
FROM Engagements E
JOIN Customers C ON E.CustomerID = C.CustomerID
JOIN Entertainers EN ON E.EntertainerID = EN.EntertainerID
JOIN EngagementCounts EC ON EN.EntertainerID = EC.EntertainerID;


-- Question 44
-- Show a list of all of the Entertainers and their members. Number each member within
-- a group.
Select ent.EntStageName, CONCAT(m.MbrFirstName, " ",m.MbrLastName) Member_Name , 
						row_number() OVER( PARTITION BY ent.EntStageName ) Member_Num
FROM entertainmentagencyexample.entertainers ent 
JOIN entertainmentagencyexample.entertainer_members em USING(EntertainerID)
JOIN entertainmentagencyexample.members m USING(MemberID) ;


-- ACCOUNTS PAYABLE DATABASE

 USE  accountspayable;

-- Question 1
-- Display the count of unpaid invoices and the total due.
SELECT 
    COUNT(*) AS unpaid_invoices_count,
    SUM(invoice_total - payment_total - credit_total) AS total_due
FROM invoices
WHERE (invoice_total - payment_total - credit_total) > 0;


-- Question 2
-- Display the invoice details for each vendor in CA. Use JOINs and not subqueries.
SELECT 
    vendors.vendor_name,
    invoices.invoice_id,
    invoices.invoice_date,
    invoices.invoice_total
FROM vendors
JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE vendors.vendor_state = 'CA';


-- Question 3
-- Repeat question 2 using subqueries.
SELECT 
    vendors.vendor_name,
    invoices.invoice_id,
    invoices.invoice_date,
    invoices.invoice_total
FROM vendors
JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE vendors.vendor_state = 'CA';


-- Question 4
-- List vendor information for all vendors without invoices. Use JOINs and no subqueries.
SELECT 
    vendors.*
FROM vendors
LEFT JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoices.invoice_id IS NULL;


-- Question 5
-- Repeat 4 using two diﬀerent subqueries returning the same result set. So, in all, you will
-- write two diﬀerent queries here - each using a diﬀerent subquery.

-- Query 1
SELECT *
FROM vendors
WHERE vendor_id NOT IN (
    SELECT DISTINCT vendor_id
    FROM invoices
);

-- Query 2
SELECT *
FROM vendors
WHERE NOT EXISTS (
    SELECT 1
    FROM invoices
    WHERE vendors.vendor_id = invoices.vendor_id
);


-- Question 6
-- List invoice information for invoices with a balance due less than average. Use subqueries.
SELECT *
FROM invoices
WHERE (invoice_total - payment_total - credit_total) < (
    SELECT AVG(invoice_total - payment_total - credit_total)
    FROM invoices
);


-- Question 7
-- List vendor name, invoice number, and invoice total for invoices larger than the largest
-- invoice for vendor 34. Write two diﬀerent subqueries yielding the same result set. So in
-- all you should have two separate queries each returning the same result set.
SELECT 
    vendors.vendor_name,
    invoices.invoice_number,
    invoices.invoice_total
FROM vendors
JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoices.invoice_total > (
    SELECT MAX(invoice_total)
    FROM invoices
    WHERE vendor_id = 34
);

#Ans 7: 
Select v.vendor_name, inv.invoice_number, inv.invoice_total
From accountspayable.vendors v
JOIN accountspayable.invoices inv USING(vendor_id)
WHERE inv.invoice_total > (
				Select MAX(invoice_total)
                FROM accountspayable.invoices i1 
                WHERE i1.vendor_id = 34
	) ;

# b)
Select v.vendor_name, inv.invoice_number, inv.invoice_total
From accountspayable.vendors v
JOIN accountspayable.invoices inv USING(vendor_id)
JOIN (
				Select MAX(invoice_total) as max_total
                FROM accountspayable.invoices i1 
                WHERE i1.vendor_id = 34
	) max_tbl ON inv.invoice_total > max_tbl.max_total  ;


-- Question 8
-- List vendor name, invoice number, and invoice total for invoices smaller than the largest
-- invoice for vendor 115. Use subquery in two diﬀerent ways. So in all there will be two
-- diﬀerent subqueries generating the same result set.

-- Query 1
SELECT 
    vendors.vendor_name,
    invoices.invoice_number,
    invoices.invoice_total
FROM vendors
JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoices.invoice_total < (
    SELECT MAX(invoice_total)
    FROM invoices
    WHERE vendor_id = 115
);

-- Query 2
SELECT 
    vendor_name,
    invoice_number,
    invoice_total
FROM invoices
JOIN vendors ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total < (
    SELECT MAX(invoice_total)
    FROM invoices
    WHERE vendor_id = 115
);

-- Question 9
-- Get the most recent invoice for each vendor. The query should return vendor name and
-- the latest invoice date in the result set. Use a subquery without JOINs.
SELECT 
    vendor_name,
    (SELECT MAX(invoice_date)
     FROM invoices
     WHERE vendors.vendor_id = invoices.vendor_id) AS latest_invoice_date
FROM vendors;


-- Question 10
-- Repeat question 9. Use JOINs and no subqueries.

Select v.vendor_name, MAX(inv.invoice_date)
From accountspayable.vendors v LEFT 
JOIN accountspayable.invoices inv USING(vendor_id)
GROUP BY v.vendor_name ;

-- Question 11
-- Get each invoice amount that is higher than the vendor’s average invoice amount.
SELECT 
    i.invoice_id,
    i.invoice_total,
    v.vendor_name
FROM invoices i
JOIN vendors v ON i.vendor_id = v.vendor_id
WHERE i.invoice_total > (
    SELECT AVG(invoice_total)
    FROM invoices
    WHERE vendor_id = i.vendor_id
);


-- Question 12
-- Get the largest invoice total for the top vendor in each state.
SELECT 
    v.vendor_state,
    v.vendor_name,
    MAX(i.invoice_total) AS largest_invoice_total
FROM vendors v
JOIN invoices i ON v.vendor_id = i.vendor_id
GROUP BY v.vendor_state, v.vendor_name
HAVING MAX(i.invoice_total) = (
    SELECT MAX(invoice_total)
    FROM invoices
    WHERE vendor_id IN (
        SELECT vendor_id
        FROM vendors
        WHERE vendor_state = v.vendor_state
    )
);


-- Question 13
-- Display the GL account description, the number of line items are in each GL account,
-- and the line item amount for accounts which have more than 1 line item.
SELECT 
    g.account_description,
    COUNT(l.line_item_amount) AS line_item_count,
    SUM(l.line_item_amount) AS total_line_item_amount
FROM general_ledger_accounts g
JOIN invoice_line_items l ON g.account_number = l.account_number
GROUP BY g.account_description
HAVING COUNT(l.line_item_amount) > 1;


-- Question 14
-- What is the total amount invoiced for each GL account number. Display the grand total
-- as well.

SELECT 
    gl.account_number,
    SUM(il.line_item_amount) AS total_invoice_amount
FROM 
    general_ledger_accounts gl
JOIN
	invoice_line_items il ON il.account_number = gl.account_number
GROUP BY 
    gl.account_number
UNION ALL
SELECT 
    'Grand Total' AS account_number,
    SUM(il.line_item_amount) AS total_invoice_amount
FROM 
    general_ledger_accounts gl
JOIN
	invoice_line_items il ON il.account_number = gl.account_number;




-- Question 15
-- Which vendors are being paid from more than one account?
SELECT 
    v.vendor_name,
    COUNT(DISTINCT l.account_number) AS account_count
FROM vendors v
JOIN invoices i ON v.vendor_id = i.vendor_id
JOIN invoice_line_items l ON i.invoice_id = l.invoice_id
GROUP BY v.vendor_name
HAVING COUNT(DISTINCT l.account_number) > 1;


-- Question 16
-- What are the last payment date and the total amount due for each vendor with each
-- terms ID. Show the subtotal and grand total at each terms ID level.

SELECT 
    t.Terms_ID,
    i.Vendor_ID,
    MAX(i.Payment_Date) AS Last_Payment_Date,
    SUM(i.Invoice_Total - IFNULL(i.Payment_Total, 0)) AS Total_Amount_Due
FROM Invoices i
JOIN Terms t ON i.Terms_ID = t.Terms_ID
GROUP BY t.Terms_ID, i.Vendor_ID WITH ROLLUP
ORDER BY t.Terms_ID, i.Vendor_ID;



-- grand total by term id
SELECT 
    i.terms_id,
    SUM(i.invoice_total - i.payment_total - i.credit_total) AS grand_total_due
FROM invoices i
GROUP BY i.terms_id;


-- Question 17
-- Display the invoice totals from the invoices column and display all the invoice totals with
-- a $ sign.
SELECT 
    CONCAT('$', FORMAT(invoice_total, 2)) AS invoice_total_with_dollar
FROM invoices;


-- Question 18
-- Write a query to convert invoice date to a date in a character format and invoice total in
-- integer format. Both conversions should be performed in the same query. Please note,
-- then integers have no decimals.
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m-%d') AS formatted_invoice_date,
    FLOOR(invoice_total) AS invoice_total_as_integer
FROM invoices;


-- Question 19
-- In the Invoices table, pad the single-digit and double-digit invoice numbers with one
-- or two zeros before the invoice numbers. For example, the invoice number 1 should be
-- displayed as 001, invoice number 20 should be displayed as 020, etc.
SELECT 
    LPAD(invoice_number, 3, '0') AS padded_invoice_number
FROM invoices;



-- Question 20
-- Write a query to return the invoice total column with one decimal digit and the in-
-- voice total column with no decimal digits.
SELECT 
    ROUND(invoice_total, 1) AS invoice_total_one_decimal,
    ROUND(invoice_total, 0) AS invoice_total_no_decimals
FROM invoices;


-- Question 21
-- Create a new table named Date Sample using the script given below. Download this
-- script from Canvas and run it in your MySQL Workbench on the ap database. Running
-- this will create the Date Sample table in your ap database.
-- Display the start date column, a new date column - call it Format 1 which displays date
-- in this format: Mar/01/86, a new date column - call it Format 2 which displays 3/1/86
-- where the month and days are returned as integers with no leading zeros, and a third
-- date column - call it Format 3 which displays only hours and minutes on a 12-hour clock
-- with an am/pm indicator, for example, 12:00 PM.

USE accountspayable;

CREATE TABLE date_sample (
    date_id INT NOT NULL,
    start_date DATETIME NOT NULL
);

INSERT INTO date_sample VALUES
(1, '1986-03-01 00:00:00'),
(2, '2006-02-28 00:00:00'),
(3, '2010-10-31 00:00:00'),
(4, '2018-02-28 10:00:00'),
(5, '2019-02-28 13:58:32'),
(6, '2019-03-01 09:02:25');

SELECT 
    start_date,
    DATE_FORMAT(start_date, '%b/%d/%y') AS Format_1, -- Example: Mar/01/86
    DATE_FORMAT(start_date, '%c/%e/%y') AS Format_2, -- Example: 3/1/86
    DATE_FORMAT(start_date, '%l:%i %p') AS Format_3  -- Example: 12:00 PM
FROM date_sample;


-- Question 22
-- Write a query that returns the following columns from the Vendors table:
-- • The vendor name column
-- • The vendor name column in all capital letters
-- • The vendor phone column
-- • A column that displays the last four digits of each phone number
-- When you get that working right, add the columns that follow to the result set. This
-- can be more diﬃcult for some students as these columns require use of nested functions.
-- • The vendor phone column with the parts of the number separated by dots as in
-- • The vendor phone column with the parts of the number separated by dots as in
-- 111.111.1111
-- • A column that displays the second word in each vendor name if there is one and blanks
-- if there isn’t

SELECT 
    vendor_name, -- The vendor name column
    UPPER(vendor_name) AS vendor_name_uppercase, -- The vendor name column in all capital letters
    vendor_phone, -- The vendor phone column
    RIGHT(vendor_phone, 4) AS last_four_digits, -- The last four digits of the phone number
    REPLACE(vendor_phone, '-', '.') AS phone_with_dots, -- Phone number with parts separated by dots
    SUBSTRING_INDEX(vendor_name, ' ', 2) AS second_word -- Second word in the vendor name or blank if it doesn't exist
FROM vendors;


-- Question 23
-- Write a query that returns these columns from the Invoices table:
-- • The invoice number column
-- • The invoice date column
-- • The invoice date column plus 30 days
-- • The payment date column
-- • A column named days to pay that shows the number of days between the invoice date
-- and the payment date
-- • The number of the invoice date’s month
-- • The four-digit year of the invoice date
-- When you have this working, add a WHERE clause that retrieves just the invoices for
-- the month of May based on the invoice date, and not the number of the invoice month.

SELECT 
    invoice_number, -- The invoice number column
    invoice_date, -- The invoice date column
    DATE_ADD(invoice_date, INTERVAL 30 DAY) AS invoice_date_plus_30, -- The invoice date plus 30 days
    payment_date, -- The payment date column
    DATEDIFF(payment_date, invoice_date) AS days_to_pay, -- The number of days between the invoice date and the payment date
    MONTH(invoice_date) AS invoice_month, -- The number of the invoice date's month
    YEAR(invoice_date) AS invoice_year -- The four-digit year of the invoice date
FROM invoices
WHERE MONTHNAME(invoice_date) = 'May'; -- Retrieve invoices for the month of May


-- Create a new table named string sample using the script given below. Download this
-- script from Canvas and run it in your MySQL Workbench on the ap database. Running
-- this will create the string sample table in your ap database.
-- Write a query that returns these columns from the string sample table you created with
-- • The emp name column
-- • A column that displays each employee’s first name
-- • A column that displays each employee’s last name
-- Use regular expression functions to get the first and last name. If a name contains three
-- parts, everything after the first part should be considered part of the last name. Be sure
-- to provide for last names with hyphens and apostrophes. You can refer to references
-- online to learn about the regular expressions in MySQL. It is required that you use
-- regular expressions and no other way. Any other way will not earn you credit (partial or
-- full) even if your results are right.

USE accountspayable;

CREATE TABLE string_sample (
    emp_id VARCHAR(3) NOT NULL,
    emp_name VARCHAR(25) NOT NULL
);

INSERT INTO string_sample VALUES
('1', 'Lizbeth Darien'),
('2', 'Darnell O\'Sullivan'),
('17', 'Lance Pinos-Potter'),
('20', 'Jean Paul Renard'),
('3', 'Alisha von Strump');

SELECT 
    emp_name, -- The employee name column
    REGEXP_SUBSTR(emp_name, '^[^ ]+') AS first_name, -- Extracts the first name (everything before the first space)
    REGEXP_SUBSTR(emp_name, '[^ ]+(-|\'| )[^\']*$') AS last_name -- Extracts the last name, handling hyphens and apostrophes
FROM string_sample;


-- Question 25
-- Write a query to display the vendor id, balance due, total balance due for all vendors
-- in the Invoices table, and the total balance due for each vendor in the Invoices table.
-- The total balance due for each vendor should contain a cumulative total by balance due.
-- This query should return 11 rows.
Select vendor_id, (invoice_total - payment_total -credit_total) as Balance_Due,
		SUM(invoice_total - payment_total -credit_total) OVER() Total_Balance,
		SUM(invoice_total - payment_total -credit_total) OVER( ORDER BY (invoice_total - payment_total -credit_total )  ) Cumulative_Bal_due
FROM accountspayable.invoices
WHERE (invoice_total - payment_total -credit_total) > 0 ;

-- Question 26
-- Modify the query in the question above so it includes a column that calculates the average
-- balance due for each vendor in the Invoices table.
-- Q26
Select vendor_id, (invoice_total - payment_total -credit_total) as Balance_Due,
		SUM(invoice_total - payment_total -credit_total) OVER() Total_Balance,
		SUM(invoice_total - payment_total -credit_total) OVER( ORDER BY (invoice_total - payment_total -credit_total )  ) Cumulative_Bal_due,
        AVG(invoice_total - payment_total -credit_total) OVER( ORDER BY (invoice_total - payment_total -credit_total ) ) Cumulative_Avg_Bal
FROM accountspayable.invoices
WHERE (invoice_total - payment_total -credit_total) > 0 ;

-- Question 27
-- Write a query to calculate a moving average of the sum of invoice totals. Display the
-- month of the invoice date, sum of the invoice totals, and the four-month moving average
-- of the invoice totals sorted by invoice month
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS invoice_month,
    SUM(invoice_total) AS monthly_invoice_total,
    AVG(SUM(invoice_total)) OVER (ORDER BY DATE_FORMAT(invoice_date, '%Y-%m') ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS four_month_moving_avg
FROM invoices
GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
ORDER BY invoice_month;

################################################################################################################################
-- SQL RECURSIVE QUERY 1


DROP TABLE IF EXISTS FolderHierarchy;


CREATE TABLE FolderHierarchy
(
ID			INTEGER PRIMARY KEY,
Name		VARCHAR(100),
ParentID	INTEGER
);
---------------------
---------------------
INSERT INTO FolderHierarchy VALUES
(1, 'my_folder', NULL),
(2,	'my_documents', 1),
(3, 'events', 2),
(4, 'meetings', 3),
(5, 'conferences', 3),
(6, 'travel', 3),
(7, 'integration', 3),
(8, 'out_of_town', 4),
(9, 'abroad', 8),
(10, 'in_town', 4);


use ACCOUNTSPAYABLE;

select * from folderhierarchy;


-- Recursive query to construct the folder path
WITH RECURSIVE CTE_FolderPath AS (
    -- Anchor member: Root-level folders
    SELECT 
        ID,
        Name,
        ParentID,
        CONCAT('/', Name, '/') AS Path
    FROM 
        FolderHierarchy
    WHERE 
        ParentID IS NULL
    
    UNION ALL

    -- Recursive member: Append child folder paths
    SELECT 
        F.ID,
        F.Name,
        F.ParentID,
        CONCAT(P.Path, F.Name, '/') AS Path
    FROM 
        FolderHierarchy F
    JOIN 
        CTE_FolderPath P ON F.ParentID = P.ID
)

-- Final output
SELECT 
    ID,
    Name,
    ParentID,
    Path
FROM 
    CTE_FolderPath
ORDER BY 
    ID;

################################################################################################################################
-- SQL RECURSIVE QUERY 2

DROP TABLE IF EXISTS Destination;

CREATE TABLE Destination
(
ID			INTEGER PRIMARY KEY,
Name		VARCHAR(100)
);


---------------------
INSERT INTO Destination VALUES
(1, 'Warsaw'),
(2,	'Berlin'),
(3, 'Bucharest'),
(4, 'Prague');


DROP TABLE IF EXISTS Ticket;


---------------------
CREATE TABLE Ticket
(
CityFrom	INTEGER,
CityTo		INTEGER,
Cost		INTEGER
);


---------------------
INSERT INTO Ticket VALUES
(1, 2, 350),
(1, 3, 80),
(1, 4, 220),
(2, 3, 410),
(2, 4, 230),
(3, 2, 160),
(3, 4, 110),
(4, 2, 140),
(4, 3, 75);



WITH RECURSIVE TravelCTE AS (
    SELECT CityFrom, CityTo, Cost , CONCAT('1','->',CityTo) AS Path, 2 as NumPlacesVisited
    FROM ticket
    WHERE cityFrom = 1

    UNION ALL 
    
    Select t.CityFrom, t.CityTo, (t.Cost + t_cte.Cost) as Cost , 
			CONCAT( t_cte.path, "->" ,t.CityTo ) as path,
            NumPlacesVisited + 1 as NumPlacesVisited
    FROM TravelCTE t_cte
    INNER JOIN ticket t ON t.CityFrom = t_cte.CityTo
    WHERE LOCATE(CONCAT('->', t.CityTo, '->'), Path) = 0
)
SELECT Path, CityTo as LastId, Cost as TotalCost , NumPlacesVisited
FROM TravelCTE
WHERE NumPlacesVisited = 4
ORDER BY Cost DESC;