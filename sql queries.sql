Select * from mytable;
select gender,sum(purchase_amount) as revenue
from mytable
group by gender;  

select customer_id, purchase_amount
from mytable
where discount_applied = 'Yes' and purchase_amount >= (select avg(purchase_amount) from mytable);

-- Q3: Which are the top 5 products with the highest average rating?

select 
    item_purchased, 
    round(avg(cast(review_rating as decimal(10,2))), 2) as "Average Product Rating"
from mytable
group by item_purchased
order by avg(review_rating) desc
limit 5; 

-- Compare the average purchase amounts betweenstandard express shipping
select 
    shipping_type,
    round(avg(purchase_amount), 2) as average_amount
from mytable
where shipping_type in ('Standard', 'Express')
group by shipping_type;
-- Q4. Do subscribed customers spend more? compare average spen and total revenue between sibcscribers and non subcribers.
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount), 2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from mytable
group by subscription_status
order by total_revenue, avg_spend desc;

-- Q5 which 5 products have the highest percentage  of purchase with  discounts applied 

select 
    item_purchased,
    round(100.0 * sum(case when discount_applied = 'Yes' then 1 else 0 end) / count(*), 2) as discount_rate
from mytable
group by item_purchased
order by discount_rate desc
limit 5;

-- Q6 segment customers into returning and loyal based on the pervious purchses and show the count pf each segment.

with customer_type as (
select customer_id, previous_purchases,
case when previous_purchases = 1 then 'New'
when previous_purchases between 2 and 10 then 'Returning'
else 'Loyal'
end as customer_segment
from mytable
)
select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment;
-- 5
with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id) DESC) as item_rank
from mytable
group by category, item_purchased
)

select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <=3; 

-- 7 Are customers are repeat buyyers?

select subscription_status,
count(customer_id) as repeat_buyers
from mytable
where previous_purchases >5
group by subscription_status;

-- 8 What is the revenue contribution of each age group?

select age_group,
sum(purchase_amount) as total_revenue
from mytable
group by age_group
order by total_revenue desc;
