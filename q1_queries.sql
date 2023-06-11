--q1 

--- customer who acheive most sales 
-----first i  will sum price for each customer to get sales for each customer
---second i will rank customer per each sales the highst will ranking 1 and the last will be 110
----here we find that the highst customer achieve sales is 12748 
select customer_id,sales_,rank() over(order by sales_ desc) rank_
from
(select customer_id,sales_
from(
select customer_id ,invoicedate,price,sum(price) over(partition by customer_id order by invoicedate rows between unbounded preceding and unbounded following ) as sales_
from  tableRetail
)
group by customer_id,sales_ 
order by sales_ desc);
----------------------------------------------------------------------------
--- second query 
-- which month achieve highst sales  the highst month on sales is november  and the less month is jaun 
select month, sales_per_month
from(
select m.* ,sum(price) over(partition by month) as sales_per_month
from
(select t.*,to_char(to_date(invoicedate,'mm/dd/yyyy hh24:mi'),'mm')as month
from tableRetail t) m
order by sales_per_month desc)
group by month , sales_per_month
order by  sales_per_month desc;

----------------------------------------------------------------------------------------------------------------------------
----4 query  
select * 
from tableRetail

--  the data contain sales in two years 2010 and  2011 iwill  show  which quarter in 2years  achieve highst sales 
-- the highst quarter achieve sales is the 4 quarter this mean  almostly this because the offer at the end of the year and the black friday sales
select distinct quarter,sum(price) over(partition by quarter) as quarter_sales
from(
select t.*,to_char(to_date(invoicedate,'mm/dd/yyyy hh24:mi'),'q')as quarter
from tableRetail t)
order by  quarter_sales desc;

-------------------------------------------------------------------------------------------------------------------
----query 5
-- we have 2335 stock  saled in 2010 and 2011  
-- we want see which stock is return highst sales 
select count(distinct stockcode)
from tableRetail;

--- which stock return highst sales 
-- the highst stock is the stock with code : M   so we can increase this stock to achieve more sales  
select distinct stockcode,stock_sales
from(
select  stockcode,quantity,price ,sum(price) over(partition by stockcode) stock_sales
from tableRetail)
order by stock_sales desc;


-----------------------------------------------------------------------------------------------------------
---q6 which year acheive  highst sales   to see the sales are increasing or not  
----2011 is highst than 2010
----in 2011 achieve sales 29489.72 more than 2010
select year ,year_sales,lag(year_sales) over(order by year_sales ) as lag ,(year_sales-nvl(lag(year_sales) over(order by year_sales ),0)) as diff
from(
select distinct year ,sum(price) over(partition by year) as year_sales
from(
select t.*,to_char(to_date(invoicedate,'mm/dd/yyyy hh24:mi'),'yyyy')as year
from tableRetail t)
order by year_sales desc);

-------------------------------------------------------------------------------------------------------
----q7  average quantity per each stock  to  see which stock is more quantity
select  distinct stockcode ,avg(quantity) over(partition by stockcode) q_avg
from tableRetail
order by q_avg desc;


