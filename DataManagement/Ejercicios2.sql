#Email de clientes que se han gastado más de 20 euros en películas de acción
select * from customer;
select * from payment;
select * from rental;
select * from inventory;
select * from category;

select c.customer_id, c.email, sum(amount) as total
from customer c
join payment p on c.customer_id = p.customer_id
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film_category fc on i.film_id = fc.film_id
where fc.category_id = 1
group by customer_id
having total >20;

#Título de películas que si que tienen inventario y que nunca se han alquilado
select * from rental;
select * from inventory;

select *
from inventory
where inventory_id not in (
select inventory_id from rental
);

select * from inventory where film_id = 1;

#Ciudad con más clientes por cada uno de los países
select * from customer;
select * from address;
select * from city;

select c.country_id, c.city_id, count(a.address_id) as total
from address a
join city c on a.city_id = c.city_id
group by c.country_id, c.city_id
order by total desc;

select a.country_id, a.city_id, max(a.total)
from
(select c.country_id, c.city_id, count(a.address_id) as total
from address a
join city c on a.city_id = c.city_id
join customer cu on a.address_id = cu.address_id
group by c.country_id, c.city_id
order by total desc) as a
group by a.country_id;

select a.*
from address a
join city c on a.city_id = c.city_id
where c.country_id = 1 and c.city_id = 251;

#Cuanto dinero ha ganado cada una de las tiendas
select * from payment;
select * from staff;

select p.staff_id, sum(p.amount)
from payment p
join staff s on p.staff_id = s.staff_id
group by staff_id;

#Cantidad de veces que se repite la letra 'A' en cada uno de las descripciones de las películas, sin tener en cuenta si es mayúscula o no
select * from film;

select film_id, LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', '')) as 'number'
from film;

#Película que más tiempo ha sido alquilada (deberemos de comparar las fechas con tiempo UNIX), si hay más de una, deberemos de mostrar la de mayor id
#Semana del año en la que se han alquilado más películas
#Ganancia media,de cada una de las tiendas, al día
