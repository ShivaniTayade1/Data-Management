-- Colonial Database

SELECT 
    tripname
FROM
    colonial.trip
WHERE
    season = 'Late Spring';

-- Q2
SELECT 
    tripname
FROM
    colonial.trip
WHERE
    (MaxGrpSize > 10) OR (State = 'VT');

-- Q3
SELECT 
    tripname
FROM
    colonial.trip
WHERE
    season IN ('Late Fall' , 'Early Fall');

-- Q4
SELECT 
    COUNT(*) AS num_trips
FROM
    colonial.trip
WHERE
    State IN ('VT' , 'CT');

-- Q5
SELECT 
    tripname
FROM
    colonial.trip
WHERE
    State <> 'NH';

-- Q6
SELECT 
    tripname, StartLocation
FROM
    colonial.trip
WHERE
    Type = 'Biking';

-- Q7
SELECT 
    tripname
FROM
    colonial.trip
WHERE
    (Type = 'Hiking') AND (Distance > 6)
ORDER BY TripName;

-- Q8
SELECT 
    tripname
FROM
    colonial.trip
WHERE
    (Type = 'Paddling') OR (State = 'VT');

-- Q9
SELECT 
    COUNT(*) AS num_trips
FROM
    colonial.trip
WHERE
    Type IN ('Biking' , 'Hiking');

-- Q10
SELECT 
    tripname, State
FROM
    colonial.trip
WHERE
    (Season = 'Summer')
ORDER BY State , tripname;

-- Q11
SELECT 
    t.tripname
FROM
    colonial.trip t
        JOIN
    colonial.tripguides tg ON t.TripID = tg.TripID
        JOIN
    colonial.guide g ON tg.guidenum = g.guidenum
WHERE
    (g.FirstName = 'Miles')
        AND (g.LastName = 'Abrams');

-- Q12
SELECT 
    t.tripname
FROM
    colonial.trip t
        JOIN
    colonial.tripguides tg ON t.TripID = tg.TripID
        JOIN
    colonial.guide g ON tg.guidenum = g.guidenum
WHERE
    (g.FirstName = 'Rita')
        AND (g.LastName = 'Boyers')
        AND (t.Type = 'Biking');


-- Q13
SELECT 
    c.LastName, t.tripname, t.StartLocation, r.TripDate
FROM
    colonial.trip t
        JOIN
    colonial.reservation r ON t.TripID = r.TripID
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
WHERE
    r.TripDate = '2018-07-23';

-- Q14
SELECT 
    COUNT(*) AS num_reservations
FROM
    colonial.reservation
WHERE
    (TripPrice > 50) AND (TripPrice < 100);


-- Q15
SELECT 
    c.LastName, t.tripname, t.Type
FROM
    colonial.trip t
        JOIN
    colonial.reservation r ON t.TripID = r.TripID
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
WHERE
    (r.TripPrice > 100);


-- Q16
SELECT 
    c.LastName
FROM
    colonial.trip t
        JOIN
    colonial.reservation r ON t.TripID = r.TripID
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
WHERE
    (t.State = 'ME');

-- Q17
SELECT 
    State, COUNT(*) AS num_trips
FROM
    colonial.trip
GROUP BY State
ORDER BY State;

-- Q18
SELECT 
    r.ReservationID, c.LastName, t.tripname
FROM
    colonial.trip t
        JOIN
    colonial.reservation r ON t.TripID = r.TripID
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
WHERE
    (r.NumPersons > 4);

-- Q19
SELECT 
    t.tripname, g.FirstName, g.LastName
FROM
    colonial.trip t
        JOIN
    colonial.tripguides tg ON t.TripID = tg.TripID
        JOIN
    colonial.guide g ON tg.guidenum = g.guidenum
WHERE
    (t.State = 'NH');


-- Q20
SELECT 
    r.ReservationID,
    c.CustomerNum,
    c.LastName,
    c.FirstName,
    r.TripDate
FROM
    colonial.reservation r
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
WHERE
    DATE_FORMAT(r.TripDate, '%Y-%m') = '2018-07';


-- Q21
SELECT 
    r.ReservationID,
    c.CustomerNum,
    c.LastName,
    c.FirstName,
    (r.TripPrice + r.OtherFees) * r.NumPersons AS Total_Cost
FROM
    colonial.reservation r
        JOIN
    colonial.customer c ON r.CustomerNum = c.CustomerNum
        JOIN
    colonial.trip t ON t.TripID = r.TripID
WHERE
    r.NumPersons > 4;

