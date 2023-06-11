---q3 b
----------------------------------------------------
---
--1 first t want to sum amt_le partirion by cusromer 
--2 i will ranking each row(transaction)  partition by customer  oreder by date to make me able to access the nunmber of the transaction that customer acheive 250
--3 new column calendar_dt - first day that the customer  make transaction (dufference between first day and the current day(wich the day the customer achieve 250)
--4 iwill extract notransaction and day for each customer distinct and get averge
select avg(trans),avg(days)
from(
select   distinct cust_id,first_value(num_of_trans) over(partition by cust_id order by calendar_dt) trans,first_value(no_days) over(partition by cust_id order by calendar_dt) days
from(
select customer_purchacing.* , sum(amt_le) over(partition by cust_id order by calendar_dt) as sum_sales,rank() over(partition by cust_id order by calendar_dt) as num_of_trans,
calendar_dt -first_value(calendar_dt) over(partition by cust_id order by calendar_dt) as no_days 
from customer_purchacing)
where sum_sales>=250
order by cust_id);
