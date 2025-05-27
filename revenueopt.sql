--Data Cleaning Process--


-- checking and deleting missing values in brands table
delete from brands_v2
where brands_v2.brand is null

--checking and deleting missing columns in finance table--
delete
from finance
where finance.revenue is null

--delete--
delete
from info_v2
where info_v2.description is null

--delete--
delete
from reviews_v2
where reviews_v2.reviews is null

--delete from traffic_v3 where traffic_v3.last_visited is null--


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
