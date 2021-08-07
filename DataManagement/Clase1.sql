select * from film;

SELECT 	actor_id AS ID,
		first_name AS FirstName,
        last_name AS SecondName
FROM actor;

select * from actor
limit 10;

select address_id as ID, address as Address, postal_code as PostalCode, phone as Phone from address;

select * from address limit 10;

select * from film
where rental_duration in (1, 2, 5, 6);

select first_name
from customer
where customer_id = 2;

select *
from film
order by length;

select *
from film
order by length desc;

select *
from film;

update film
set release_year = 2008
where film_id = 1000;

select *
from film
order by release_year;

select * from actor;

insert into actor
values(201, 'Saulo', 'Valdivia', '2006-02-15');

insert into film
values(1001, 'Cadena Perpetua', 'Un hombre inocente es enviado a una corrupta penitenciaria de Maine en 1947 y sentenciado a dos cadenas perpetuas por un doble asesinato.', 1995, 1, null, 15, 3.01, 35, 30.00, 'NC-17', 'Trailers', '2020-12-17');

select * from actor;

update actor
set first_name = 'Antonio', last_name = 'Banderas'
where actor_id = 201;

update film
set title = 'CADENA PERPETUA', description = 'Un hombre inocente es enviado a una corrupta penitenciaria de Maine en 1947 y sentenciado a dos cadenas perpetuas por un doble asesinato.', release_year = 1995, rental_duration = 45, rental_rate = 3.45, length = 50, replacement_cost = 20.00, rating = 'NC-17', special_features = 'Trailers,Deleted Scenes'
where film_id = 1001;

DESCRIBE film;

select * from actor;
delete from actor where actor_id = 201;

delete from film where film_id = 1001;
select * from film;

create view view_actor as
select * from actor;

select * from view_actor;


select * from film;

delete from film where film_id = 1;

select * from film_category where film_id = 1;
select * from film_actor where film_id = 1;
select * from film_text where film_id = 1;
select * from inventory where film_id = 1;

delete from film_category where film_id = 1;
delete from film_actor where film_id = 1;
delete from film_text where film_id = 1;

select * from inventory where film_id = 1;
select * from rental where inventory_id in (1,2,3,4,5,6,7,8);

delete from rental where inventory_id in (1,2,3,4,5,6,7,8);

delete from inventory where film_id = 1;
delete from film where film_id = 1;

delete a
from rental a
inner join inventory b
on a.inventory_id = b.inventory_id
where film_id = 1;

insert into customer_denormalize
select customer_id, first_name, last_name, address, cirty, country
from customer a
inner join address b
on a.address_id = b.address_id
inner join city c
on b.city_id = c.city_id
inner join country d
on c.country_id = d.country_id;

update customer
set customer_id = -2
where customer_id = 2;

ALTER TABLE rental DROP FOREIGN KEY fk_rental_customer; 
ALTER TABLE payment DROP FOREIGN KEY fk_payment_customer; 

alter table customer
modify column customer_id smallint not null;

ALTER TABLE table_name ENABLE KEYS;

select c.*
from customer c
join payment p on c.customer_id = p.customer_id
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
where cat.name = 'Animation'
and c.customer_id in (54, 82);