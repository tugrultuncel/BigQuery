-- Select & From
-- Select From pattern is the fundamental of SQL
-- SQL Language written for what to get
-- not how to get. Database itself figures out
-- how to get. Data analyst job is about
-- thinkin' in sets and transformations

select user_id, amount
from project.dataset.orders

-- give me a copy of this table, but only these columns. 
-- this called projection, not window.

Select user_id, amount
from project.dataset.orders
where status = 'completed'

-- logic= first throw away all columns I dont want to fetch, then work with whats left.
-- Key Rule = Select>From>Where, where works on raw rows, before any calculation or grouping

Select user_id,
from project.dataset.orders
group by user_id

-- group by callopses rows that share same value into single row.
-- imagine you have pile of receipts, group by sorts tem into piles by user.
-- now you will have pile per user. individual rows will vanish.
-- RULE = once you group by you can only work with the column you group
-- and aggreagations of the whole pile (count, sum,min,max,avg)

-- you can not ask "what is amount?" because each pile has many amounts, you have to ask
-- "what is the total amount?" 

select
    user_id,
    count(*)    as total_orders,
    sum(amount) as total_spend,
    min(order_ts)   as first_order,
    max(order_ts)   as last_order,
from project.dataset.orders
where status = 'completed'
group by user_id

-- now you have one row per user with aggregated values.
-- HAVING filter those grouped rows.

select
    user_id,
    sum(amount) as total_spend
from project.dataset.orders
where status = "completed"
group by user_id
having sum(amount) > 10000

-- why not WHERE? because where stage comes after from statement
-- the stage where piles dont exist yet.
-- total_spend doesnt exist yet. 
-- HAVING runs after Grouping
-- RULE= where> filters raw rows > before grouping
-- RULE= having> filters groups > after grouping
-- RULE= WHERE > GROUP BY > HAVING

---------------------------------------------------

-- now you have 2 tables to join from shared key.

select
    o.user_id,
    u.country,
    sum(o.amount) as total_spend
from project.dataset.orders as o
join project.dataset.users as u ON o.user_id = u.user.id
where o.status = 'completed'
group by 
    o.user_id,
    u.country

-- Mental model= for each order row, go findmatching user row and attach it.
-- now you have one wide row populated from each tables.
-- why does country go in Group BY?
-- because you selected it and it's not a aggregate column in select must be in Group by
-- bigquery will errir if not

----------------------------------------------------

-- the execution order is everything
-- MEMORIZE =
-- SELECT = pick columns
-- FROM = start with this table
-- Where = filter raw rows
-- group by = collapse into piles
-- HAving = filter piles
-- order by = sorting method is important for limiting and the ofset
-- limit = fetch n size rows

-- NOTE ! 
-- select is written firs but read after WHERE 