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

delete
from traffic_v3
where traffic_v3.last_visited is null