-- Q22
SELECT 
    FirstName
FROM
    colonial.customer
WHERE
    (FirstName LIKE 'S%')
        OR (FirstName LIKE 'L%')
ORDER BY FirstName;


-- Q23

SELECT 
    t.tripname, r.TripPrice
FROM
    colonial.trip t
        JOIN
    colonial.reservation r ON t.TripID = r.TripID
WHERE
    (r.TripPrice >= 30)
        AND (r.TripPrice <= 50);


-- Q24
SELECT COUNT(Trip.TripName) AS TripCount
FROM colonial.Trip
JOIN colonial.Reservation ON Reservation.TripID = Trip.TripID
WHERE Reservation.TripPrice BETWEEN 30 AND 50;

-- Q25
SELECT 
    t.TripID, t.tripname, r.ReservationID
FROM
    colonial.trip t
        LEFT JOIN
    colonial.reservation r ON t.TripID = r.TripID
WHERE
    r.ReservationID IS NULL;


-- Q26
SELECT DISTINCT
    t1.TripID, t1.TripName, t1.StartLocation, t1.State
FROM
    colonial.trip t1
        JOIN
    colonial.trip t2 ON t1.StartLocation = t2.StartLocation
WHERE
    t1.TripID <> t2.tripID
ORDER BY t1.StartLocation , t1.TripName;


-- Q27
SELECT distinct 
    customer.CustomerNum, 
    customer.LastName AS CustomerLastName, 
    customer.FirstName AS CustomerFirstName, 
    customer.State
FROM colonial.customer
LEFT JOIN colonial.reservation ON customer.CustomerNum = reservation.CustomerNum
WHERE customer.State = 'NJ' OR reservation.CustomerNum IS NOT NULL;


-- Q28
SELECT 
    g.guidenum, g.LastName, g.FirstName, ct.TripID
FROM
    colonial.guide g
        LEFT JOIN
    colonial.tripguides ct ON g.guidenum = ct.guidenum
WHERE
    ct.TripID IS NULL;


-- Q29
#Ans 29: 
SELECT G1.GuideNum, G1.FirstName, G1.LastName, G1.State, G2.GuideNum AS PairGuideNum, G2.FirstName AS PairFirstName, G2.LastName AS PairLastName
FROM colonial.Guide G1
JOIN colonial.Guide G2 ON G1.State = G2.State AND G1.GuideNum < G2.GuideNum;


#Ans 30:
SELECT G1.GuideNum, G1.FirstName, G1.LastName, G1.City, G2.GuideNum AS PairGuideNum, G2.FirstName AS PairFirstName, G2.LastName AS PairLastName
FROM colonial.Guide G1
JOIN colonial.Guide G2 ON G1.City = G2.City AND G1.GuideNum < G2.GuideNum;


-- ACCOUNTS PAYABLE DATABASE

SELECT 
    *
FROM
    accountspayable.invoices;

-- Q2
SELECT 
    invoice_number, invoice_date, invoice_total
FROM
    accountspayable.invoices
ORDER BY invoice_total DESC;

-- Q3
SELECT 
    invoice_number, invoice_date, invoice_total
FROM
    accountspayable.invoices
WHERE
    DATE_FORMAT(invoice_date, '%m') = '06';

-- Q4
SELECT 
    vendor_id,
    vendor_name,
    vendor_contact_last_name,
    vendor_contact_first_name
FROM
    accountspayable.vendors
ORDER BY vendor_contact_last_name , vendor_contact_first_name;


-- Q5
SELECT 
    vendor_id,
    vendor_name,
    vendor_contact_last_name,
    vendor_contact_first_name
FROM
    accountspayable.vendors
WHERE
    (vendor_contact_last_name LIKE 'A%')
        OR (vendor_contact_last_name LIKE 'B%')
        OR (vendor_contact_last_name LIKE 'C%')
        OR (vendor_contact_last_name LIKE 'E%')
ORDER BY vendor_contact_last_name , vendor_contact_first_name;


-- Q6
SELECT 
    invoice_due_date, 1.1 * invoice_total AS Inv_Total
FROM
    accountspayable.invoices
WHERE
    (1.1 * invoice_total >= 500)
        AND (1.1 * invoice_total <= 1000)
ORDER BY invoice_due_date DESC;


-- Q7
SELECT 
    invoice_number,
    invoice_total,
    payment_total,
    (invoice_total - payment_total - credit_total) AS balance_due
FROM
    accountspayable.invoices
