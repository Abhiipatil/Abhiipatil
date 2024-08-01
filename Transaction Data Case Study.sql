create database Exam
use Exam

SELECT * FROM Transaction_data
SELECT * FROM CustData

------Drop the observations(rows) if MCN is null or storeID is null or Cash_Memo_No------

delete from Transaction_data
where Cash_Memo_No is null or Store_ID is null or MCN is null



----Join both tables considering Transaction table as base table (Hint: left Join – Key variable is MCN/CustomerID) and name the table as Final_Data

select * into Final_Data from (select * from Transaction_data t 
left join CustData c on t.MCN = c.[Cust_ID]) as A

select * from [dbo].[Final_Data]


-----Calculate the discount variable using formula (Discount = TotalAmount-SaleAmount)------

ALTER TABLE Final_Data
ADD Discount float


update Final_Data
set Discount = [TotalAmount] - [SaleAmount]

Select count(distinct MCN) from Final_Data


----Q1.Count the number of observations having any of the variables having null value/missing values?

Select
count(*) from Final_Data
where [ItemCount] IS NULL OR
[TransactionDate] IS NULL OR
[TotalAmount] IS NULL OR
[SaleAmount] IS NULL OR
[SalePercent] IS NULL OR
[Cash_Memo_No] IS NULL OR
[Dep1Amount] IS NULL OR
[Dep2Amount] IS NULL OR
[Dep3Amount] IS NULL OR
[Dep4Amount] IS NULL OR
[Store_ID] IS NULL OR
[MCN] IS NULL OR
[CustID] IS NULL OR
[Gender] IS NULL OR
[Location] IS NULL OR
[Age] IS NULL OR
[Cust_seg] IS NULL OR
[Sample_flag] IS NULL OR
[Cust_ID] IS NULL OR
[Discount] is null




----Q2.How many customers have shopped? (Hint: Distinct Customers)
SELECT COUNT(DISTINCT[Cust_ID] ) AS DISTINCT_CUSTOMER_COUNT
FROM [Final_Data]

 

----Q3.How many shoppers (customers) visiting more than 1 store?

Select Count(*) as Repeating_Customer from
( select [Cust_ID], Store_Id, COUNT([Cust_ID]) AS CUSTOMER_COUNT FROM Final_Data
 GROUP BY [Cust_ID], Store_Id
 HAVING COUNT([Store_ID]) > 1) as A



 ---- Q4.What is the distribution of shoppers by day of the week? How the customer shopping behavior on each day of week? 
 --(Hint: You are required to calculate number of customers, number of transactions, total sale amount, total quantity etc.. by each week day)

 Select Datepart( WEEKDAY, TransactionDate) as weekdays,
 Count(distinct (Cust_ID) ) as Cust_Count, 
 Count([Cash_Memo_No]) as Transaction_count, 
 Round(Sum(SaleAmount),2) as Total_sales_Amount, 
 Sum([ItemCount]) as Total_Quantity
 from Final_Data
 group by Datepart([WEEKDAY], TransactionDate)
 order By weekdays


 ----Q5.What is the average revenue per customer/average revenue per customer by each location?


 SELECT [Cust_ID],[Location], AVG(SaleAmount) as AVG_Revenue
 from Final_Data
 group by [Cust_ID],[Location]


 ----Q6.Average revenue per customer by each store etc?

select Store_ID,Cust_id, Sum(SaleAmount)/Count(Cust_Id) as AVG_Revenue_per_Cust
 from [dbo].[Final_Data]
 where Cust_ID is not null
 group by Store_ID,Cust_id
 order by Store_ID






 ----Q7.Find the department spend by store wise?

SELECT STORE_ID, SUM ([Dep1Amount]) AS DEP1,
SUM([Dep2Amount]) as DEP2, SUM([Dep3Amount]) AS DEP3, SUM([Dep4Amount])AS DEP4
FROM FINAL_DATA 
GROUP BY STORE_ID
order by STORE_ID asc


-----Q8. What is the Latest transaction date and Oldest Transaction date? (Finding the minimum and maximum transaction dates)
select 
Max([TransactionDate]) as Latest_transaction_date,
min([TransactionDate]) as Oldest_Transaction_date
from Final_Data


----Q9. How many months of data provided for the analysis?
  
  Select datediff(month,MIN(transactiondate),max(transactiondate)) + 1 as Total_months 
  from Final_Data



----Q10. Find the top 3 locations interms of spend and total contribution of sales out of total sales? 
 
SELECT TOP 3 
[Location],
cast(SUM(SALEAMOUNT) as Decimal(25,2)) AS TOTAL_SPEND_OF_LOCATION,
cast(SUM(SALEAMOUNT) / SUM(TotalAmount) * 100 as Decimal(25,2)) CONTRI_OF_PERCENTAGE
FROM FINAL_DATA
GROUP BY [Location]
ORDER BY TOTAL_SPEND_OF_LOCATION DESC



 ----Q11.Find the customer count and Total Sales by Gender?
 Select Gender, Count(Distinct(Cust_ID)) as Cust_Count, cast(Sum(saleAmount) as decimal(25,2)) as Total_sales
 from Final_Data
 where Gender is not null
 Group By Gender


 ----Q12. What is total  discount and percentage of discount given by each location? 
 Select [Location] , Sum([Discount]) as Total_discount, (Sum([Discount])/(sum(TotalAmount)) * 100) as Disc_Perc
 from Final_Data
 where Location is not null
 Group By [Location]



 ----Q13. Which segment of customers contributing maximum sales?

 select Cust_seg, Sum(SaleAmount) as Total_sales
 from [dbo].[Final_Data]

 Group By Cust_seg


 ----Q14. What is the average transaction value by location, gender, segment? !

 Select [Location], Gender, Cust_seg, avg(SaleAmount) as AVG_trans_value
 from Final_Data
 where Gender is not null or [Location] is not null or Cust_seg is not null
 Group by [Location], Gender, Cust_seg
 order by Location desc



-----------------------------------------------------------------------------------------------------------------
---  Filter the Final_Data using sample_flag=1 and export this data into Excel File and call this table as sample_data

Select * From Final_Data
where Sample_flag = 1

SELECT * INTO Sample_Data
from Final_Data 
where Sample_flag = 1

Select * from Sample_Data