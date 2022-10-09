/* 
The first thing i did was to investigate the two problematic tables - customer_orders and runner_orders as indicated in the description.

For the customer_orders table, I used SELECT DISTINCT for the unique values in each column, and I found that the values that require update are: "", "null" and NULL.
I decided to replace those values with a 0 value.

For the runner_orders table, in addition to the same values in the customer_orders table, 
I found that the distance column contains string values like "km" that need to be removed. 
Furthermore, the duration column contains various strings that need to be removed (minutes, minutes, minutes, etc.).
*/

-- I encountered a warning during my effort to update the tables, this SET statement helped solve it:
SET SQL_SAFE_UPDATES = 0;


-- customer_orders table
-- These UPDATE statements used to replace the problematic values into 0 values
UPDATE customer_orders SET exclusions=0
WHERE exclusions IS NULL OR exclusions IN ('', 'null');

UPDATE customer_orders SET extras=0
WHERE extras IS NULL OR extras IN ('', 'null');


-- runner_orders table
-- replacing problematic values into 0 values
UPDATE customer_orders SET exclusions=0
WHERE exclusions IS NULL OR exclusions IN ('', 'null');

UPDATE customer_orders SET extras=0
WHERE extras IS NULL OR extras IN ('', 'null');

UPDATE customer_orders SET extras=0
WHERE extras IS NULL OR extras IN ('', 'null');
