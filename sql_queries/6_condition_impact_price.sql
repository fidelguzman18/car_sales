/*
Question: Does condition impact selling price?
*/

SELECT
    MIN(condition),
    MAX(condition)
FROM car_prices_valid;

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

