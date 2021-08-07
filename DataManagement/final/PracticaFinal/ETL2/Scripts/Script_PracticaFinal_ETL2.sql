CREATE TABLE fichero1 AS SELECT email AS Email, create_date AS Create_date 
FROM (
		SELECT c.customer_id, 
        c.first_name, 
        c.last_name, 
        c.email,
        c.create_date,
        sum(p.amount) AS expenses,
        category_id 
        FROM film_category fc 
		INNER JOIN inventory i ON fc.film_id = i.film_id 
		INNER JOIN rental r ON i.inventory_id = r.inventory_id 
		INNER JOIN payment p ON r.rental_id = p.rental_id 
		INNER JOIN customer c ON p.customer_id = c.customer_id 
		GROUP BY customer_id, category_id
		HAVING category_id =2 
		AND expenses > 20)
        a ;


CREATE TABLE fichero2 AS SELECT title AS Title,
 LEFT(description,20) AS Initial_description,
 length AS Duration, 
CASE WHEN length =120 THEN "Igual a 2 hora" 
WHEN length >120 THEN "Mayor a 2 horas" 
END AS Duration_type 
FROM film 
WHERE length >= 60;

CREATE TABLE fichero3 AS
SELECT a.first_name,
 a.last_name
 FROM(SELECT a.actor_id,
 a.first_name,
 a.last_name,
 COUNT(film_id) AS numero_de_pelis
 FROM actor a
 INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
 GROUP BY actor_id 
 HAVING numero_de_pelis > 30) 
 a;
 
 
CREATE TABLE fichero4 AS
SELECT c.customer_id,
 c.first_name,
 c.last_name,
 a.address,
 d.city,
 e.country
 FROM customer c
 INNER JOIN address a ON c.address_id = a.address_id
 INNER JOIN city d ON a.city_id = d.city_id
 INNER JOIN country e ON d.country_id = e.country_id
 ORDER BY first_name ASC;



