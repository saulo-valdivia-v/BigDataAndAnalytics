#Informe con nombres de clientes, mostrando el campo activo con valores 'Activo' 
#cuando es 1 e 'Inactivo' cuando es 0, mostrando el país donde residen y ocultando el email con tantos 
#'*' como letras tenga el mismo cuando el usuario esté inactivo.

select customer_id, first_name, last_name, address_id, active, email
from customer
where active = 1;

select customer_id, first_name, last_name, address_id, active, REPEAT ("*", length(email)) as mail
from customer
where active = 0;

#Cantidad de películas que duran menos o igual a una hora, más de una hora y más o igual a dos horas
select cat, count(*) from
(select length, count(*), 'uno' as cat
from film
where length <= 60
union
select length, count(*), 'dos' as cat
from film
group by length
having length > 60 and length < 120
union
select length, count(*), 'tres' as cat
from film
group by length
having length > 120) as f
group by cat;

select * from film where length <= 60;

select (case when length <= 60 then '<=1'
			 when length between 61 and 119 then '>1<2'
             when length >= 120 then '>=2' end) as length,
             count(*) as quantity
from film
group by (CASE WHEN length <= 60 then '<=1'
			   WHEN length between 61 and 119 then '>1'
               WHEN length >= 120 then '<=2' end);

select
sum(if(length <= 60,1,0)) as menor60,
sum(if(length > 60 and length < 120,1,0)) as mayor60,
sum(if(length >= 120,1,0)) as mayor120
from film;

select
count(if(length <= 60,'hola',NULL)) as menor60,
count(if(length > 60 and length < 120,1,NULL)) as mayor60,
count(if(length >= 120,1,NULL)) as mayor120
from film;

#Cantidad de películas distintas por cada una de las tiendas
select count(distinct film_id), store_id
from inventory
group by store_id;

select distinct film_id from inventory
where store_id = 1;

#Mostrar datos de clientes y encriptar el email de los clientes con una función de encriptación
SELECT MD5(email) from customer;

select aes_decrypt(a.b, 'aeskey')
from (
select AES_ENCRYPT('someemail@example.com', 'aeskey') as b
) as a;

#Media de dinero gastada por los clientes en el mes de junio
select avg(amount)
from payment
where MONTH(payment_date) = 6;

select avg(amount) from
(select customer_id, sum(amount) as amount
from payment
where month(payment_date) = 6
group by customer_id) as A;

#Email de clientes que se han gastado más de 20 euros en películas de acción
select * from payment;
select * from rental;
select * from inventory;
select * from film_category;

#Título de películas que si que tienen inventario y que nunca se han alquilado
#Ciudad con más clientes por cada uno de los países