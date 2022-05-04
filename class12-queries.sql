-- This is a single-line comment
  -- The comment symbol doesn't have to come at the start of a line like in some config files
  -- like httpd htaccess files, samba config, ssh config, etc.
  
/* this is a potentially
   multi-line comment */

/* The MariaDB parser allows for a "comment" that is *only* parsed as SQL in MariaDB, like this: */

/* You can have a comment in the middle of a SQL statement, like this: */
select foo /* , bar */ * from baz;  -- do

/* How can you find the maximum length of a film? */
select max(length) from film;

/* How can you find the maximum length of a film, and name the result "l"? */
select max(length) as l from film;

/* How can you find the minimum rental_duration of a film? */
select min(rental_duration) from film;

/* And name the result as r? */
select min(rental_duration) as r from film;

/* How would you find the film_id of the films that are of "minimum length"? */
/* You could use a nested subquery, like this: */
select film_id from film where length = (select min(length) from film);

/* Alternatively, you could use a CTE, i.e., a WITH statement, which is a bit
more in keeping with the phrasing of the assignment */
with minlen as (select min(length) as l from film)
select film_id from film, minlen where film.length = minlen.l;

/* Do these two queries have the same query plan? Let's check them out using "explain" */
-- first, let's do the subquery method:
explain select film_id from film where length = (select min(length) from film);

-- now, let's do the CTE method:
explain with minlen as (select min(length) as l from film)
select film_id from film, minlen where film.length = minlen.l;

-- are they the same?
-- is the distinction meaningful in terms of performance?

-- advantages of a CTE:
--   1. readability
--   2. can refer to the CTE more than once in the query

-- What if you needed the film_id values of the shortest films, in descending order?
with minlen as (select min(length) as l from film)
select film_id from film, minlen where film.length = minlen.l
order by film_id desc;

-- How would you find the film_id of the films that have maximum rental
-- duration, using a nested subquery? 
select film_id from film where rental_duration = (select max(rental_duration) from film);

-- How would you find the film_id of the films that have maximum rental
-- duration, using a CTE?
with maxdur as (select max(rental_duration) as r from film)
select film_id from film, maxdur where film.rental_duration = maxdur.r;

-- What if we wanted all films that have minimum length or maximum rental duration?
-- Well, we could certainly do a union, which by default will return distinct
-- film IDs, right?
select film_id from film where length = (select min(length) from film)
union
select film_id from film where rental_duration = (select max(rental_duration) from film);

-- What if we didn't want to use a union?  We can use an "OR" in the with clause, of course:
select film_id from film
where length = (select min(length) from film)
or rental_duration = (select max(rental_duration) from film);

-- Can we do it with a union of two CTEs?  Certainly
(with minlen as (select min(length) as l from film) select film_id from film, minlen where film.length = minlen.l)
union
(with maxdur as (select max(rental_duration) as r from film) select film_id from film, maxdur where film.rental_duration = maxdur.r);

-- Can we do it with a single CTE?  Yes, absolutely:
with minlen as (select min(length) as l from film),
     maxdur as (select max(rental_duration) as r from film)
     select film_id from film, minlen, maxdur
     where film.length = minlen.l or film.rental_duration = maxdur.r

-- the single-CTE approach seems to be pretty easy to read and is more in line with how
-- we might envision the worfkow being done (though again, SQL DQL is a declarative language)

-- I'll leave it to you to order the resulting film IDs in descending order as requested

-- What if we needed a list of pairs of actors and films?  We'd have to join the film, actor, and film_actor tables, right?
-- Can we join film and flim_actor using a natural join?  Let's check using describe:

describe film;

describe film_actor;

-- Hmm, they both have a column "last_update" as well as "film_id", and natural join will by default
-- use *both* columns for the implied inner equijoin, so that won't work.  We can use "using";
-- this is going to be a big table, so let's put a limit clause on it so we can peek at the results:

