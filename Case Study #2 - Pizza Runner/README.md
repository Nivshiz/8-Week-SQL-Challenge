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
<br><b>1.</b> What is the total amount each customer spent at the restaurant?</br>
<br><b>2.</b> How many days has each customer visited the restaurant?</br>
<br><b>3.</b> What was the first item from the menu purchased by each customer?</br>
<br><b>4.</b> What is the most purchased item on the menu and how many times was it purchased by all customers?</br>
<br><b>5.</b> Which item was the most popular for each customer?</br>
<br><b>6.</b> Which item was purchased first by the customer after they became a member?</br>
<br><b>7.</b> Which item was purchased just before the customer became a member?</br>
<br><b>8.</b> What is the total items and amount spent for each member before they became a member?</br>
<br><b>9.</b> If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?</br>
<br><b>10.</b> In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?</br>

</details>
