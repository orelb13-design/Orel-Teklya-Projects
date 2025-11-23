 --SQL Data Analysis- Project 2 by orel teklya

 --1


WITH YearlySales AS (
    SELECT 
        YEAR(LastEditedWhen) AS Year,
        SUM(ExtendedPrice-TaxAmount) AS IncomePerYear,
        COUNT(DISTINCT MONTH(LastEditedWhen)) AS NumberOfDistinctMonths
    FROM Sales.InvoiceLines
    GROUP BY YEAR(LastEditedWhen)
),
LinearIncome AS (
    SELECT 
        Year,
        IncomePerYear,
        NumberOfDistinctMonths,
        (IncomePerYear * 1.0 / NULLIF(NumberOfDistinctMonths, 0)) * 12 AS YearlyLinearIncome
    FROM YearlySales
),
GrowthCalc AS (
    SELECT 
        L1.Year,
        L1.IncomePerYear,
        L1.NumberOfDistinctMonths,
        L1.YearlyLinearIncome,
        ROUND(
            CASE 
                WHEN L2.YearlyLinearIncome IS NULL THEN NULL
                ELSE ((L1.YearlyLinearIncome - L2.YearlyLinearIncome) / L2.YearlyLinearIncome) * 100
            END, 2
        ) AS GrowthRate
    FROM LinearIncome L1
    LEFT JOIN LinearIncome L2 ON L1.Year = L2.Year + 1
)
SELECT *
FROM GrowthCalc
ORDER BY Year


 --2

WITH QuarterlyIncome AS (
    SELECT 
        i.CustomerID,
        YEAR(i.InvoiceDate) AS Year,
        DATEPART(QUARTER, i.InvoiceDate) AS Quarter,
        SUM(il.ExtendedPrice) AS IncomePerYear
    FROM Sales.Invoices i
    JOIN Sales.InvoiceLines il
    ON i.InvoiceID = il.InvoiceID
    GROUP BY i.CustomerID, YEAR(i.InvoiceDate), DATEPART(QUARTER, i.InvoiceDate)
),
RankedIncome AS (
    SELECT 
        CustomerID,
        Year,
        Quarter,
        IncomePerYear,
        ROW_NUMBER() OVER (PARTITION BY Year, Quarter ORDER BY IncomePerYear DESC) AS DNR
    FROM QuarterlyIncome
)
SELECT 
    ri.Year,
    ri.Quarter,
    c.CustomerName,
    ri.IncomePerYear,
        ri.DNR
FROM RankedIncome ri
JOIN Sales.Customers c
ON ri.CustomerID = c.CustomerID
WHERE ri.DNR <= 5
ORDER BY ri.Year, ri.Quarter, ri.DNR

-- 3

with ProductProfit as( 
select s.StockItemID,s.StockItemName, sum(i.ExtendedPrice-i.TaxAmount) as TotalProfit
from Sales.InvoiceLines i join Warehouse.StockItems s
on s.StockItemID=i.StockItemID
group by s.StockItemID, s.StockItemName)
SELECT  TOP (10) TotalProfit, StockItemID, StockItemName
FROM ProductProfit 
ORDER BY TotalProfit DESC; 


-- 4
with NominalProfit as(
select   StockItemID, StockItemName,UnitPrice, RecommendedRetailPrice,(RecommendedRetailPrice-UnitPrice) as NominalProfit, LeadTimeDays
from Warehouse.StockItems
where LeadTimeDays>0
)
    SELECT 
        ROW_NUMBER() OVER (ORDER BY NominalProfit DESC) AS Rn,
     StockItemID, StockItemName,UnitPrice, RecommendedRetailPrice, NominalProfit,
        RANK() OVER(ORDER BY NominalProfit DESC) AS DNR 
    FROM NominalProfit

-- 5
SELECT (cast(su.SupplierID as nvarchar(12))+ ' - ' +su.SupplierName) as SupplierDetails,
    STRING_AGG(CAST(st.StockItemID AS VARCHAR) + ' ' + st.StockItemName, ' , / ' ) AS ProductList
FROM Purchasing.Suppliers su
JOIN Warehouse.StockItems st ON su.SupplierID = st.SupplierID
GROUP BY su.SupplierID, su.SupplierName
ORDER BY su.SupplierID

-- 6
with customers as(
select c.CustomerID,c.CustomerName,i.InvoiceID,c.DeliveryCityID
from Sales.Customers c join Sales.Invoices i 
on c.CustomerID=i.CustomerID),
invoices as(
select cu.InvoiceID, l.ExtendedPrice, cu.CustomerID, cu.DeliveryCityID
from Sales.InvoiceLines l join customers cu
on l.InvoiceID=cu.InvoiceID),
cities as(
select  cus.CustomerID, cus.CustomerName, ci.CityID, ci.StateProvinceID, ci.CityName
from Application.Cities ci join Sales.Customers cus 
on ci.CityID=cus.DeliveryCityID ),
StateProvince as (
select cs.CustomerID,st.CountryID, cs.CityID, cs.CityName
from cities cs join Application.StateProvinces st
on cs.StateProvinceID= st.StateProvinceID),
countries as(
select sta.CityName,sta.CityID, coun.CountryID, coun.CountryName, coun.Continent, coun.Region
from StateProvince sta join Application.Countries coun
on sta.CountryID=coun.CountryID),
conclusion as(
select i.CustomerID,c.CityName, c.CountryName, c.Continent, c.Region, sum(ExtendedPrice) as TotalExtandedPrice, ROW_NUMBER() OVER (ORDER BY sum(ExtendedPrice) DESC) AS Rn
from invoices i join countries c
on i.DeliveryCityID=c.CityID
group by i.CustomerID,c.CityName, c.CountryName, c.Continent, c.Region)
select CustomerID, CityName, CountryName, Continent, Region, TotalExtandedPrice
from conclusion
where Rn<6
order by TotalExtandedPrice desc

