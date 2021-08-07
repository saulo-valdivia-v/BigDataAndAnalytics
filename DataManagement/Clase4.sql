select * from film2;

ALTER TABLE film2
ADD COLUMN ListaDePrecios VARCHAR(100) AFTER last_update;

#insert into film2 (ListaDePrecios) values (CASE
#    WHEN replacement_cost > 10 THEN 'Caro'
#    WHEN replacement_cost < 20 THEN 'Barato'
#    WHEN replacement_cost = 10 THEN 'Estandar'
#    ELSE 'Comprobar lista de precios'
#END)

select title, 
CASE
    WHEN rating = 'G' THEN 'Para todos los publicos'    
    WHEN rating = 'PG' THEN 'Menores acompañados'    
    WHEN rating = 'R' THEN 'Para Adultos'    
    ELSE 'Otros'
END as rating
from film;

select title, length,
CASE
    WHEN length < 70 THEN 'Cortita'    
    WHEN length > 70 and length < 130 THEN 'Normal'    
    ELSE 'Toston'
END as duration
from film;

