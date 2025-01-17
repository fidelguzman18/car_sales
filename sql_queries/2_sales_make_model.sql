/*
Question: Which make and model have the most sales?
*/

SELECT
    make,
    model,
    COUNT(*) AS total_sales
FROM car_prices_valid
GROUP BY make,model
ORDER BY total_sales DESC