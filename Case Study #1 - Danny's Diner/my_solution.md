# 1.
SELECT customer_id, SUM(price) AS total_sales 
FROM sales 
INNER JOIN menu 
	ON sales.product_id = menu.product_id 
GROUP BY customer_id;

2.
SELECT customer_id, COUNT(DISTINCT order_date) AS total_visits
FROM sales
GROUP BY customer_id

3.
SELECT sales.customer_id, GROUP_CONCAT(DISTINCT product_name) AS items_on_first_order
FROM sales 
INNER JOIN (SELECT customer_id, MIN(order_date) AS first_date
			FROM sales
			GROUP BY customer_id) AS cust_first_date
	ON sales.customer_id = cust_first_date.customer_id 
		AND sales.order_date = cust_first_date.first_date
INNER JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY customer_id

4.
SELECT product_name, COUNT(*) AS orders
FROM sales
INNER JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY product_name
HAVING orders =
	(SELECT MAX(total_orders) AS num_of_purchases
	FROM
		(SELECT COUNT(*) AS total_orders
		FROM sales
		GROUP BY product_id) AS product_count)

5.
SELECT customer_id, product_name, orders_count
FROM
	(SELECT customer_id, sales.product_id, product_name, COUNT(sales.product_id) AS orders_count,
		 RANK() OVER(PARTITION BY customer_id ORDER BY COUNT(sales.product_id) DESC) AS ranking
	FROM sales
	INNER JOIN menu
		ON sales.product_id = menu.product_id
	GROUP BY customer_id, product_id) AS cust_prod_count
WHERE ranking = 1

6.
SELECT sales.customer_id, product_name, MIN(order_date) AS order_date
FROM sales 
INNER JOIN members 
	ON sales.customer_id = members.customer_id 
INNER JOIN menu
	ON sales.product_id = menu.product_id
WHERE order_date >= join_date
GROUP BY sales.customer_id

7.
SELECT sales.customer_id, product_name, order_date
FROM sales
INNER JOIN (SELECT sales.customer_id, MAX(order_date) AS date_before_member
			FROM sales 
			INNER JOIN members 
				ON sales.customer_id = members.customer_id 
			INNER JOIN menu
				ON sales.product_id = menu.product_id
			WHERE order_date < join_date
			GROUP BY customer_id) AS customer_date_before_member
	ON sales.customer_id = customer_date_before_member.customer_id 
		AND sales.order_date = customer_date_before_member.date_before_member
INNER JOIN menu
	ON sales.product_id = menu.product_id

8.
SELECT sales.customer_id, COUNT(*) AS total_items, SUM(price) AS total_amount_spent
FROM sales 
INNER JOIN (SELECT DISTINCT sales.customer_id, join_date
			FROM sales
			LEFT JOIN members
				ON sales.customer_id = members.customer_id) AS cust_join_date
	ON sales.customer_id = cust_join_date.customer_id
INNER JOIN menu
	ON sales.product_id = menu.product_id
WHERE order_date < join_date OR join_date IS NULL
GROUP BY customer_id

9.
SELECT sales.customer_id,
	SUM(CASE
		WHEN product_name = 'sushi' THEN price*20
        ELSE price*10
        END) AS points
FROM sales 
INNER JOIN (SELECT DISTINCT sales.customer_id, join_date
			FROM sales
			LEFT JOIN members
				ON sales.customer_id = members.customer_id) AS cust_join_date
	ON sales.customer_id = cust_join_date.customer_id
INNER JOIN menu
	ON sales.product_id = menu.product_id
GROUP BY customer_id

10.
SELECT sales.customer_id,
	SUM(CASE
		WHEN product_name = 'sushi' THEN price*20
        WHEN order_date BETWEEN join_date AND date_add(join_date, INTERVAL 6 day) THEN price*20
        ELSE price*10
        END) AS points
FROM sales 
INNER JOIN (SELECT DISTINCT sales.customer_id, join_date
			FROM sales
			INNER JOIN members
				ON sales.customer_id = members.customer_id) AS cust_join_date
	ON sales.customer_id = cust_join_date.customer_id
INNER JOIN menu
	ON sales.product_id = menu.product_id
WHERE order_date <= '2021-01-31'
GROUP BY sales.customer_id
