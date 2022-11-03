<p align = "center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" 
        alt="Image" 
        width="500" 
        height="500"/>
</p>

###### [Click Here for the Complete Case Study](https://8weeksqlchallenge.com/case-study-2/)
# Case Study #2 - Pizza Runner
## Basic Description
This is a case study about a company the produces and sells pizzas, and deliver it with its own UBER couriers.
Danny, the owner, requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations and then answer some questions about his company.

<details>
  <summary><b>The Database</b></summary>
  
<p align = "center">
<img src="https://user-images.githubusercontent.com/80172576/194741373-e1a7a01a-2c27-4efe-8db3-4811c372eecc.png" 
        alt="Image" 
        width="833" 
        height="463"/>
</p>


* **Table 1: runners**
  * The runners table shows the ***registration_date*** for each new runner.

![image](https://user-images.githubusercontent.com/80172576/194741804-8cc2ce8d-488c-4b1b-a9df-30468f06fc95.png)

* **Table 2: customer_orders**
  * Customer pizza orders are captured in the ***customer_orders*** table with 1 row for each individual pizza that is part of the order.
  * The ***pizza_id*** relates to the type of pizza which was ordered.
  * The ***exclusions*** are the ***ingredient_id*** values which should be removed from the pizza.
  * The ***extras*** are the ***ingredient_id*** values which need to be added to the pizza.

![image](https://user-images.githubusercontent.com/80172576/194741783-2bbc3871-fbda-4805-8981-447399114efa.png)

* **Table 3: runners_orders**
  * After each orders are received through the system - they are assigned to a runner - however not all orders are fully completed and can be ***cancelled*** by the restaurant or the customer.
  * The ***pickup_time*** is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas. 
  * The ***distance*** and ***duration*** fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

![image](https://user-images.githubusercontent.com/80172576/194741767-22f2bd4b-367d-4be3-9230-d31a6ffcf09a.png)
        
* **Table 4: pizza_names**
  * There are only 2 pizzas available: the Meat Lovers or Vegetarian.
        
![image](https://user-images.githubusercontent.com/80172576/194741736-67b4f0c2-deef-4665-a4a0-1772293f4d5f.png)
        
* **Table 5: pizza_recipes**
  * Each ***pizza_id*** has a standard set of ***toppings*** which are used as part of the pizza recipe.
        
![image](https://user-images.githubusercontent.com/80172576/194741721-c3db9b30-c9ba-4998-afa8-df05f65c1e3f.png)
        
* **Table 6: pizza_toppings**
  * This table contains all of the ***topping_name*** values with their corresponding ***topping_id*** value.
       
![image](https://user-images.githubusercontent.com/80172576/194741706-b8518da2-bed9-4af6-bb29-7b003b5c0bea.png)


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
