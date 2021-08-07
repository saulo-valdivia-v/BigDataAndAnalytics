select * from film
where length > 50 and rental_rate > 1.5;

select * from actor
where first_name = 'penelope' and last_name = 'guiness'
union
select * from actor
where first_name = 'ed' and last_name = 'chase';

select * from address
where address = '1411 Lillydale Drive'
union
select * from address
where address = '1913 Hanoi Way'
union
select * from address
where address = '1121 Loja Avenue';