/* The first thing i did was investigate the two problematic tables - customer_orders and runner_orders as indicated in the description.
I found that the values that require update are: "", "null" and NULL, in both tables.
*/

-- I encountered a warning during my effort to update the tables, this SET statement helped solve it:
SET SQL_SAFE_UPDATES = 0;

