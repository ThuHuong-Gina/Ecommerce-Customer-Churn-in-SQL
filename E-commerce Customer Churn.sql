Data Cleaning
-- 1.1 Counting total number of customer
SELECT COUNT(DISTINCT (CustomerID)) AS total_customer
FROM [model].[dbo].[ecom_customer]
 
-- 1.2 Checking duplicate row by customeriD
SELECT 
      CustomerID,
      COUNT(CustomerID) AS count_id
FROM [model].[dbo].[ecom_customer]
GROUP BY CustomerID
HAVING COUNT(CustomerID) >1
 

-- 1.3 Checking null values in interge columns
SELECT 'Tenure' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE Tenure IS NULL 
GROUP BY Tenure
UNION ALL
SELECT 'WarehouseToHome' as ColumnName , COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE warehousetohome IS NULL 
GROUP BY warehousetohome
UNION ALL
SELECT 'HourSpendonApp' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE hourspendonapp IS NULL
GROUP BY HourSpendonApp
UNION ALL
SELECT 'OrderAmountHikeFromLastYear' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE orderamounthikefromlastyear IS NULL 
GROUP BY orderamounthikefromlastyear
UNION ALL
SELECT 'CouponUsed' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE couponused IS NULL 
GROUP BY couponused
UNION ALL
SELECT 'OrderCount' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE ordercount IS NULL 
GROUP BY OrderCount
UNION ALL
SELECT 'DaySinceLastOrder' as ColumnName, COUNT(*) AS NullCount 
FROM [model].[dbo].[ecom_customer]
WHERE daysincelastorder IS NULL 
GROUP BY daysincelastorder

 

-- 1.4.Handling null values: replacing the missing values in these columns with the mean of the reference column

-- Update null values for Tenure column
UPDATE [model].[dbo].[ecom_customer]
SET Tenure = (SELECT AVG(Tenure) FROM [model].[dbo].[ecom_customer])
WHERE Tenure IS NULL 
-- Update null values for WarehouseToHome column
UPDATE [model].[dbo].[ecom_customer]
SET WarehouseToHome = (SELECT AVG(WarehouseToHome) FROM [model].[dbo].[ecom_customer]) 
WHERE WarehouseToHome IS NULL

-- Update null values for hourspendonapp column
UPDATE [model].[dbo].[ecom_customer]
SET Hourspendonapp = (SELECT AVG(Hourspendonapp) FROM [model].[dbo].[ecom_customer])
WHERE Hourspendonapp IS NULL 

-- Update null values for orderamounthikefromlastyear column
UPDATE [model].[dbo].[ecom_customer]
SET orderamounthikefromlastyear = (SELECT AVG(orderamounthikefromlastyear) FROM [model].[dbo].[ecom_customer])
WHERE orderamounthikefromlastyear IS NULL

-- Update null values for CouponUsed column
UPDATE  [model].[dbo].[ecom_customer]
SET CouponUsed = (SELECT AVG(CouponUsed) FROM [model].[dbo].[ecom_customer])
WHERE CouponUsed IS NULL

-- Update null values for OrderCount column
UPDATE [model].[dbo].[ecom_customer]
SET OrderCount = (SELECT AVG(OrderCount) FROM [model].[dbo].[ecom_customer])
WHERE OrderCount IS NULL

-- Update null values for Daysincelastorder column
UPDATE [model].[dbo].[ecom_customer]
SET Daysincelastorder = (SELECT AVG(Daysincelastorder) FROM [model].[dbo].[ecom_customer])
WHERE Daysincelastorder IS NULL


-- 1.5 Change status of Churn column from 0 and 1 to "stayed"/"churn" and change column name to Churn_status
 
-- Fisrt change datatype of Churn colmun
ALTER TABLE [model].[dbo].[ecom_customer]
ALTER COLUMN  Churn NVARCHAR(50);
-- Change 0/1 values to stayed/churn values
UPDATE [model].[dbo].[ecom_customer]
SET Churn = 
    CASE WHEN Churn = 0 THEN 'stayed'
    ELSE 'churn'
    END 
-- Check data after changed
Select Churn_status , count(Churn_status) AS count_status
FROM [model].[dbo].[ecom_customer]
GROUP BY Churn_status;
 
-- 1.6 Change status of Complain column from 0 and 1 to "No"/"Yes"

-- Fisrt change datatype of Churn colmun
ALTER TABLE [model].[dbo].[ecom_customer]
ALTER COLUMN Complain NVARCHAR(50);
-- Change 0/1 values to No/Yes values
UPDATE [model].[dbo].[ecom_customer]
SET Complain = 
    CASE WHEN Complain = 0 THEN 'No'
    ELSE 'Yes'
    END 
-- Check data after changed
Select Complain , count(Complain) AS count_status
FROM [model].[dbo].[ecom_customer]
GROUP BY Complain;
 
1.7 Checking categorized columns 
-- Checking PreferredLoginDevice column
SELECT DISTINCT PreferredLoginDevice
FROM [model].[dbo].[ecom_customer]

