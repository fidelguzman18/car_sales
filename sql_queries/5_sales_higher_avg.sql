/*
Question: Which sales were made above the average selling price and how higher were they?
*/
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
