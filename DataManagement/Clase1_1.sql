select * from actor;
select * from film_actor;
select * from film;

select a.actor_id, count(*) as num
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id
order by num desc;

select * from rental;
select * from staff;
select * from store;

select s.store_id, a.total
from
(select s.store_id, count(*) as total
from rental r
join staff s on r.staff_id = s.staff_id
group by s.store_id) as a
join store s on a.store_id = s.store_id;

select s.store_id, count(*) as total
from rental r
join staff s on r.staff_id = s.staff_id
group by s.store_id
having total > 3;

select f.film_id, f.title, a.first_name, a.last_name
from film_actor fa
join actor a on fa.actor_id = a.actor_id
join film f on fa.film_id = f.film_id
where f.film_id = 1;

select a.actor_id, fc.category_id, count(*)
from film_actor fa
join (
	select actor_id, first_name, last_name
	from actor
	where first_name like 'A%') as a
on fa.actor_id = a.actor_id
join film_category fc on fa.film_id = fc.film_id
group by a.actor_id, fc.category_id;

select actor_id, first_name, last_name
from actor
where first_name like 'A%';

select *
from film_actor
where actor_id = 29;

select *
from film_category
where film_id in (10,
79,
105,
110,
131,
133,
172,
226,
273,
282,
296,
311,
335,
342,
436,
444,
449,
462,
482,
488,
519,
547,
590,
646,
723,
812,
862,
928,
944) and category_id = 7;