-- Replace "Mobile Phone" with Phone
UPDATE [model].[dbo].[ecom_customer]
SET PreferredLoginDevice = 'Phone'
WHERE PreferredLoginDevice = 'Mobile Phone'
 

-- Checking PreferredPaymentMode column
SELECT DISTINCT PreferredPaymentMode
FROM [model].[dbo].[ecom_customer]

-- Replace "COD" with "Cash on Delivery"
UPDATE [model].[dbo].[ecom_customer]
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD'

  

-- Checking PreferedOrderCat column
SELECT DISTINCT PreferedOrderCat
FROM [model].[dbo].[ecom_customer];

-- Replace 'Mobile' with 'Mobile Phone'
UPDATE [model].[dbo].[ecom_customer]
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile'
  
We can see 127 and 127 are outlier compare to another values. So we will change these to values to 26/27 respectively

UPDATE [model].[dbo].[ecom_customer]
SET WarehouseToHome = '26'
WHERE WarehouseToHome = '126'

UPDATE [model].[dbo].[ecom_customer]
SET WarehouseToHome = '27'
WHERE WarehouseToHome = '127'

 
2. Data Exploration
2.1. What is the overall customer churn rate?
SELECT total_customer,
       total_churn_customer,
       CAST((total_churn_customer * 1.0/total_customer * 1.0)*100 AS DECIMAL (20,2)) AS churn_rate
FROM 
    (SELECT COUNT (DISTINCT CustomerID) AS total_customer
    FROM [model].[dbo].[ecom_customer]) AS count_total_customer,
    (SELECT COUNT (DISTINCT CustomerID) AS total_churn_customer
    FROM [model].[dbo].[ecom_customer]
    WHERE Churn_status ='churn') AS count_total_churn_customer;
 
2.2. How does the churn rate vary based on the preferred login device?

SELECT 
        PreferredLoginDevice, 
        COUNT(*) AS num_customer,
        SUM(CASE WHEN Churn_status ='churn' THEN 1 ELSE 0 END) AS Churn_customer,
        CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1 ELSE 0 END)*1.0/ count(*)*100 AS DECIMAL (10,2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY PreferredLoginDevice;
 
2.3. What is the distribution of churned customers across different city tiers?
-- What is the distribution of churned customers across different city tiers?
SELECT 
        CityTier,
        COUNT(*) AS total_customer,
        SUM(CASE WHEN Churn_status ='churn' THEN 1 ELSE 0 END) AS Churn_customer,
        CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1 ELSE 0 END)*1.0/ count(*)*100 AS DECIMAL (10,2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY CityTier;
 

2.4. Which is the most preferred payment mode among churned customers?
SELECT 
    PreferredPaymentMode, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY PreferredPaymentMode;
 
2.5. What is the typical tenure for churned customers?
-- Classcification for Tenure column 
ALTER TABLE [model].[dbo].[ecom_customer]
ADD Tenure_clascification VARCHAR(50)

UPDATE [model].[dbo].[ecom_customer]
SET Tenure_clascification = 
CASE WHEN Tenure <= 6 THEN '6 months'
     WHEN Tenure <= 12 THEN '1 year'
     WHEN Tenure <= 24 THEN '2 years'
     WHEN Tenure <= 36 THEN '3 years'
     ELSE 'more than 3 years'
END 
-- Percentage of churn customer per each Tenure Clascification
SELECT 
    Tenure_Clascification, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY Tenure_Clascification;
 
2.6. Is there any difference in churn rate between male and female customers?
SELECT 
    Gender, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY Gender;
 

2.7. How does the average time spent on the app differ for churned and non-churned customers?
SELECT 
    HourSpendOnApp, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY HourSpendOnApp;
 
2.8. Which order category is most preferred among churned customers?
SELECT 
    PreferedOrderCat, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY PreferedOrderCat;

2.9. Do customer complaints influence churned behavior?
SELECT 
    Complain, 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY Complain;
 
2.10. Is there any correlation between cashback amount and churn rate?
-- Create new column Cashback_clascification to clascification the amount money that had been cash back to customers
ALTER TABLE [model].[dbo].[ecom_customer]
ADD Cashback_clascification VARCHAR(50)

UPDATE [model].[dbo].[ecom_customer]
SET Cashback_clascification = 
CASE WHEN CashbackAmount <= 50 THEN 'very low cashback amount'
     WHEN CashbackAmount <= 100 THEN 'low cashback amount'
     WHEN CashbackAmount <= 175 THEN 'medium cashback amount'
     WHEN CashbackAmount <= 250 THEN 'high cashback amount'
     ELSE 'very high cashback amount'
END 
-- Percentage of churn customer per each Cashback_clascification 
SELECT 
    Cashback_clascification , 
    COUNT(*) AS num_customer,
    SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) AS Churn_customer,
    CAST(SUM(CASE WHEN Churn_status ='churn' THEN 1.0 ELSE 0 END) / COUNT(*) * 100 AS DECIMAL(10, 2)) AS Churn_rate
FROM [model].[dbo].[ecom_customer]
GROUP BY Cashback_clascification ;
 