WHERE
    (invoice_total - payment_total - credit_total) >= 50
ORDER BY (invoice_total - payment_total - credit_total) DESC
LIMIT 5;


-- Q8
SELECT 
    invoice_number,
    invoice_total,
    payment_total,
    (invoice_total - payment_total - credit_total) AS balance_due
FROM
    accountspayable.invoices
WHERE
    (invoice_total - payment_total - credit_total) > 0
ORDER BY (invoice_total - payment_total - credit_total) DESC;


-- Q9
SELECT DISTINCT
    v.vendor_name
FROM
    accountspayable.invoices AS i
        JOIN
    accountspayable.vendors v ON i.vendor_id = v.vendor_id
WHERE
    (invoice_total - payment_total - credit_total) > 0
ORDER BY v.vendor_name;


-- Q10
SELECT 
    v.vendor_name,
    v.default_account_number,
    gl.account_description
FROM
    accountspayable.vendors v
        JOIN
    accountspayable.general_ledger_accounts gl ON v.default_account_number = gl.account_number
ORDER BY v.default_account_number;


-- Q11

SELECT vendors.vendor_id, vendors.vendor_name, invoices.invoice_id, invoices.invoice_date, invoices.invoice_total
FROM accountspayable.vendors
JOIN accountspayable.invoices ON vendors.vendor_id = invoices.vendor_id;

-- Q12
SELECT DISTINCT
    v2.vendor_name,
    v2.vendor_contact_first_name,
    v2.vendor_contact_last_name
FROM
    accountspayable.vendors v1
        INNER JOIN
    accountspayable.vendors v2 ON v1.vendor_contact_last_name = v2.vendor_contact_last_name
WHERE
    v2.vendor_name <> v1.vendor_name
ORDER BY v2.vendor_contact_last_name , v2.vendor_name;

-- Q13
SELECT 
    gl.account_number, gl.account_description
FROM
    accountspayable.vendors v
        RIGHT JOIN
    accountspayable.general_ledger_accounts gl ON v.default_account_number = gl.account_number
WHERE
    v.default_account_number IS NULL
ORDER BY gl.account_number;

-- Q14
SELECT 
    vendor_name AS 'Vendor Name',
    IF(vendor_state = 'CA',
        'CA',
        'Outside CA') AS 'Vendor State'
FROM
    accountspayable.vendors
ORDER BY vendor_name;


-- Prestige Cars Database

SELECT 
    CountryName, SalesRegion
FROM
    prestigecars.country;

-- Q2
SELECT 
    st.StockCode, ma.MakeName, mo.ModelName, st.Cost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;

-- Q3
SELECT DISTINCT
    co.CountryName
FROM
    prestigecars.customer cust
        JOIN
    prestigecars.country co ON cust.Country = co.CountryISO2;

-- Q4
SELECT 
    st.StockCode, ma.MakeName, mo.ModelName, st.Cost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;


-- Q5
SELECT 
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    sd.SalePrice,
    sd.lineitemdiscount
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;


-- Q6
SELECT 
    ma.MakeName, mo.ModelName
FROM
    prestigecars.model mo
        RIGHT JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    mo.ModelName IS NULL;

-- Q7
SELECT 
    s.StaffName, s.Department, m.StaffName AS Manager_Name
FROM
    prestigecars.staff s
        LEFT JOIN
    prestigecars.staff m ON s.ManagerID = m.StaffID;


-- Q8
SELECT 
    ma.MakeName,
    mo.ModelName,
    sd.SalePrice,
    sc.CategoryDescription
FROM
    prestigecars.sales s
        JOIN
    prestigecars.salesdetails sd ON s.SalesID = sd.SalesID
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON st.ModelID = mo.ModelID
        JOIN
    prestigecars.make ma ON ma.MakeID = mo.MakeID
        JOIN
    prestigecars.salescategory sc ON sd.SalePrice BETWEEN sc.LowerThreshold AND sc.UpperThreshold
ORDER BY sd.SalePrice;


-- Q9 (Cross Join with join to remove makes which have not been sold) *****
SELECT 
    C.COUNTRYNAME, MA.MAKENAME
FROM
	prestigecars.COUNTRY C
   CROSS JOIN 
   prestigecars.MAKE MA
   ORDER BY C.COUNTRYNAME,MA.MAKENAME;
   ;

-- Q10
SELECT 
    ma.MakeName, mo.ModelName
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;

-- Q11 
SELECT 
    st.StockCode, ma.MakeName, mo.ModelName, sa.SaleDate
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
        JOIN
    prestigecars.sales sa ON sa.SalesID = sd.SalesID;

