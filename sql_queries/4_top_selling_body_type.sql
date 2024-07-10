/*
Question: What are the top selling cars, grouped by body type?
*/
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
    body, num_sales DESC