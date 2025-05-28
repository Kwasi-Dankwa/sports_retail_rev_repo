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