select title, first_name, last_name
from film
join film_actor using (film_id)
join actor using (actor_id)
limit 20;

-- OK so what if we want to also include the category name of the film as a third column in the results?
-- we have to also join to "category" and "film_category", right?

select title, category.name, first_name, last_name
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id) limit 20;

-- OK, this is looking good. But what if we want to restrict to just movies in which UMA WOOD starred?
select title, category.name, first_name, last_name
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id) where first_name = 'UMA' and last_name = 'WOOD';

-- Now what if we want to order by category and then by title:
select title, category.name, first_name, last_name
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id) where first_name = 'UMA' and last_name = 'WOOD'
order by category.name, title;

-- What if we need to count up the number of distinct titles by category?
select category.name, count(title)
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id) where first_name = 'UMA' and last_name = 'WOOD'
group by category.name
order by category.name;

-- can we order by category.name descending?
select category.name, count(title)
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id) where first_name = 'UMA' and last_name = 'WOOD'
group by category.name
order by category.name desc;

-- what if we wanted a table of last name, first name, and category name
-- for categories of movies that each actor has acted in at least once?
select distinct last_name, first_name, category.name
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id)
order by last_name, first_name, category.name
limit 30;

-- what if we wanted the count of distinct categories each actor has acted in,
-- ordered by increasing count?
select last_name, first_name, count(*) as c from
(select distinct last_name, first_name, category.name
from film
join film_actor using (film_id)
join actor using (actor_id)
join film_category using (film_id)
join category using (category_id)) as foo
group by last_name, first_name
order by c
limit 30;

-- so, Julia Fawcett has only acted in eight categories

-- What if we needed to know the count of times Julia Fawcett
-- has acted in each category of movie, with zero times shown
-- for any film category in which Fawcett has not acted, ordered by the count in
-- descending order?

-- First, we need a query showing the category_ids for all titles
-- that Julia Fawcett has acted in
select last_name, first_name, title, category_id
from film_category 
join film using (film_id)
join film_actor using (film_id)
join actor using (actor_id) where last_name = 'FAWCETT' and first_name = 'JULIA'

-- Now we want a count for each category ID
select category_id, count(*) as c
from film_category 
join film using (film_id)
join film_actor using (film_id)
join actor using (actor_id) where last_name = 'FAWCETT' and first_name = 'JULIA'
group by category_id;

-- Next, we want to join that table with the "category" table
-- to get category names, but we want *all* category names shown
-- even if there are no acting credits for Julia Fawcett for that
-- film category; for that purpose, we use an outer join:
select name, ifnull(c, 0) as count
from category
left join
(select category_id, count(*) as c
from film_category 
join film using (film_id)
join film_actor using (film_id)
join actor using (actor_id) where last_name = 'FAWCETT' and first_name = 'JULIA'
group by category_id) as foo using (category_id);

-- now order by category name in descending order
select name, ifnull(c, 0) as count
from category
left join
(select category_id, count(*) as c
from film_category 
join film using (film_id)
join film_actor using (film_id)
join actor using (actor_id) where last_name = 'FAWCETT' and first_name = 'JULIA'
group by category_id) as foo using (category_id)
order by count desc;

-- what if we need to show only the categories for which the count is less than 3?
-- we can post-filter using "having"

select name, ifnull(c, 0) as count
from category
left join
(select category_id, count(*) as c
from film_category 
join film using (film_id)
join film_actor using (film_id)
join actor using (actor_id) where last_name = 'FAWCETT' and first_name = 'JULIA'
group by category_id) as foo using (category_id)
having count < 3 
order by count desc;


-- What if we needed to know the actor_id, first_name, and last_name for all
-- actors who have *never* acted in a Children's film?

-- We'll start by getting a table of film_ids for children's films
select film_id
from  film_category
join category using (category_id)
where category.name = 'Children'
limit 30;

