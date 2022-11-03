<p align = "center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" 
        alt="Image" 
        width="500" 
        height="500"/>
</p>

###### [Click Here for the Complete Case Study](https://8weeksqlchallenge.com/case-study-1/)
# Case Study #1 - Danny's Diner
## Basic Description
This is a case study of a Japanese restaurant which operated for several months.
Danny, the owner, wants to answer some questions about the data collected during these months.

<details>
  <summary><b>The Database</b></summary>
  
<p align = "center">
<img src="https://user-images.githubusercontent.com/80172576/194739317-926904a1-253b-4b3a-87d0-122a6c9eb8c2.png" 
        alt="Image" 
        width="560" 
        height="315"/>
</p>

* **Table 1: sales**
  * The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.
product_id is a Foreign Key to the menu table, customer_id is a Foreign Key to the members table.

![image](https://user-images.githubusercontent.com/80172576/194229062-9f42c23e-dd6a-416f-8af7-727a4699b461.png)

* **Table 2: menu**
  * The menu table maps the product_id to the actual product_name and price of each menu item.

![image](https://user-images.githubusercontent.com/80172576/194229338-18386e58-91b4-47b4-85b6-22f210f3d3a1.png)

* **Table 3: members**
  * The members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.
  
![image](https://user-images.githubusercontent.com/80172576/194229499-e3878771-f738-44bb-bceb-5078d533963f.png)
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

#### [Solution](https://github.com/Nivshiz/8-Week-SQL-Challenge/blob/main/Case%20Study%20%231%20-%20Danny's%20Diner/my_solution.sql)
