/* 
The first thing i did was to investigate the two problematic tables - customer_orders and runner_orders as indicated in the description.

For the customer_orders table, I used SELECT DISTINCT for the unique values in each column, and I found that the values that require update are: "", "null" and NULL.
I decided to replace those values with a 0 value.

For the runner_orders table, in addition to the same missing values in the customer_orders table, 
I found that the distance column contains string values like "km" that need to be removed. 
Furthermore, the duration column contains various strings that need to be removed (minutes, minutes, minutes, etc.).
*/

-- I encountered a warning during my effort to update the tables, this SET statement helped solve it:
SET SQL_SAFE_UPDATES = 0;


-- customer_orders table

-- These UPDATE statements used to replace the missing values into 0 values
UPDATE customer_orders SET exclusions = 0
WHERE exclusions IS NULL OR exclusions IN ('', 'null');

UPDATE customer_orders SET extras = 0
WHERE extras IS NULL OR extras IN ('', 'null');



-- runner_orders table

-- replacing all missing values into NULL values in the cancellation and pickup_time columns
UPDATE runner_orders SET cancellation = NULL
WHERE cancellation IN ('', 'null');

UPDATE runner_orders SET pickup_time = NULL
WHERE pickup_time IN ('', 'null');

-- deleting all unwanted chars in the distance and duration columns
UPDATE runner_orders SET duration = REGEXP_SUBSTR(duration, "[0-9]+"), 
  distnace = REGEXP_SUBSTR(distance, "[0-9]+");



-- Questions

-- A. Pizza Metrics

-- 1. total ordered pizzas
SELECT COUNT(*) AS total_orders FROM customer_orders;

-- 2. unique customer orders
SELECT COUNT(DISTINCT order_id) AS unique_customer_orders FROM customer_orders;

-- 3. successful orders that were delivered by each runner
SELECT runner_id, COUNT(*) AS orders_count
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;

-- 4. total count of each type of pizza delivered
SELECT pizza_id, COUNT(*) AS total_delivered
FROM customer_orders
INNER JOIN runner_orders
	ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation IS NULL
GROUP BY pizza_id;

-- 5. Vegetarian and Meatlovers that were ordered by each customer