-- we have to join this to actor to get the actor_ids for any actors
-- who have acted in a children's film
select distinct actor_id from
film_actor join film_category using (film_id)
join category using (category_id)
where category.name = 'Children'
order by actor_id
limit 30;

-- Let's join actor to film_actor and restrict to actor_ids not in the
-- list of actor IDs that we just got from the previous query:
select actor_id, first_name, last_name
from actor
join film_actor using (actor_id)
where actor_id not in (-- who have acted in a children's film
select distinct actor_id from
film_actor join film_category using (film_id)
join category using (category_id)
where category.name = 'Children')
limit 30;

-- Need to get rid of the redundancy, using distinct
-- and order by actor_id:
select distinct actor_id, first_name, last_name
from actor
join film_actor using (actor_id)
where actor_id not in (-- who have acted in a children's film
select distinct actor_id from
film_actor join film_category using (film_id)
join category using (category_id)
where category.name = 'Children')
order by actor_id
limit 30;


-- Can we do it with a CTE?  Sure
with
aids as (select distinct actor_id
         from film_actor
         join film_category using (film_id)
         join category using (category_id)
         where category.name = 'Children')
         select distinct actor_id, first_name, last_name
         from actor
         join film_actor using (actor_id)
         where actor_id not in (select actor_id from aids)
         order by actor_id
         limit 30;


-- What if we need the actor_id, first_name, last_name, and maximum film
-- length of Childrens films for every actor?

-- Start by getting a table of Children's films
select film_id
from film
join film_category using (film_id)
join category using (category_id)
where category.name = 'Children' limit 30;

-- Join to film_actor and actor and include actor name, actor ID, and film length
-- drop the film_id since we won't need it
select actor_id, last_name, first_name, film.length
from film
join film_category using (film_id)
join category using (category_id)
join film_actor using (film_id)
join actor using (actor_id)
where category.name = 'Children' order by actor_id limit 30;

-- Now group by last_name, first_name and aggregate using max:
select last_name, first_name, max(film.length) as maxlen
from film
join film_category using (film_id)
join category using (category_id)
join film_actor using (film_id)
join actor using (actor_id)
where category.name = 'Children'
group by last_name, first_name;

-- Now let's order by actor_id in ascending order:
select actor_id, last_name, first_name, max(film.length) as maxlen
from film
join film_category using (film_id)
join category using (category_id)
join film_actor using (film_id)
join actor using (actor_id)
where category.name = 'Children'
group by actor_id
order by actor_id limit 30;

-- Find movies that have both Penelope Guiness and Jennifer Davis

select actor_id from actor where first_name = 'PENELOPE' and last_name = 'GUINESS';  -- returns 1

select actor_id from actor where first_name = 'JENNIFER' and last_name = 'DAVIS'; -- returns 4

-- get film IDs for flims that have both actor_id 1 and actor_id 4
select title 
from film
join film_actor as fa1 using (film_id)
join film_actor as fa2 using (film_id)
where fa1.actor_id = 1 and fa2.actor_id = 4;

-- express 80 and 168 as subqueries
select title 
from film
join film_actor as fa1 using (film_id)
join film_actor as fa2 using (film_id)
where fa1.actor_id = (select actor_id from actor where first_name = 'PENELOPE' and last_name = 'GUINESS')
and fa2.actor_id = (select actor_id from actor where first_name = 'JENNIFER' and last_name = 'DAVIS');

-- using CTE
with
pgtable as (select actor_id from actor where first_name = 'PENELOPE' and last_name = 'GUINESS'),
jdtable as (select actor_id from actor where first_name = 'JENNIFER' and last_name = 'DAVIS')
    select title 
    from film
    join film_actor as fa1 using (film_id)
    join film_actor as fa2 using (film_id)
    join pgtable
    join jdtable
    where fa1.actor_id = pgtable.actor_id
          and fa2.actor_id = jdtable.actor_id;


select film_id, name
from film_actor
/* join film using (film_id) */
join film_category using (film_id)
join category using (category_id)
where actor_id=1;

