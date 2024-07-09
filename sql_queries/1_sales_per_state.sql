/*
Question: How many cars were sold in each state?
This can help us see which states have more attractive car markets.
*/
SELECT 
    state,
    COUNT(*)
FROM car_prices
GROUP BY state
ORDER BY count DESC;



    