-- 7

WITH orders AS (
    SELECT 
        YEAR(o.OrderDate) AS OrderYear,
        MONTH(o.OrderDate) AS OrderMonth,
        SUM(ol.UnitPrice * ol.Quantity) AS MonthlyTotal
    FROM Sales.Orders o
    JOIN Sales.OrderLines ol ON o.OrderID = ol.OrderID
    GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
),
months AS (
    SELECT 
        OrderYear,
        OrderMonth,
        MonthlyTotal,
        SUM(MonthlyTotal) OVER (PARTITION BY OrderYear ORDER BY OrderMonth) AS CumulativeTotal
    FROM orders
),
year_end AS (
    SELECT 
        OrderYear,
        MAX(OrderMonth) AS MaxMonth
    FROM months
    GROUP BY OrderYear
),
totals AS (
    SELECT 
        m.OrderYear,
        NULL AS OrderMonth,
        SUM(m.MonthlyTotal) AS MonthlyTotal,
        MAX(m.CumulativeTotal) AS CumulativeTotal,
        13 AS SortMonth
    FROM months m
    GROUP BY m.OrderYear
)
SELECT 
    OrderYear,
    ISNULL(CAST(OrderMonth AS VARCHAR), 'Grand Total') AS OrderMonth,
    FORMAT(MonthlyTotal, 'N2') AS MonthlyTotal,
    FORMAT(CumulativeTotal, 'N2') AS CumulativeTotal
FROM(SELECT *, OrderMonth AS SortMonth FROM months
    UNION ALL
    SELECT * FROM totals
) AS final
ORDER BY OrderYear, SortMonth

-- 8

select m as 'OrderMonth',[2013],[2014],[2015], [2016]
from (select YEAR(OrderDate) y, MONTH(OrderDate) m,OrderID
      from Sales.Orders) p
pivot (count(orderID) for y in ([2013],[2014],[2015], [2016])) k
order by 1

--9

WITH lastorder AS (
    SELECT 
        c.CustomerID, 
        c.CustomerName, 
        o.OrderDate,  
        LAG(o.OrderDate) OVER (PARTITION BY c.CustomerID ORDER BY o.OrderDate) AS LastOrderDate
    FROM Sales.Orders o JOIN Sales.Customers c ON c.CustomerID = o.CustomerID
),
calculation AS (
    SELECT 
        CustomerID, 
        CustomerName, 
        OrderDate, 
        LastOrderDate, 
        DATEDIFF(DAY, LastOrderDate, OrderDate) AS DaysSinceLastOrder
    FROM lastorder
),
average AS (
    SELECT 
        CustomerID, 
        AVG(DATEDIFF(DAY, LastOrderDate, OrderDate) * 1.0) AS AvgDaysBetweenOrders
    FROM lastorder
    WHERE LastOrderDate IS NOT NULL
    GROUP BY CustomerID
),
final AS (
    SELECT
c.CustomerID, 
        c.CustomerName, 
        c.OrderDate, 
        c.LastOrderDate,
        c.DaysSinceLastOrder, 
        a.AvgDaysBetweenOrders,
        ROUND(a.AvgDaysBetweenOrders, 0) AS AvgDaysBetweenOrder,
        CASE
            WHEN c.DaysSinceLastOrder > 2 * a.AvgDaysBetweenOrders THEN 'Potential Churn'
            ELSE 'Active'
        END AS CustomerStatus
    FROM calculation c 
    LEFT JOIN average a ON c.CustomerID = a.CustomerID
)
SELECT CustomerID, CustomerName, OrderDate, LastOrderDate, DaysSinceLastOrder, AvgDaysBetweenOrder, CustomerStatus
FROM final
ORDER BY CustomerID;

--10

WITH NormalizedCustomers AS (
    SELECT 
        CustomerID,
        CASE 
            WHEN CustomerName LIKE 'Wingtip%' OR CustomerName LIKE 'Tailspin%' THEN 8
            ELSE CustomerCategoryID
        END AS NormalizedCategoryID
    FROM Sales.Customers),
CustomerPerCategory AS (
    SELECT  cc.CustomerCategoryName,COUNT(DISTINCT nc.CustomerID) AS CustomerCOUNT
    FROM NormalizedCustomers nc JOIN Sales.CustomerCategories cc 
      ON nc.NormalizedCategoryID = cc.CustomerCategoryID
    GROUP BY cc.CustomerCategoryName),
TotalCustomers AS (
    SELECT COUNT(DISTINCT CustomerID) AS TotalCustCount
    FROM Sales.Customers
)
SELECT 
    cpc.CustomerCategoryName,
    cpc.CustomerCOUNT,
    tc.TotalCustCount,
    FORMAT(100.0 * cpc.CustomerCOUNT / tc.TotalCustCount, 'N2') + '%' AS DistributionFactor
FROM CustomerPerCategory cpc
CROSS JOIN TotalCustomers tc
ORDER BY DistributionFactor