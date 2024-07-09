/*
Question: What is the avg selling price for each month and year?
I added how many sales there are each month, which is helpful on its own, but also tells us how representative this avg are.
*/
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




