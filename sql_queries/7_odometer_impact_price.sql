/*
Question: Does odometer count impact selling price?
*/
SELECT 
    MIN(odometer),
    MAX(odometer)
FROM car_prices_valid

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