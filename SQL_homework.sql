##1a. Display the first and last names of all actors from the table actor.
SELECT first_name,last_name FROM sakila.actor;

##1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT concat(first_name," ",last_name) as combined from sakila.actor;

##2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
#What is one query would you use to obtain this information?
select actor_id,first_name,last_name from sakila.actor where first_name like 'JOE';

#2b. Find all actors whose last name contain the letters GEN:
select actor_id,first_name,last_name from sakila.actor where first_name like '%GEN%';

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select actor_id,first_name,last_name from sakila.actor where first_name like '%LI%' ORDER BY last_name,first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id,country FROM sakila.country where country in ('Afghanistan','Bangladesh','China');

#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a 
#column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference 
#between it and VARCHAR are significant).
alter table sakila.actor add column description blob;
select * from sakila.actor;

#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table sakila.actor drop column description;
select * from sakila.actor;

#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(*) from sakila.actor group by last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(*) from sakila.actor group by last_name having count(*)>=2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
set sql_safe_updates=0; update sakila.actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
select * from sakila.actor where first_name = 'HARPO';

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a 
#single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
set sql_safe_updates=0; update sakila.actor set first_name = 'GROUCHO' where first_name = 'HARPO' and last_name = 'WILLIAMS';
select * from sakila.actor where first_name = 'GROUCHO';

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
#Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
show create table sakila.address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
#Use the tables staff and address:
select first_name,last_name,address from sakila.staff inner join sakila.address on staff.address_id=address.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select first_name,last_name, sum(amount) from sakila.payment inner join sakila.staff 
on staff.staff_id=payment.staff_id where payment.payment_date like '2005-08%' group by staff.staff_id;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select * from sakila.film inner join sakila.film_actor on film.film_id=film_actor.film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select film.title from sakila.film where title like 'Hunchback Impossible';

#6e. Using the tables payment and customer and the JOIN command, list the total 
#paid by each customer. List the customers alphabetically by last name:
select customer.customer_id,last_name,first_name, sum(amount) from sakila.payment inner join sakila.customer 
on payment.customer_id=customer.customer_id group by customer_id order by last_name;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies 
#starting with the letters K and Q whose language is English.
select * from sakila.film inner join sakila.language on film.language_id=language.language_id
where title like 'K%' or title like 'Q%' having name='English' or 'Spanish';
 
#7b. Use subqueries to display all actors who appear in the film Alone Trip.
select film.film_id,title,actor.actor_id,first_name,last_name from sakila.film inner join sakila.film_actor 
on film.film_id=film_actor.film_id join sakila.actor on film_actor.actor_id=actor.actor_id
where title='Alone Trip';

#7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of 
#all Canadian customers. Use joins to retrieve this information.
select customer.customer_id,city.country_id,country,first_name,last_name,email,city.city_id,city.city from sakila.customer 
inner join sakila.address on customer.customer_id=address.address_id 
join sakila.city on address.address_id=city.city_id 
join sakila.country on city.country_id=country.country_id
where country='Canada';

#7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify 
#all movies categorized as family films.
select film.film_id,title,category.category_id, name from sakila.film 
inner join sakila.film_category on film.film_id=film_category.category_id 
join sakila.category on film_category.category_id=category.category_id
where name='Family' group by category_id; 

#7e. Display the most frequently rented movies in descending order.
select title,rental_duration from sakila.film order by rental_duration desc;

#7f. Write a query to display how much business, in dollars, each store brought in.
select inventory.store_id,sum(rental_duration*rental_rate) from sakila.film
inner join sakila.inventory on film.film_id=inventory.film_id group by inventory.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
select store.store_id,address,city,country from sakila.store
inner join sakila.address on store.address_id=address.address_id
join sakila.city on address.address_id=city.city_id 
join sakila.country on city.country_id=country.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following 
#tables: category, film_category, inventory, payment, and rental.)
select category.name, sum(rental_duration*rental_rate) as revenue from sakila.film
inner join sakila.film_category on film.film_id=film_category.film_id
inner join sakila.category on film_category.category_id=category.category_id
group by category.name order by revenue desc limit 5;

#8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross 
#revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view top_revenue
as select category.name, sum(rental_duration*rental_rate) as revenue from sakila.film
inner join sakila.film_category on film.film_id=film_category.film_id
inner join sakila.category on film_category.category_id=category.category_id
group by category.name order by revenue desc limit 5;

#8b. How would you display the view that you created in 8a?
select * from top_revenue;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view top_revenue;