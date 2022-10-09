/* 
The first thing i did was investigate the two problematic tables - customer_orders and runner_orders as indicated in the description.
I used SELECT DISTINCT for the unique values in each column, and I found that the values that require update are: "", "null" and NULL, in both tables. 
I decided to replace those values with a 0 value.
*/

-- I encountered a warning during my effort to update the tables, this SET statement helped solve it:
SET SQL_SAFE_UPDATES = 0;

-- These UPDATE statements used to replace the problematic values into 0 values
UPDATE customer_orders SET exclusions=0
WHERE exclusions IS NULL OR exclusions IN ('', 'null');

UPDATE customer_orders SET extras=0
WHERE extras IS NULL OR extras IN ('', 'null');

