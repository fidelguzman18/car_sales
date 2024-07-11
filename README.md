# Introduction
We'll explore the car market in the US. The main goal of this project is to have a better understanding of how SQL works.
You can find all the queries [here](/sql_queries/).
# Background
This project was made using a SQL project as a guideline, especially for the questions asked, and this [kaggle database](https://www.kaggle.com/datasets/syedanwarafridi/vehicle-sales-data/data).
### The questions answered with this queries are:
1. How many cars were sold in each state?
2. Which make and model have the most sales?
3. What is the avg selling price for each month and year?
4. What are the top selling cars, grouped by body type?
5. Which sales were made above the average selling price and how higher were they?
6. Does condition impact selling price?
7. Does odometer count impact selling price?
8. What is the lowest, highest and average price for each brand, and how many different models do they sell?
# Tools used:
- PostgreSQL
- Visual Studio Code
- Github
# The analysis
Each query was aimed to answer a specific question, but before that I created a materialized view to have an easier time working with the dates and also cleaning the original table a little bit:

```sql
CREATE MATERIALIZED VIEW car_prices_valid AS
    SELECT
        *,
        SUBSTRING(saledate, 12, 4) AS sale_year,
        SUBSTRING(saledate, 5, 3) AS sale_month_name,
        SUBSTRING(saledate, 9, 2) AS sale_day,
        CAST(
            CASE SUBSTRING(saledate, 5,3)
                WHEN 'Jan' THEN 1
                WHEN 'Feb' THEN 2
                WHEN 'Mar' THEN 3
                WHEN 'Apr' THEN 4
                WHEN 'May' THEN 5
                WHEN 'Jun' THEN 6
                WHEN 'Jul' THEN 7
                WHEN 'Aug' THEN 8
                WHEN 'Sep' THEN 9
                WHEN 'Oct' THEN 10
                WHEN 'Nov' THEN 11
                WHEN 'Dec' THEN 12
                ELSE NULL
            END AS SMALLINT) AS sale_month
    FROM car_prices
    WHERE saledate != ''
WITH DATA;
```

### 1.How many cars were sold in each state?
This was a very simple query, counting the sales registered in each state usign a group by.
```sql
SELECT 
    state,
    COUNT(*)
FROM car_prices_valid
GROUP BY state
ORDER BY count DESC;
```
We can clearly see that Florida and California have the most amount of sales. This information gives us a hint of how the car market is distributed across the US and can help us decide for a specific location to invest.

### 2.Which make and model have the most sales?
Again a very simple query, counting the sales and grouping them by make and model.
```sql
SELECT
    make,
    model,
    COUNT(*) AS total_sales
FROM car_prices_valid
GROUP BY make,model
ORDER BY total_sales DESC
```
We can see from the results that even though Nissan is on top of the list with the Altima model, Ford has 4 out of the 6 most sold vehicles.

### 3. What is the avg selling price for each month and year?
Some aggregations functions over the sales grouping them by year and month.
```sql
SELECT 
    sale_year,
    sale_month,
    ROUND(AVG(sellingprice),2) AS avg_sales_price,
    COUNT(*) AS sales_cant
FROM car_prices_valid
GROUP BY
    sale_year, sale_month
ORDER BY
    sale_year, sale_month;
```
This query gives us some insight on how the car market moves across the year, clearly showing the start of the year as the moment with the most movement.

### 4. What are the top selling cars, grouped by body type?
This query was very helpful to understand subqueries and window functions. It ranks the body types by their sales, allowing us to get the top 5 brands and models in each category. The result is a really helpful table to create a graphic in a BI tool.
```sql
SELECT 
    make,
    model,
    body,
    num_sales,
    body_rank
FROM (
    SELECT 
        make,
        model,
        body,
        COUNT(*) AS num_sales,
        RANK() OVER (PARTITION BY body ORDER BY COUNT(*) DESC) AS body_rank
    FROM car_prices_valid
    GROUP BY make, model, body
)
WHERE body_rank <= 5
ORDER BY
    body, num_sales DESC;
```

### 5. Which sales were made above the average selling price and how higher were they?
The construction of this query was very similar to the previous one, but this one allows us to see which sales were made above the average price and the ratio of this difference.
```sql
SELECT
    make,
    model,
    vin,
    sale_year,
    sale_month,
    sale_day,
    sellingprice,
    ROUND(avg_model, 2),
    ROUND(sellingprice/avg_model, 2) AS price_ratio
FROM
    (SELECT
        make,
        model,
        vin,
        sale_year,
        sale_month,
        sale_day,
        sellingprice,
        AVG(sellingprice) OVER (PARTITION BY make, model) AS avg_model
    FROM car_prices_valid)
WHERE
    sellingprice > avg_model
ORDER BY price_ratio DESC;
```

### 6. Does condition impact selling price?
In this query i used some logic to group the data by condition and see the number of sales and average price for each range.
```sql
SELECT
    CASE
        WHEN condition BETWEEN 1 AND 9 THEN '1 to 9'
        WHEN condition BETWEEN 10 AND 19 THEN '10 to 19'
        WHEN condition BETWEEN 20 AND 29 THEN '20 to 29'
        WHEN condition BETWEEN 30 AND 39 THEN '30 to 39'
        WHEN condition BETWEEN 40 AND 49 THEN '40 to 49'
    END AS car_condition,
    COUNT(*) AS num_sales,
    ROUND(AVG(sellingprice), 2) AS avg_sale_price
FROM
    car_prices_valid
WHERE condition IS NOT NULL
GROUP BY
    car_condition
ORDER BY
    car_condition;
```

### 7. Does odometer count impact selling price?
Pretty much the same as the previous query but grouping the results according to the odometer count.
```sql
SELECT
    CASE
        WHEN odometer BETWEEN 1 AND 99999 THEN '1-99.999'
        WHEN odometer BETWEEN 100000 AND 199999 THEN '100.000-199.999'
        WHEN odometer BETWEEN 200000 AND 299999 THEN '200.000-299.999'
        WHEN odometer BETWEEN 300000 AND 399999 THEN '300.000-399.999'
        WHEN odometer BETWEEN 400000 AND 499999 THEN '400.000-499.999'
        WHEN odometer BETWEEN 500000 AND 599999 THEN '500.000-599.999'
        WHEN odometer BETWEEN 600000 AND 699999 THEN '600.000-699.999'
        WHEN odometer BETWEEN 700000 AND 799999 THEN '700.000-799.999'
        WHEN odometer BETWEEN 800000 AND 899999 THEN '800.000-899.999'
        WHEN odometer BETWEEN 900000 AND 999999 THEN '900.000-999.999'
    END AS odometer_range,
    COUNT(*) AS num_sales,
    ROUND(AVG(sellingprice), 2) AS avg_sale_price
FROM
    car_prices_valid
WHERE odometer IS NOT NULL
GROUP BY
    odometer_range
ORDER BY
    odometer_range;
```

### 8. What is the lowest, highest and average price for each brand, and how many different models do they sell?
In this query I used a bunch of different aggregations to have a more detailed information on the numbers from each brand in the car market.
```sql
SELECT
    make,
    COUNT(DISTINCT model) AS num_models,
    COUNT(*) AS total_sales,
    MIN(sellingprice) AS min_price,
    MAX(sellingprice) AS max_price,
    ROUND(AVG(sellingprice), 2) AS avg_price
FROM car_prices_valid
GROUP BY make
ORDER BY
    avg_price DESC;
```

# Closing thoughts
This was a very interesting project to learn some new functionalities about SQL. It was really helpful to understand what window functions are and how they work, as well as having a better overall understanding of the language.