-- Q12
SELECT 
    model.ModelName, 
    stock.Color
FROM stock
JOIN model ON stock.ModelID = model.ModelID
WHERE stock.Color IN ('Red', 'Green', 'Blue');

-- Q13
SELECT DISTINCT
    ma.MakeName
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    ma.MakeName <> 'ferrari';

-- Q14
SELECT DISTINCT
    ma.MakeName
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    ma.MakeName NOT IN ('Porsche' , 'Bentley', 'Aston Martin');


-- Q15
SELECT 
    st.StockCode, ma.MakeName, mo.ModelName, st.Cost
FROM
    prestigecars.salesdetails sd
        RIGHT JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    st.Cost > 50000
ORDER BY sd.SalePrice , st.Cost DESC;


-- Q16
SELECT 
    ma.MakeName
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    (st.PartsCost >= 1000)
        AND (st.PartsCost <= 2000);


-- Q17
SELECT 
    ma.MakeName, mo.ModelName
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    st.IsRHD = 1;


-- Q18
SELECT 
    ma.MakeName
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    (ma.MakeName <> 'Bentley')
        AND (st.color IN ('red' , 'green', 'blue'));


-- Q19
SELECT 
    make.MakeName, 
    model.ModelName, 
    stock.Color, 
    stock.RepairsCost, 
    stock.PartsCost
FROM stock
JOIN model ON stock.ModelID = model.ModelID
JOIN make ON model.MakeID = make.MakeID
WHERE stock.Color = 'Red' AND (stock.RepairsCost > 1000 OR stock.PartsCost > 1000);


-- Q20
SELECT 
    ma.MakeName,
    mo.ModelName,
    st.color,
    st.PartsCost,
    st.RepairsCost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    ((ma.MakeName = 'Rolls Royce')
        AND (mo.ModelName = 'Phantom')
        AND (st.color IN ('red' , 'green', 'blue')))
        OR ((st.PartsCost > 5500)
        AND (st.RepairsCost > 5500));


-- Q21
SELECT 
    *
FROM
    prestigecars.stock
WHERE
    BINARY color = 'Dark purple';


-- Q22
SELECT 
    CustomerName
FROM
    prestigecars.customer
WHERE
    CustomerName LIKE '%Pete%';


-- Q23
SELECT 
    MakeName
FROM
    prestigecars.make
WHERE
    BINARY MakeName LIKE '%L%';


-- Q24
SELECT DISTINCT
    mo.ModelName,
    sa.invoicenumber,
    SUBSTRING(invoicenumber, 4, 2) AS Country_Code
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
        JOIN
    prestigecars.sales sa ON sa.SalesID = sd.SalesID
WHERE
    SUBSTRING(sa.invoicenumber, 4, 2) = 'FR'
ORDER BY sa.invoicenumber , mo.ModelName;


-- Q25
SELECT 
    CustomerID, CustomerName, PostCode
FROM
    prestigecars.customer
WHERE
    PostCode IS NULL;


-- Q26
SELECT DISTINCT
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    st.PartsCost,
    st.RepairsCost,
    st.Cost,
    st.TransportInCost,
    (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) AS 'Cost of Sales'
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;


-- Q27
SELECT DISTINCT
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    sd.SalePrice - (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) AS 'Net Margin'
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;

-- Q28
SELECT DISTINCT
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) / (sd.SalePrice) AS 'Cost / Sales Ratio'
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;


-- Q29
SELECT DISTINCT
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    1.05 * sd.SalePrice - (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) AS 'Improved Net Margins'
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID;


-- Q30
SELECT DISTINCT
    st.StockCode,
    ma.MakeName,
    mo.ModelName,
    100 * ((sd.SalePrice) / (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) - 1) AS Percentage_Profits
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
ORDER BY Percentage_Profits DESC
LIMIT 50;


-- Q31 

SELECT DISTINCT MK.MakeName, MD.ModelName, SD.SalePrice
FROM prestigecars.make AS MK
JOIN prestigecars.model AS MD USING(MakeID)
JOIN prestigecars.stock AS ST USING(ModelID)
JOIN prestigecars.salesdetails SD ON ST.StockCode = SD.StockID
WHERE SD.SalePrice - 
             (ST.Cost + ST.RepairsCost + IFNULL(ST.PartsCost, 0)
              + ST.TransportInCost) > 5000
ORDER BY MK.MakeName, MD.ModelName, SD.SalePrice DESC;



