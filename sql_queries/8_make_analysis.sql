/*
Question: What is the lowest, highest and average price for each brand, and how many different models do they sell?
*/
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