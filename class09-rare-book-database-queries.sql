# Let's list the tables in Harrington's rare book store databse:

show tables;

# Note that the tables are named in singular rather than plural. This is pretty
# common in RDBMS, showing the influence of Edgar Codd's relation model where
# a SQL table is just a realization of an abstract relation whose name represents
# an entity type. But, plural table names are also pretty commonplace, just be
# consistent within your schema.

# Note that keywords in SQL are often shown in allcaps, for historical reasons, so this
# is commonplace:

SELECT * FROM condition_code;

# But it is the same as doing this:

select * from condition_code;

# Note that with modern editors, SQL code is syntax-highlighted using color,
# so there is less reason to allcaps the SQL keywords so that they "stand out" from
# other string literals, table/view names, or column names.

# Let's retrieve all columns from a single table, "work", in their original "order":

select * from work;

# the "work" table is big enough that it scrolls across the screen; we can just peek
# at the first few rows using the "limit" keyword:

select * from work limit 3;

# what if we forget the schema for the work table?  use "describe":

describe work;

# to retrieve specific columns in a specific 

select first_name, last_name, contact_phone from customer;

# this query returns some duplicate rows (do you see why?):

select customer_numb, credit_card_numb from sale;

# to return just the unique rows (i.e., eliminating duplicates),
# you would include the `distinct` keyword, like this:

select distinct customer_numb, credit_card_numb from sale;

# Note that the row order has changed as a consequence of
# applying the `distinct` keyword

# discuss why the DBMS doesn't automatically apply `distinct`
# to every query result?
# - performance
# - sometimes we want to aggregate or do other things

# Now let's take a look at authors

select * from author;

# What order are they in?

# What if we want to get the rows ordered by author last name?

select * from author order by author_last_first;

# Let's try it with a view of the `sale` table:

select sale_id, customer_numb, sale_total_amt from sale;

# Suppose we want to order the results by `sale_total_amt`:

select sale_id, customer_numb, sale_total_amt from sale order by sale_total_amt;

# Can we do descending order? Yes, use the `desc` keyword:

select sale_id, customer_numb, sale_total_amt from sale order by sale_total_amt desc;

# What if we just want the top five most expensive sales?

select sale_id, customer_numb, sale_total_amt from sale order by sale_total_amt desc limit 5;

# Can we order by two columns, like in Excel?  Yes!

select zip_postcode, last_name, first_name from customer order by zip_postcode, last_name;

# Does the order of the columns after `order by` matter?  Yes. To see this, swap them:

select zip_postcode, last_name, first_name from customer order by last_name, zip_postcode;

# What if we only want to pull out a subset of rows satisfying some condition?
# We use the `where` keyword, followed by a boolean expression that is evaluated
# for each row, to determine whether or not the row is included in the result;
# that expression is called the "predicate".

# For example, what if you uwant to find all books ordered on sale number 6?

select isbn, sale_id from volume where sale_id = 6;

# Find sales for which sale_total_amt was greater than 100.00

select sale_id, sale_date, sale_total_amt from sale where sale_total_amt > 100.00;

# Greater than or equal to 100.00

select sale_id, sale_date, sale_total_amt from sale where sale_total_amt >= 100.00;

# Now let's try "<>". Find customers where the `zip_postcode` is not equal to 11111

select customer_numb, last_name, first_name, zip_postcode from customer where zip_postcode <> '11111';

# Note, this is the same as "!=", which MariaDB also supports (but which is not ISO standard SQL):

select customer_numb, last_name, first_name, zip_postcode from customer where zip_postcode != '11111';

# What about finding sales above $100.00 that occurred before July 1, 2021?  Use the `and` operator:

select * from sale where sale_total_amt > 100.00 and sale_date < '2021-07-01';

# What if you want only seles that occurred only in July 2021?  Use the `between` operator:

select count(*) from sale where sale_date between '2021-07-01' and '2021-07-31';

# Or equivalently using an explicit conjunction:

select count(*) from sale where sale_date >= '2021-07-01' and sale_date <= '2021-07-31';

# If you want sales within the last nine months, use the `curdate` function
# and the `interval` keyword, like this:

select * from sale where sale_date >= curdate() - interval 9 month;

# What if we wanted a list of sales that were either high-dollar-value (over 500.00) or with
# exp_year 15, perhaps for a fraud alert type of filter?  Use the `or` operator:

select * from sale where sale_total_amt >= 500.00 or exp_year = 15;

# Note this SQL example given in the text doesn't work:

select * from sale where sale_date >= '07-10-2021';

# because the date isn't specified in ISO 8601 format. You have to use str_to_date, like this:

select * from sale where sale_date >= str_to_date('07-10-2021', '%m-%d-%Y');

# note the uppercase Y, that is important or the query won't work properly but won't give you an error either!

# To have a full Boolean algebra for predicates, we of course need a NOT operator. In SQL, it is the
# keyword `not`. Let us find rows of `volume` where the asking price is greater than 50 or the selling
# price is greater than or equal to the asking price:

select * from volume where asking_price > 50.00 or selling_price >= asking_price;

# We could similarly express this query as:

select * from volume where not ( asking_price <= 50.00 and selling_price < asking_price);

# Note that if you just want to evaluate some expression in MariaDB, just put it after a select:

select not(1=1);

select 1=1;

# Note, in the result 1 = TRUE and 0 = FALSE.
# In MariaDB, the data type BOOLEAN is a synonym for TINYINT(1).

# There are literals defined for TRUE and FALSE,

select 1 = TRUE;

select 1 = FALSE;

select 0 = FALSE;

select 0 = TRUE;

# What does this do?

select 'one'=0;

# ???
# But wait, there was a warning:

show warnings;

# What will this returN:

select not ( 0=1 ) and 0=1;

# how about this?

select not ( ( 0=1 ) and 0=1 );

# What if we want all customers whose first names start with J?
# Use a string wildcard `%`, using the `like` keyword

select * from customer where first_name like 'J%';

# What if we just want to match John and Jane?
# Use the single-character wildcard, `_`

select * from customer where first_name like 'J_ne';

# What if we instead want to _exclude_ John and Jane?

select * from customer where first_name not like 'J_ne';

# What if we want to match Jane and Janice?
# You can do this using `regexp`, and using the `+` operator:

select * from customer where first_name regexp 'Jan+e';

# Can you find all customers whose last name contains the substring "ns"?

select * from customer where last_name like '%ns%';

# Or using a regexp:

select * from customer where last_name regexp 'ns';

# What if you want to find all volumes that came through the business in condition New, Fine, or Poor?
# You could use the `in` keyword:

select * from volume where condition_code in (1, 3, 5);

# What if we only wanted the above query, but for which the item is sold?  Use "is not null":

select * from volume where condition_code in (1, 3, 5) and sale_id is not null;

# Why do we use "is" instead of "="?  Try it with "!=":

select * from volume where condition_code in (1, 3, 5) and sale_id != NULL;

# Do you get any results?  No!  Why is that?
# To see why this is so, try comparing the value 1 to NULL, using a `select` statement:

select 1 != NULL;

# Now do it with 1 is not NULL:

select 1 is not NULL;

# This is the same as:

select 1 is not UNKNOWN;

# To see that it is a synonym:

select NULL is UNKNOWN;

# Try it again with equals:

select NULL = NULL;


