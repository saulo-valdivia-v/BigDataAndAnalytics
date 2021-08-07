select 	c.customer_id as CustomerID, 
		c.email as CustomerEmail, 
        c.create_date as CreateDate, 
        WEEK(c.create_date) as WeekCreateDate, 
        sum(p.amount) as TotalAmount
from customer c
join payment p on c.customer_id = p.customer_id
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
where cat.name = 'Animation' and c.active = 1
group by c.customer_id, c.email, c.create_date, WEEK(c.create_date)
having TotalAmount >= 20;

select title as Title, SUBSTRING(description, 1, 20) as Description, length as Length,
CASE
    WHEN length >= 120 THEN "Greater than or equal to 2 hours"
    ELSE "Less than 2 hours"
END as Category
from film
where length >= 60;

select * from film;
select * from actor;
select * from film_actor
where actor_id = 1;

select a.actor_id as ActorID, a.first_name as FirstName, a.last_name as LastName, count(fa.film_id) as Total
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name
having Total > 30;

select * from customer;
select * from address;
select * from city;
select * from country;

select c.customer_id, c.first_name, c.last_name, a.address, ci.city, co.country
from customer c
join address a on c.address_id = a.address_id
join city ci on ci.city_id = a.city_id
join country co on co.country_id = ci.country_id
ORDER BY c.first_name;