use sakila;
-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.

select  r.customer_id, c.first_name, c.last_name, c.email
from sakila.customer c join sakila.rental r
on r.customer_id = c.customer_id
where r.rental_id is not null 
group by r.customer_id, c.first_name, c.last_name, c.email
order by r.customer_id asc; 

-- 2. What is the average payment made by each customer
--    (display the customer id, customer name (concatenated), and the average payment made).

select p.customer_id, concat(c.first_name, ' ', c.last_name) as customer_name, round(avg(p.amount),2) as avg_payment
from sakila.customer c join sakila.payment p
on c.customer_id = p.customer_id
group by p.customer_id, c.first_name, c.last_name;



-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements
select  c.first_name, c.last_name, c.email
from sakila.customer c join sakila.rental r
on r.customer_id = c.customer_id
join sakila.inventory i
on r.inventory_id = i.inventory_id
join sakila.film f
on f.film_id = i.film_id
join sakila.film_category fc
on fc.film_id = f.film_id
join sakila.category ca
on ca.category_id = fc.category_id
where ca.name = 'Action'
group by c.customer_id;


-- Write the query using sub queries with multiple WHERE clause and IN condition
select first_name, last_name, email from (
select customer.first_name, customer.last_name, customer.email, customer.customer_id
from sakila.customer) 
sub4 
where sub4.customer_id in (
select customer_id from (
select rental.rental_id, rental.inventory_id, rental.customer_id
from sakila.rental) 
sub3 
where sub3.inventory_id in (
select inventory_id from (
select inventory.film_id, inventory.inventory_id
from sakila.inventory) 
sub2 
where sub2.film_id in (select film_id from (
select film_category.film_id, film_category.category_id
from sakila.film_category)
sub1
where sub1.category_id = (
select category.category_id
from sakila.category
where category.name IN ('Action')
))));


 
select customer_id, rental_id, inventory_id from (
select rental.rental_id, rental.inventory_id, rental.customer_id
from sakila.rental) 
sub3 
where sub3.inventory_id in (
select inventory_id from (
select inventory.film_id, inventory.inventory_id
from sakila.inventory) 
sub2 
where sub2.film_id in (select film_id from (
select film_category.film_id, film_category.category_id
from sakila.film_category)
sub1
where sub1.category_id = (
select category.category_id
from sakila.category
where category.name IN ('Action')
)))
group by customer_id
order by customer_id asc;


select inventory_id, film_id from (
select inventory.film_id, inventory.inventory_id
from sakila.inventory)
sub2 
where sub2.film_id in (select film_id from (
select film_category.film_id, film_category.category_id
from sakila.film_category)
sub1
where sub1.category_id = (
select category.category_id
from sakila.category
where category.name IN ('Action')
));





select film_id, category_id from (
select film_category.film_id, film_category.category_id
from sakila.film_category)
sub1 
where sub1.category_id = (
select category.category_id
from sakila.category
where category.name IN ('Action')
);

-- Verify if the above two queries produce the same results or not


-- 4. Use the case statement to create a new column classifying existing 
--    columns as either or high value transactions based on the amount of payment.
--    If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4,
--    the label should be medium, and if it is more than 4, then it should be high.


select customer_id,
	   case when amount >= 0 and amount < 2   Then Amount end as low,
	   case when amount >= 2 and amount <= 4   Then Amount end  as medium,
	   case when amount > 4  Then Amount end  as high
from sakila.payment;
 
 
 select customer_id, 
 case 
       when amount >= 0 and amount < 2   Then 'low'
       when amount >= 2 and amount <= 4  Then 'medium'
	   when amount > 4  Then 'high'
end as amount_classifier,
amount
from sakila.payment;