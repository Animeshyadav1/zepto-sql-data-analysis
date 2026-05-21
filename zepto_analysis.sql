TRUNCATE TABLE zepto;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/zepto_mysql_import_fixed.csv'
INTO TABLE zepto
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(category, name, mrp, discountPercent, available_quantity, 
 discountedSellingPrice, weightInGms, outOfStock, unit_quantity);
 

-- See all data
SELECT * FROM zepto;

-- Total rows
SELECT COUNT(*) FROM zepto;

-- See all categories
SELECT DISTINCT category FROM zepto;

--  Count products per category
SELECT category, COUNT(*) AS total_products
FROM zepto
GROUP BY category
ORDER BY total_products DESC;

-- Check for NULL values
SELECT * FROM zepto
WHERE name IS NULL 
OR mrp IS NULL 
OR category IS NULL;

-- Check for duplicates
SELECT name, mrp, COUNT(*) 
FROM zepto
GROUP BY name, mrp
HAVING COUNT(*) > 1;

--  Check products where MRP is 0
SELECT * FROM zepto
WHERE mrp = 0;

--  Check out of stock products
SELECT * FROM zepto
WHERE outOfStock = 'TRUE';

--  How many products are in stock vs out of stock?
SELECT outOfStock, COUNT(*) AS total
FROM zepto
GROUP BY outOfStock;

--  Top 10 most expensive products
SELECT name, category, mrp
FROM zepto
ORDER BY mrp DESC
LIMIT 10;

--  Top 10 most discounted products
SELECT name, category, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

--  Average MRP by category
SELECT category, 
       ROUND(AVG(mrp), 2) AS avg_mrp
FROM zepto
GROUP BY category
ORDER BY avg_mrp DESC;

--  Average discount by category
SELECT category, 
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC;

--  Products with high MRP but still out of stock
SELECT name, category, mrp, discountPercent
FROM zepto
WHERE outOfStock = 'TRUE'
ORDER BY mrp DESC
LIMIT 10;

--  Best value products (high discount + in stock)
SELECT name, category, mrp, discountPercent, discountedSellingPrice
FROM zepto
WHERE outOfStock = 'FALSE'
ORDER BY discountPercent DESC
LIMIT 10;

--  How much money saved per category
SELECT category,
       ROUND(AVG(mrp - discountedSellingPrice), 2) AS avg_savings
FROM zepto
GROUP BY category
ORDER BY avg_savings DESC;

--  Products with no discount
SELECT name, category, mrp
FROM zepto
WHERE discountPercent = 0
ORDER BY mrp DESC;

--  Lightweight vs heavy products
SELECT 
    CASE 
        WHEN weightInGms < 500 THEN 'Lightweight'
        WHEN weightInGms BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Heavy'
    END AS weight_category,
    COUNT(*) AS total_products
FROM zepto
GROUP BY weight_category;

--  Category wise revenue potential (MRP x quantity)
SELECT category,
       SUM(mrp * available_quantity) AS total_revenue_potential
FROM zepto
GROUP BY category
ORDER BY total_revenue_potential DESC;

--  Products where selling price is same as MRP (no discount)
SELECT name, category, mrp, discountedSellingPrice
FROM zepto
WHERE mrp = discountedSellingPrice
LIMIT 10;

--  Rank categories by number of out of stock products
SELECT category, 
       COUNT(*) AS out_of_stock_count
FROM zepto
WHERE outOfStock = 'TRUE'
GROUP BY category
ORDER BY out_of_stock_count DESC;

--  Most stocked categories (available quantity)
SELECT category,
       SUM(available_quantity) AS total_stock
FROM zepto
GROUP BY category
ORDER BY total_stock DESC;

--  Price range buckets
SELECT 
    CASE
        WHEN mrp < 100 THEN 'Below 100'
        WHEN mrp BETWEEN 100 AND 500 THEN '100-500'
        WHEN mrp BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END AS price_range,
    COUNT(*) AS total_products
FROM zepto
GROUP BY price_range
ORDER BY total_products DESC;
