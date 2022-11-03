<p align = "center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" 
        alt="Image" 
        width="500" 
        height="500"/>
</p>

###### [Click Here for the Complete Case Study](https://8weeksqlchallenge.com/case-study-3/)
# Case Study #3 - Foodie Fi
## Basic Description
This case study focuses on using subscription style digital data to answer important business questions.

<details>
  <summary><b>The Database</b></summary>
  
<p align = "center">
<img src="https://user-images.githubusercontent.com/80172576/199710652-17542c70-9a80-4370-8a5f-62bfaf0249b5.png" 
        alt="Image" 
        width="433" 
        height="200"/>
</p>


* **Table 1: plans**
  * The plans table contain the available plans that a customer can join at their sign up.
  * Basic plan customers have limited access and can only stream their videos and is only available monthly at $9.90.
  * Customers can sign up to an initial 7 day free trial will automatically continue with the pro monthly subscription plan unless they cancel, downgrade to basic or upgrade to an annual pro plan at any point during the trial.
  * When customers cancel their Foodie-Fi service - they will have a churn plan record with a null price but their plan will continue until the end of the billing period.

![image](https://user-images.githubusercontent.com/80172576/199712350-db5fa605-4b98-4f9e-80bd-2fd5bfafca57.png)


* **Table 2: subscriptions**
  * Customer subscriptions show the exact date where their specific ***plan_id*** starts.
  * If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the ***start_date*** in the subscriptions table will reflect the date that the actual plan changes.
  * When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.
  * When customers churn - they will keep their access until the end of their current billing period but the ***start_date*** will be technically the day they decided to cancel their service.


</details>

<details>
  <summary><b>Case Study Questions</b></summary>

This case study has many questions, therefore they are broken up by area of focus including:

* Pizza Metrics
* Runner and Customer Experience
* Ingredient Optimisation
* Pricing and Ratings
* Bonus DML Challenges (DML = Data Manipulation Language)

        
**Before writing SQL queries, there is a need to investigate the data, and do something with those null values and data types in the ***customer_orders*** and ***runner_orders*** tables.**

        
### A. Pizza Metrics
* How many pizzas were ordered?
* How many unique customer orders were made?
* How many successful orders were delivered by each runner?
* How many of each type of pizza was delivered?
* How many Vegetarian and Meatlovers were ordered by each customer?
* What was the maximum number of pizzas delivered in a single order?
* For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
* How many pizzas were delivered that had both exclusions and extras?
* What was the total volume of pizzas ordered for each hour of the day?
* What was the volume of orders for each day of the week?
        
### B. Runner and Customer Experience
* How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
* What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
* Is there any relationship between the number of pizzas and how long the order takes to prepare?
* What was the average distance travelled for each customer?
* What was the difference between the longest and shortest delivery times for all orders?
* What was the average speed for each runner for each delivery and do you notice any trend for these values?
* What is the successful delivery percentage for each runner?
        
### C. Ingredient Optimisation
* What are the standard ingredients for each pizza?
* What was the most commonly added extra?
* What was the most common exclusion?
* Generate an order item for each record in the customers_orders table in the format of one of the following:
    * Meat Lovers
    * Meat Lovers - Exclude Beef
    * Meat Lovers - Extra Bacon
    * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
* Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
    * For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
* What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
        
### D. Pricing and Ratings
* If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
* What if there was an additional $1 charge for any pizza extras?
    * Add cheese is $1 extra
* The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
* Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
    * customer_id
    * order_id
    * runner_id
    * rating
    * order_time
    * pickup_time
    * Time between order and pickup
    * Delivery duration
    * Average speed
    * Total number of pizzas
* If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
        
### E. Bonus Questions
* If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?

</details>

#### [Solution](https://github.com/Nivshiz/8-Week-SQL-Challenge/blob/main/Case%20Study%20%232%20-%20Pizza%20Runner/my_solution.sql)
