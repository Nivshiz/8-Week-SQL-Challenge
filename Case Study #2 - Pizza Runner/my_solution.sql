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
-- option 1:
SELECT customer_id, pizza_name, COUNT(*) AS total_ordered
FROM customer_orders
INNER JOIN pizza_names
	ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_id, pizza_name;

-- option 2:
WITH blabla AS
(
SELECT customer_id, pizza_name, COUNT(*) AS total_ordered
FROM customer_orders
INNER JOIN pizza_names
	ON customer_orders.pizza_id = pizza_names.pizza_id
GROUP BY customer_id, pizza_name
)

SELECT meat.customer_id, meat.total_meatlovers_ordered, veg.total_vegetarian_ordered 
FROM
	(SELECT customer_id, total_ordered AS total_meatlovers_ordered
	FROM blabla
	WHERE pizza_name = 'Meatlovers') AS meat
LEFT JOIN 
		(SELECT customer_id, total_ordered AS total_vegetarian_ordered
		FROM blabla
		WHERE pizza_name = 'Vegetarian') AS veg
	USING(customer_id)

UNION

SELECT veg.customer_id, meat.total_meatlovers_ordered, veg.total_vegetarian_ordered 
FROM
	(SELECT customer_id, total_ordered AS total_meatlovers_ordered
	FROM blabla
	WHERE pizza_name = 'Meatlovers') AS meat
RIGHT JOIN 
		(SELECT customer_id, total_ordered AS total_vegetarian_ordered
		FROM blabla
		WHERE pizza_name = 'Vegetarian') AS veg
	USING(customer_id)

-- 6. the maximum number of pizzas delivered in a single order
WITH order_with_pizza_count AS 
(
SELECT customer_orders.order_id, COUNT(*) AS pizza_count 
FROM customer_orders 
INNER JOIN runner_orders 
	ON customer_orders.order_id = runner_orders.order_id 
WHERE cancellation IS NULL 
GROUP BY customer_orders.order_id
)

SELECT *
FROM order_with_pizza_count 
WHERE pizza_count =
	(SELECT MAX(pizza_count) FROM order_with_pizza_count)

-- 7. the total delivered pizzas that had at least 1 change and the ones that had no changes, for each customer
SELECT customer_id, 
	IFNULL(CASE WHEN exclusions = 0 AND extras = 0 THEN COUNT(*) END, 0) AS pizzas_with_no_changes,
    IFNULL(CASE WHEN exclusions != 0 OR extras != 0 THEN COUNT(*) END, 0) AS pizzas_with_changes
FROM customer_orders
INNER JOIN runner_orders
	ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation IS NULL
GROUP BY customer_id

-- 8. total pizzas that were delivered and had both exclusions and extras
SELECT COUNT(*) AS pizzas_with_both_exclusions_and_extras
FROM customer_orders
INNER JOIN runner_orders
	ON customer_orders.order_id = runner_orders.order_id
WHERE cancellation IS NULL AND exclusions != 0 AND extras != 0

-- 9. the total volume of pizzas ordered for each hour of the day
SELECT DATE(order_time) AS day, HOUR(order_time) AS hour, COUNT(*) AS count
FROM customer_orders
INNER JOIN runner_orders
	ON customer_orders.order_id = runner_orders.order_id
GROUP BY DAY(order_time), HOUR(order_time)

-- 10. the volume of orders for each day of the week

SELECT WEEK(order_time) AS week_number, DAYOFWEEK(order_time) AS day_of_week, COUNT(*) AS count
FROM customer_orders
INNER JOIN runner_orders
	ON customer_orders.order_id = runner_orders.order_id
GROUP BY week_number, day_of_week


-- B. Runner and Customer Experience

-- 1. count of runners that signed up, for each 1 week period
SELECT WEEK(pickup_time) AS week_number, 
	COUNT(DISTINCT runner_id) AS runners_count, 
    GROUP_CONCAT(DISTINCT runner_id) AS runners_id
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY week_number

-- 2. the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order
-- in this question i assume that this time is defined as the subtraction of the ORDER_TIME from the PICKUP_TIME

SELECT runner_id, 
	ROUND(AVG(
		TIMESTAMPDIFF(HOUR, order_time, pickup_time) * 60
        +
		TIMESTAMPDIFF(MINUTE, order_time, pickup_time)
        +
		TIMESTAMPDIFF(SECOND, order_time, pickup_time) / 3600
	), 1) AS average_time_in_minutes
FROM customer_orders 
INNER JOIN runner_orders 
	ON customer_orders.order_id = runner_orders.order_id 
WHERE cancellation IS NULL
GROUP BY runner_id

-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT num_of_pizzas, ROUND(AVG(time_diff), 1) AS avg_time, ROUND(STD(time_diff), 1) AS std
FROM
(SELECT customer_orders.order_id, COUNT(*) AS num_of_pizzas,
	(TIMESTAMPDIFF(HOUR, order_time, pickup_time) * 60
	+
	TIMESTAMPDIFF(MINUTE, order_time, pickup_time)
	+
	TIMESTAMPDIFF(SECOND, order_time, pickup_time) / 3600) AS time_diff
FROM customer_orders 
INNER JOIN runner_orders 
	ON customer_orders.order_id = runner_orders.order_id 
WHERE cancellation IS NULL
GROUP BY customer_orders.order_id
ORDER BY num_of_pizzas) AS time_differences
GROUP BY num_of_pizzas
-- It can be seen from the result set that there is a correlation between
-- the number of pizzas and the time that passed from the time of the order until the runner picked it up. 
-- The more pizzas, the longer the average time.

-- 4. Average distance travelled for each customer
-- in this question i assume that "travelled" means only the way to the customer and not back from him because 
-- the runner may have other orders that he took on the same trip and he does not return straight from there

SELECT customer_id, ROUND(AVG(distance), 1) AS average_distance_travelled
FROM customer_orders 
INNER JOIN runner_orders 
	ON customer_orders.order_id = runner_orders.order_id 
WHERE cancellation IS NULL
GROUP BY customer_id

-- 5. the difference between the longest and shortest delivery times for all orders

WITH order_delivery_time AS
(
	SELECT DISTINCT customer_orders.order_id, 
		ROUND(
			duration
			+
			(TIMESTAMPDIFF(HOUR, order_time, pickup_time) * 60
			+
			TIMESTAMPDIFF(MINUTE, order_time, pickup_time)
			+
			TIMESTAMPDIFF(SECOND, order_time, pickup_time) / 3600) 
			, 1) AS delivery_time
	FROM customer_orders 
	INNER JOIN runner_orders 
		ON customer_orders.order_id = runner_orders.order_id 
	WHERE cancellation IS NULL
)

SELECT MAX(delivery_time) AS longest_delivery_time, 
	MIN(delivery_time) AS shortest_delivery_time, 
    MAX(delivery_time) - MIN(delivery_time) AS diff_longest_shortest 
FROM order_delivery_time

-- 6. what was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT runner_id, 
	ROUND(AVG(distance / (duration / 60)), 1) AS kilometer_per_hour, 
    COUNT(*) AS num_of_deliveries
FROM runner_orders 
WHERE cancellation IS NULL
GROUP BY runner_id
-- The only significant thing i can see is that on average, runner 2 drives much faster than runners 1, 3.

-- 7. the successful delivery percentage for each runner

SELECT runner_id, 
	ROUND(COUNT(*) / (COUNT(*) + COUNT(NULLIF(cancellation, ''))) * 100, 1) AS successful_delivery_percentage
FROM runner_orders 
GROUP BY runner_id


C. Ingredient Optimisation

-- 1. the standard ingredients for each pizza

