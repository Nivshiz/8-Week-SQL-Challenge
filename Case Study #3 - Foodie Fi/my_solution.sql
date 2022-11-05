-- Case Study #3 - Foodie Fi

-- A. Customer Journey
-- Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

/* 
From the example sample given, focusing on customer 1 for example, we can see that he subscribed to the service for the first time on the date of 2020-08-01.
A week later, his trial (free) plan has over and he downgraded the default pro monthly plan to the basic monthly plan.
This has been his plan since then.
*/

B. Data Analysis Questions

-- 1. How many customers has Foodie-Fi ever had?

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions

-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value.

SELECT MONTHNAME(start_date) AS month, COUNT(*) as count
FROM subscriptions
WHERE plan_id = 0
GROUP BY MONTHNAME(start_date)
ORDER BY start_date

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

SELECT plan_name, IFNULL(count, 0) AS count
FROM plans 
LEFT JOIN 
		(SELECT plan_id, COUNT(*) AS count
		FROM subscriptions 
		WHERE YEAR(start_date) > 2020
		GROUP BY plan_id) AS plan_exist_count
	ON plans.plan_id = plan_exist_count.plan_id
  
--4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

WITH churns AS 
(
	SELECT COUNT(DISTINCT customer_id) AS churns_count
	FROM subscriptions
	WHERE plan_id = 4
),
total_customers AS
(
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM subscriptions
)

SELECT churns_count, ROUND(churns_count/total_customers * 100, 1) AS percentage 
FROM total_customers, churns

-- 5. 
