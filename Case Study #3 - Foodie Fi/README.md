<p align = "center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/3.png" 
        alt="Image" 
        width="500" 
        height="500"/>
</p>

###### <div align="center">[Click Here for the Complete Case Study](https://8weeksqlchallenge.com/case-study-3/)</div>
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
  * When customers cancel their Foodie-Fi service - they will have a ***churn*** plan record with a ***null*** price but their plan will continue until the end of the billing period.

![image](https://user-images.githubusercontent.com/80172576/199712350-db5fa605-4b98-4f9e-80bd-2fd5bfafca57.png)


* **Table 2: subscriptions**
  * Customer subscriptions show the exact date where their specific ***plan_id*** starts.
  * If customers downgrade from a pro plan or cancel their subscription - the higher plan will remain in place until the period is over - the ***start_date*** in the subscriptions table will reflect the date that the actual plan changes.
  * When customers upgrade their account from a basic plan to a pro or annual pro plan - the higher plan will take effect straightaway.
  * When customers churn - they will keep their access until the end of their current billing period but the ***start_date*** will be technically the day they decided to cancel their service.

![image](https://user-images.githubusercontent.com/80172576/199713871-7974a226-a8c3-454b-8cee-81f6e0c44ece.png)
        
</details>

<details>
  <summary><b>Case Study Questions</b></summary>

### A. Customer Journey
Based off the 8 sample customers provided in the sample from the subscriptions table, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!
        
### B. Data Analysis Questions
* How many customers has Foodie-Fi ever had?
* What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
* What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
* What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
* How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?
* What is the number and percentage of customer plans after their initial free trial?
* What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
* How many customers have upgraded to an annual plan in 2020?
* How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
* Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
* How many customers downgraded from a pro monthly to a basic monthly plan in 2020?
        
### C. Challenge Payment Question
The Foodie-Fi team wants you to create a new payments table for the year 2020 that includes amounts paid by each customer in the subscriptions table with the following requirements:

* monthly payments always occur on the same day of month as the original start_date of any monthly paid plan.
* upgrades from basic to monthly or pro plans are reduced by the current paid amount in that month and start immediately.
* upgrades from pro monthly to pro annual are paid at the end of the current billing period and also starts at the end of the month period.
* once a customer churns they will no longer make payments.
        
Example outputs for this table might look like the following:
        
![image](https://user-images.githubusercontent.com/80172576/199714963-2b2b10fd-42d6-4c27-b803-09c5b611dfcf.png)

### D. Outside The Box Questions
The following are open ended questions which might be asked during a technical interview for this case study - there are no right or wrong answers, but answers that make sense from both a technical and a business perspective make an amazing impression!

* How would you calculate the rate of growth for Foodie-Fi?
* What key metrics would you recommend Foodie-Fi management to track over time to assess performance of their overall business?
* What are some key customer journeys or experiences that you would analyse further to improve customer retention?
* If the Foodie-Fi team were to create an exit survey shown to customers who wish to cancel their subscription, what questions would you include in the survey?
* What business levers could the Foodie-Fi team use to reduce the customer churn rate? How would you validate the effectiveness of your ideas?
        

</details>

#### [Solution](https://github.com/Nivshiz/8-Week-SQL-Challenge/blob/main/Case%20Study%20%233%20-%20Foodie%20Fi/my_solution.sql)
