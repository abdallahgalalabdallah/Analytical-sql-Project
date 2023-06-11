--Q3
--a--What is the maximum number of consecutive days a customer made purchases?
---My algorithm 
---- first iwill  select the prev of each transaction day  to  get different between them 
---- second  i will get diffeet between the current day (transaction day ) and the previous day in the order and i will ranking its  partition by cust_id order by calendar_dt desc
---- third i will  filterf it where diff between current day and prev not = null or not=1  and i will get diff between each rank and the prev rank this will return  all number of connceive for each  customer 
----fourth  iwill get max conn days for each customer 
select cust_id,max(con_days) max_con_days
from(
    select gap.*,lag(rank_) over(partition by cust_id order by calendar_dt desc) as lag,rank_-nvl(lag(rank_) over(partition by cust_id order by calendar_dt desc),0) as con_days 
    from(
    select l.*,calendar_dt-perv_day as diff, rank ()
                        over (partition by cust_id order by calendar_dt desc)    as rank_
    from
        (
        select cust_id,calendar_dt,lead (calendar_dt)
                            over(partition by cust_id order by calendar_dt desc ) as perv_day
        from customer_purchacing) l) gap
    where diff!=1 or diff is null
)
group by cust_id 
order by max_con_days desc
;
