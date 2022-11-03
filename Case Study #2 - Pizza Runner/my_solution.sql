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
-- For this question firstly i created a new view that represent the normalized pizza and it's toppings
CREATE VIEW normalized_toppings AS
	SELECT 1 AS pizza_id, 1 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 2 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 3 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 4 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 5 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 6 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 8 AS topping
    UNION ALL
    SELECT 1 AS pizza_id, 10 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 4 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 6 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 7 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 9 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 11 AS topping
    UNION ALL
    SELECT 2 AS pizza_id, 12 AS topping;
    
SELECT pizza_name, GROUP_CONCAT(topping_name ORDER BY topping_name SEPARATOR ", ")
FROM
	(SELECT *
	FROM normalized_toppings
	INNER JOIN pizza_names 
		USING(pizza_id)
	INNER JOIN pizza_toppings 
		ON normalized_toppings.topping = pizza_toppings.topping_id) AS a
GROUP BY pizza_name

-- 2. the most commonly added extra

WITH toppings_count AS
(
	SELECT 1 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%1%'
	UNION ALL 
	SELECT 2 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%2%'
	UNION ALL 
	SELECT 3 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%3%'
	UNION ALL 
	SELECT 4 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%4%'
	UNION ALL 
	SELECT 5 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%5%'
	UNION ALL 
	SELECT 6 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%6%'
	UNION ALL 
	SELECT 7 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%7%'
	UNION ALL 
	SELECT 8 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%8%'
	UNION ALL 
	SELECT 9 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%9%'
	UNION ALL 
	SELECT 10 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%10%'
	UNION ALL 
	SELECT 11 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%11%'
	UNION ALL 
	SELECT 12 AS topping, COUNT(*) AS count FROM customer_orders WHERE extras LIKE '%12%'
)

SELECT topping_name, count
FROM toppings_count 
INNER JOIN pizza_toppings 
	ON toppings_count.topping = pizza_toppings.topping_id 
WHERE count = (SELECT MAX(count) FROM toppings_count)

-- 3. the most common exclusion

WITH toppings_count AS
(
	SELECT 1 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%1%'
	UNION ALL 
	SELECT 2 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%2%'
	UNION ALL 
	SELECT 3 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%3%'
	UNION ALL 
	SELECT 4 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%4%'
	UNION ALL 
	SELECT 5 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%5%'
	UNION ALL 
	SELECT 6 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%6%'
	UNION ALL 
	SELECT 7 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%7%'
	UNION ALL 
	SELECT 8 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%8%'
	UNION ALL 
	SELECT 9 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%9%'
	UNION ALL 
	SELECT 10 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%10%'
	UNION ALL 
	SELECT 11 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%11%'
	UNION ALL 
	SELECT 12 AS topping, COUNT(*) AS count FROM customer_orders WHERE exclusions LIKE '%12%'
)

SELECT topping_name, count
FROM toppings_count 
INNER JOIN pizza_toppings 
	ON toppings_count.topping = pizza_toppings.topping_id 
WHERE count = (SELECT MAX(count) FROM toppings_count)

-- 4. generating an order item for each record in the customers_orders table in the given format

SELECT *, 
	CASE
		WHEN pizza_id = 2 THEN 'veg'
		WHEN extras = 0 AND exclusions = 0 THEN 'Meat Lovers'
        WHEN exclusions LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Beef')) THEN 'Meat Lovers - Exclude Beef'
        WHEN extras LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Bacon')) THEN 'Meat Lovers - Extra Bacon'
        WHEN exclusions LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Cheese'))
			AND exclusions LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Bacon'))
			AND extras LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Mushroom'))
            AND extras LIKE INSERT('%%', 2, 1, (SELECT topping_id FROM pizza_toppings WHERE topping_name = 'Peppers'))
            THEN 'Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers'
		ELSE 'Other'
        END AS order_item
FROM customer_orders


-- D. Pricing and Ratings

-- 1. total revenue where a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes and no delivery fees

SELECT *,
	CASE pizza_id
		WHEN 1 THEN pizza_count * 12
        ELSE pizza_count * 10
	END AS revenue
FROM
	(SELECT DISTINCT pizza_id, COUNT(pizza_id) OVER(PARTITION BY pizza_id) AS pizza_count
	FROM
		(SELECT customer_orders.*
		FROM customer_orders
		INNER JOIN runner_orders
			ON customer_orders.order_id = runner_orders.order_id
		WHERE cancellation IS NULL) AS bla) AS blabla

-- 2. total revenue with extras (each extra added costs $1)

SELECT SUM(pizza_revenue) + SUM(extras_count) AS total_revenue
FROM
	(SELECT
	CASE pizza_id
		WHEN 1 THEN 12
		ELSE 10
		END AS pizza_revenue,
	CASE
		WHEN extras = 0 THEN 0
		ELSE LENGTH(TRIM(BOTH ',' FROM extras)) - LENGTH(REPLACE(TRIM(BOTH ',' FROM extras), ',', '')) + 1
		END AS extras_count
	FROM customer_orders
    INNER JOIN runner_orders
		ON customer_orders.order_id = runner_orders.order_id
	WHERE cancellation IS NULL) AS pizzas_revenues

-- 3. creating a new table contains a synthetic runners rating (by customers)
-- My assumption is that for each order the customer is able to rate it's runner

CREATE TABLE order_rating(
	order_id INT NOT NULL,
        customer_id INT NOT NULL,
        runner_id INT NOT NULL
	rate INT NOT NULL
);

INSERT INTO order_rating(order_id, customer_id, runner_id, rate)
VALUES
	(1,101,1,1),
	(2,101,1,5),
	(3,102,1,4),
	(4,103,2,5),
	(5,104,3,4),
	(7,105,2,2),
	(8,102,2,2),
	(10,104,1,3);

-- 4. 
