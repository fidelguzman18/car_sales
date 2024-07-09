--Deleted incorrect data
DELETE FROM car_prices
WHERE 
    LENGTH(state)>2 OR
    make = '';

--created a materialized view to add date columns that actualize if new data is loaded to the dataset.
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