-- Q32 

SELECT DISTINCT
    ma.MakeName, mo.ModelName
FROM
    prestigecars.salesdetails sd
        JOIN
    prestigecars.stock st ON sd.StockID = st.StockCode
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
WHERE
    ((sd.SalePrice - (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) > 5000)
        AND (st.color = 'Red'
        AND sd.lineitemdiscount >= 1000))
        OR (st.PartsCost > 500
        AND st.RepairsCost > 500);

-- Q33
SELECT 
    SUM(salesdetails.SalePrice) AS TotalSales,
    SUM(stock.Cost + stock.RepairsCost + stock.PartsCost + stock.TransportInCost) AS TotalCost,
    SUM(salesdetails.SalePrice - (stock.Cost + stock.RepairsCost + stock.PartsCost + stock.TransportInCost)) AS GrossProfit
FROM salesdetails
JOIN stock ON salesdetails.StockID = stock.StockCode;


-- Q34
SELECT 
    mo.ModelName, SUM(st.Cost) AS Cost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
GROUP BY mo.ModelName;


-- Q35
SELECT 
    ma.MakeName, mo.ModelName, SUM(st.Cost) AS Cost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
GROUP BY ma.MakeName , mo.ModelName;


-- Q36
SELECT 
    ma.MakeName,
    mo.ModelName,
    SUM(st.Cost) / COUNT(*) AS Avg_Purchase_Cost
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
GROUP BY ma.MakeName , mo.ModelName;


-- Q37
SELECT 
    ma.MakeName, mo.ModelName, COUNT(*) AS Num_Sold
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
        JOIN
    prestigecars.salesdetails sd ON sd.StockID = st.StockCode
GROUP BY ma.MakeName , mo.ModelName;

-- Q38
SELECT 
    COUNT(DISTINCT c.Country) AS num_countries
FROM
    prestigecars.customer c
        JOIN
    prestigecars.sales s ON c.CustomerID = s.SalesID;

-- Q39
SELECT 
    ma.MakeName,
    mo.ModelName,
    MAX(sd.SalePrice) AS Top_Sale_Price,
    MIN(sd.SalePrice) AS Bottom_Sale_Price
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
        JOIN
    prestigecars.salesdetails sd ON sd.StockID = st.StockCode
GROUP BY ma.MakeName , mo.ModelName;

-- Q40
SELECT 
    ma.MakeName, COUNT(*) AS Num_Red_Sold
FROM
    prestigecars.stock st
        JOIN
    prestigecars.model mo ON mo.ModelID = st.ModelID
        JOIN
    prestigecars.make ma ON ma.makeID = mo.makeID
        JOIN
    prestigecars.salesdetails sd ON sd.StockID = st.StockCode
WHERE
    st.color = 'red'
GROUP BY ma.MakeName;


-- Q41
SELECT 
    co.CountryName, COUNT(*) AS Cars_Sold
FROM
    prestigecars.customer cust
        JOIN
    prestigecars.sales s ON cust.CustomerID = s.CustomerID
        JOIN
    prestigecars.salesdetails sd ON s.SalesID = sd.SalesID
        JOIN
    prestigecars.country co ON cust.Country = co.CountryISO2
GROUP BY cust.Country
HAVING COUNT(*) > 50;


-- Q42
SELECT 
    cust.CustomerID, cust.CustomerName, COUNT(*) AS NumberOfCars
FROM
    prestigecars.customer cust
        JOIN
    prestigecars.sales s ON cust.CustomerID = s.CustomerID
        JOIN
    prestigecars.salesdetails sd ON s.SalesID = sd.SalesID
        JOIN
    prestigecars.Stock st ON st.StockCode = sd.StockID
WHERE
    (sd.SalePrice - (COALESCE(st.PartsCost, 0) + COALESCE(st.RepairsCost, 0) + COALESCE(st.Cost, 0) + COALESCE(st.TransportInCost, 0)) > 5000)
GROUP BY cust.CustomerID
HAVING COUNT(*) >= 3;


-- Q43
SELECT 
    make.MakeName, 
    SUM(salesdetails.SalePrice - (stock.Cost + stock.RepairsCost + stock.PartsCost + stock.TransportInCost)) AS TotalProfit
FROM salesdetails
JOIN stock ON salesdetails.StockID = stock.StockCode
JOIN model ON stock.ModelID = model.ModelID
JOIN make ON model.MakeID = make.MakeID
GROUP BY make.MakeName
ORDER BY TotalProfit DESC
LIMIT 3;