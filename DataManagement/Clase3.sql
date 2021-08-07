select last_name, count(*) as count 
from actor
group by last_name;

select * 
from actor 
where last_name = 'AKROYD';

select weekday(rental_date) as wday,
count(*)
from rental
group by wday;

select a.day, count(*) as count from
(select *, DAYOFWEEK(rental_date) as day from rental) as a
group by a.day
order by a.day;

select count(*) from
(select *, DAYOFWEEK(rental_date) as day from rental) as a
where a.day = 1;

select * from rental;

select p.customer_id, c.first_name, c.last_name, sum(amount)
from payment p
join customer c on p.customer_id = c.customer_id
group by customer_id;

select * 
from payment
where customer_id = 1;

create table actor2
select * from actor;

select * from actor2;

create table film2
select * from film;

create table address2
select * from address;


SELECT actor_id,
CASE
    WHEN actor_id < 10 THEN 'Primeros 10'
    WHEN actor_id > 10 and actor_id < 20 THEN 'Del 10 al 20'
    WHEN actor_id > 20 and actor_id < 30 THEN 'Del 20 al 30'
    ELSE 'A partir de 30'
END as caseId
FROM actor;