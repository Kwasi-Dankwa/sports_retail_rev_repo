--Data Cleaning Process--


-- checking and deleting missing values in brands table
delete from brands_v2
where brands_v2.brand is null

-- there was no need to delete prior null values since inner join automatically excludes null values from both tables--
SELECT COUNT(*) AS total_rows,
COUNT(info_v2.description) AS num_of_description,
COUNT(finance.listing_price) AS num_of_listing_price,
COUNT(traffic_v3.last_visited) AS num_of_last_visited
FROM info_v2
INNER JOIN finance
ON info_v2.product_id = finance.product_id
INNER JOIN traffic_v3
ON info_v2.product_id = traffic_v3.product_id

-- updating infov2 table to have product name columns in caps
UPDATE info_v2
SET product_name = UPPER(product_name);

-- joining and viewing tables with brand, productname, rating and reviews -- 
select b.brand, i.product_name, r.rating, r.reviews
from brands_v2 b
inner join info_v2 i 
on b.product_id = i.product_id
inner join reviews_v2 r
on i.product_id = r.product_id

-- How the price point of adidas and Nike differ --
-- use cte to calculate avegrae price --
-- extract difference from cte after grouping by brand --
with brand_price as (
SELECT b.brand, 
AVG(f.listing_price) AS average_listing_price, 
AVG(f.sale_price) AS average_sale_price
FROM brands_v2 b
INNER JOIN finance f ON b.product_id = f.product_id
WHERE b.brand IN ('Adidas', 'Nike')
GROUP BY b.brand
)
SELECT
    (SELECT average_sale_price FROM brand_price WHERE brand = 'Adidas') -
    (SELECT average_sale_price FROM brand_price WHERE brand = 'Nike') AS price_difference_adidas_nike;

-- Assessing Price Ranges --
SELECT b.brand, count(*) as num_of_products, sum(f.revenue) as total_revenue,
CASE WHEN listing_price < 32 THEN 'Budget'
     WHEN listing_price >= 32 AND listing_price < 74 THEN 'Average'
     WHEN listing_price >= 74 AND listing_price < 129 THEN 'Expensive'
     ELSE 'Luxury' END AS price_category
FROM finance f
INNER JOIN brands_v2 b
ON f.product_id = b.product_id
WHERE b.brand IS NOT NULL
GROUP BY brand, price_category
ORDER BY total_revenue DESC

-- difference in the amount of discount offered between the brands --
SELECT b.brand, round(AVG(f.discount), 2) * 100 AS average_discount
FROM finance f
INNER JOIN brands_v2 b
ON f.product_id = b.product_id
GROUP BY b.brand

--using cte to calculate correlation-- 
WITH CalcData AS (
    SELECT
        f.revenue,
        r.reviews
    FROM
        finance f
    INNER JOIN
        reviews_v2 r ON f.product_id = r.product_id
),
-- using pearsons correlation coefficient formula to find correlation
AggData AS (
    SELECT
        COUNT(revenue) AS N,
        SUM(revenue) AS SumRevenue,
        SUM(reviews) AS SumReviews,
        SUM(revenue * reviews) AS SumRevenueReviews,
        SUM(revenue * revenue) AS SumRevenueSq,
        SUM(reviews * reviews) AS SumReviewsSq
    FROM
        CalcData
)
SELECT
    (N * SumRevenueReviews - SumRevenue * SumReviews) /
    SQRT(
        (N * SumRevenueSq - SumRevenue * SumRevenue) *
        (N * SumReviewsSq - SumReviews * SumReviews)
    ) AS review_revenue_correlation
FROM
    AggData;

 -- Calculating description_length, effectively flooring to the nearest 100	
SELECT (LENGTH(i.description) / 100) * 100 AS description_length,
    -- Cast rating to REAL for AVG, then round to 2 decimal places
    ROUND(AVG(CAST(r.rating AS REAL)), 2) AS average_rating
FROM info_v2 i
INNER JOIN reviews_v2 r ON i.product_id = r.product_id
WHERE i.description IS NOT NULL
GROUP BY description_length -- Or use (LENGTH(i.description) / 100) * 100 here again for clarity
ORDER BY description_length;

-- identifying gaps in volume of reviews by month --  
SELECT b.brand,
    STRFTIME('%Y-%m', t.last_visited) AS year_month, -- Extracting Year and Month to handle multi-year data
    COUNT(r.reviews) AS num_reviews
FROM reviews_v2 r
INNER JOIN traffic_v3 t ON r.product_id = t.product_id
INNER JOIN brands_v2 b ON r.product_id = b.product_id
WHERE b.brand IS NOT NULL
    AND t.last_visited IS NOT NULL -- Ensure last_visited is not NULL before processing
GROUP BY b.brand, year_month
ORDER BY b.brand,year_month;
	
--finding how many stocks consists of footwear products-- 
WITH footwear_stocks AS (
    SELECT
        i.description,
        f.revenue
    FROM info_v2 AS i
    INNER JOIN finance AS f ON i.product_id = f.product_id
    WHERE
        (i.description LIKE '%shoe%'
        OR i.description LIKE '%trainer%'
        OR i.description LIKE '%foot%')
        AND i.description IS NOT NULL
),
RankedFootwear AS (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM footwear_stocks
)
SELECT
    COUNT(revenue) AS num_footwear_products,
    CASE
        WHEN total_rows % 2 = 1 THEN  -- Odd number of rows
            (SELECT revenue FROM RankedFootwear WHERE rn = (total_rows + 1) / 2)
        ELSE -- Even number of rows
            (SELECT (
                (SELECT revenue FROM RankedFootwear WHERE rn = total_rows / 2) +
                (SELECT revenue FROM RankedFootwear WHERE rn = total_rows / 2 + 1)
            ) / 2.0)
    END AS median_footwear_revenue
FROM RankedFootwear
LIMIT 1; 

-- how footwears median value differs from clothing products --
WITH FootwearDescriptions AS (
    SELECT i.description
    FROM info_v2 AS i
    WHERE
        (i.description LIKE '%shoe%'
        OR i.description LIKE '%trainer%'
        OR i.description LIKE '%foot%')
        AND i.description IS NOT NULL
),
ClothingProducts AS (
    SELECT f.revenue
    FROM info_v2 AS i
    INNER JOIN finance AS f ON i.product_id = f.product_id
    WHERE
        i.description NOT IN (SELECT description FROM FootwearDescriptions)
        AND i.description IS NOT NULL -- Ensure description is not NULL for clothing
),
RankedClothing AS (
    SELECT
        revenue,
        ROW_NUMBER() OVER (ORDER BY revenue) AS rn,
        COUNT(*) OVER () AS total_rows
    FROM ClothingProducts
)
SELECT
    COUNT(revenue) AS num_clothing_products,
    CASE
        WHEN total_rows = 0 THEN NULL -- Handling case with no clothing products
        WHEN total_rows % 2 = 1 THEN  -- Odd number of rows
            (SELECT revenue FROM RankedClothing WHERE rn = (total_rows + 1) / 2)
        ELSE -- Even number of rows
            (SELECT (
                (SELECT revenue FROM RankedClothing WHERE rn = total_rows / 2) +
                (SELECT revenue FROM RankedClothing WHERE rn = total_rows / 2 + 1)
            ) / 2.0)
    END AS median_clothing_revenue
FROM RankedClothing
LIMIT 1; 

