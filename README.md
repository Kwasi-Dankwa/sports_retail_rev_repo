# Revenue Optimization Project
A Data Analytics Project by Kwasi Dankwa

# 📌 Overview
As a product analyst at an online sports clothing company, my core objective is to identify tangible strategies for revenue growth. I will achieve this by conducting a deep dive into our product-level data, specifically analyzing pricing strategies, customer reviews and ratings, product descriptions, and website traffic patterns. The insights derived from this analysis will be translated into actionable recommendations for our marketing and sales teams to drive increased revenue

# 📊 Key Questions Explored
* How do the average prices of Adidas and Nike compare?

* What pricing categories (Budget, Average, Expensive, Luxury) are dominant for each brand?

* How much discount is each brand offering on average?

* Is there a correlation between reviews and revenue?

* How does product description length relate to customer rating?

* Which months or periods show review volume gaps across brands?

* How do footwear and clothing products compare in terms of median revenue?

#  🛠️ Tools Used
SQL (SQLite) – Data extraction, cleaning, CTEs, joins, aggregations, and correlation analysis

Tableau Public – Interactive dashboard creation with charts, KPIs, and filtering capabilities

# 📁 Datasets Used
[`Data Source`](https://www.kaggle.com/code/nickleejh/optimizing-online-sports-retail-revenue-using-sql/input)

brands_v2: Contains product and brand info (e.g., Adidas, Nike)

finance: Holds financial data such as listing price, sale price, revenue, and discount

reviews_v2: Contains review count and ratings

info_v2: Includes product descriptions

traffic_v3: Contains visit data for identifying consumer engagement patterns

## Data Schema

![DB](images/db.png "DB diagram")
> All datasets are related through the product_id key, allowing for integrated analysis across brand, finance, reviews, and product details.

## Data Cleaning Process
To ensure consistency in product naming, I standardized the product_name field in the info_v2 table by converting all entries to uppercase. This helps avoid duplicate entries that differ only in casing and supports consistent labeling in visualizations.

<pre lang="markdown"> ``` 
  -- Updating `info_v2` table to have product_name values in uppercase 
  UPDATE info_v2 
  SET product_name = UPPER(product_name); 
  ``` </pre>


# 🧠 Key Insights and Recommendations

Link to Tableau Dashboard
> 📊 [View the Tableau Dashboard](https://public.tableau.com/shared/NG8FJW2NM?:display_count=n&:origin=viz_share_link)

## Pricing Insights

### Price Comparison (Nike v Adidas)

#### Adidas
* Adidas lists products at higher prices but sells at lower prices (approx. 34% discount).

* Adidas may be relying heavily on markdown strategies or promotions to drive sales.

* It also indicates overpricing at launch leading to inventory not moving without discounts.

#### Nike
Nike lists low but sells high, which could suggest:

* The listing price shown may reflect outdated or clearance inventory.
* Nike uses strategic upselling or bundling, or has premium products dominating sales.
* Consumers appear willing to pay more than listing, which is rare and noteworthy.
* Additionally, Nike products have no discounts attached to them.

### Product and Revenue Insights
* Adidas Dominates Revenue
* Adidas has higher revenue across all price tiers (Average, Expensive, Luxury).
* Most revenue is concentrated in the Average tier ($3.86M from 1,214 items).
* Luxury Adidas also performs well ($3.01M), despite having fewer items (307), indicating strong revenue per product.

* Nike Has Lower Volume & Revenue
* Nike’s Budget tier drives the most revenue for the brand ($595K from 356 items).
* Luxury and Expensive tiers underperform, suggesting either lower pricing, weak positioning, or reduced consumer demand for high-end Nike items.

### Category
* Footwear Is the Clear Revenue Driver
* Footwear brings in ~92% of total revenue ($11.43M from 2,700 items).
* This suggests strong market demand, better margins, or wider product coverage in this category.

* Clothing Underperforms
* Clothing only accounts for $893K across 479 items.
* That’s less than 10% of footwear revenue, despite a decent product count — possibly indicating lower average price or weaker consumer interest.

### Reviews and Revenue
There is a weak relationship between reviews and revenue (e.g., R² = 0.42) which means that customer review count only explains 42% of the variation in revenue. Additionally, Adidas products have had higher reviews than Nike products for a 2 year period(2018 - 2022)
Reasons for this could include:

* Reviews Are Not the Sole Driver of Sales - While more reviews may be correlated with higher sales, they are not a reliable standalone predictor, Products with fewer reviews can still perform well (e.g., if they’re marketed heavily or are premium items)

* Marketing, Brand, and Price May Matter More - Revenue likely depends more on brand perception, pricing strategy, product category, or promotional tactics than just review.

### Recommendations

1. The brand needs to explore opportunities to develop products in the “Expensive” and “Elite” categories that have higher revenue potential.
2. Also, highest revenue generated Products are from footwear section, brand should focus on giving less discounts on footwear and more discounts on clothing that will increase sales and revenue for clothing section as well.
3. Continuously monitoring product section like footwear and clothing and making relevant price adjustments or marketing strategies.
4. Focusing on product quality, customer service, and holistic marketing strategies can help improve reviews and revenue.
5. Analyze factors that influence monthly review fluctuations and planning appropriate marketing strategies.
   
Using this data as a foundation to design more effective and customer-oriented business strategies. All of these recommendations can assist the brand in enhancing product performance, increasing revenue, and providing a better experience to customers.







