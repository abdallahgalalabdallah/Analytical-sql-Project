--The customers will be grouped based on 3 main values 
--• Recency => how recent the last transaction is (Hint: choose a reference date, which is 
--the most recent purchase in the dataset ) 
--• Frequency => how many times the customer has bought from our store 
--• Monetary => how much each customer has paid for our products

select distinct customer_id,recency,frequency,mentory,r_score,fm_score,
    case 
    when r_score =4 and fm_score=5 or r_score=5 and fm_score=5 or r_score=5 and fm_score=4  then 'champions'
    when (r_score =5 and fm_score=2) or (r_score=4 and fm_score=2) or (r_score=3 and fm_score=3) or (r_score=4 and fm_score=3) then 'potential loyalists'
    when  (r_score =5 and fm_score=3) or (r_score=4 and fm_score=4) or (r_score=3 and fm_score=5) or (r_score=3 and fm_score=4) then 'Loyal Customers'
    when (r_score =5 and fm_score=1) then 'recent customers'
    when (r_score =4 and fm_score=1) or (r_score=3 and fm_score=1) then 'promising'
    when (r_score =3 and fm_score=2) or (r_score=2 and fm_score=3) or (r_score=2 and fm_score=2)  then 'Customers Needing Attention'
    when  (r_score =2 and fm_score=5) or (r_score=2 and fm_score=4) or (r_score=1 and fm_score=3) then 'At Risk'
    when (r_score =1 and fm_score=5) or (r_score=1 and fm_score=4) then 'Cant Lose Them'
    when (r_score =1 and fm_score=2) then 'Hibernating'
    else 'Lost'
    end cust_seement
from(

select distinct customer_id,recency,frequency,mentory,r_score,ntile(5) over(order by avg_fm_score) as fm_score
from(
select  distinct customer_id,recency,frequency,mentory,ntile(5) over(order by recency desc) as r_score,(frequency+mentory)/2 as avg_fm_score
from(
select distinct customer_id,last_cust,max_date,recency,count(invoice) over(partition by customer_id) as frequency,sum(price) over(partition by customer_id) as mentory
from (
select distinct customer_id,price,invoice,last_cust,max_date,round(max_date-last_cust) as recency 
from(
select distinct customer_id,price ,invoice ,max(to_date(invoicedate,'mm/dd/yyyy hh24:mi'))over() max_date,
            last_value( to_date(invoicedate , 'MM/DD/YYYY hh24:mi'))over(partition by customer_id order by to_date(invoicedate , 'MM/DD/YYYY hh24:mi') rows between unbounded preceding and unbounded following ) last_cust
from tableretail)  ))))
order by customer_id;




