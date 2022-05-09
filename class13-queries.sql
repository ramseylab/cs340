-- This is a tutorial to help you with the CS340 assignment "Advanced SQL Assignment Part A"
-- The tables and queries will bear a striking resemblance to the ones needed to complete
-- the assignment, with (of course) some slight differences introduced in order to avoid
-- rendering the assignment entirely trivial.

-- Create a table called `patient` with the following columns:
--  `id`: auto-incrementing integer (11 digits), primary key
--  `name_first`: varchar, max length 200 characters, cannot be null
--  `name_last`: varchar, max length 200 characters, cannot be null
--  `email`: varchar, max length 255 characters, cannot be null
-- The combination of `name_first` and `name_last` cannot be unique
-- in this table; name the constraint as `name_full`.

create table patient (
id int(11) auto_increment,
name_first varchar(200) not null,
name_last varchar(200) not null,
email varchar(255) not null,
primary key (id),
unique key name_full (name_first, name_last));

-- Note that we didn't explicitly specify "not null" on the `id` column;
-- why was it not necessary to declare that column `not null` explicitly?

-- OK, let's run the `create table` DDL for the `patient` table...

-- Hmm, we see a warning flag:

/*
Query OK, 0 rows affected, 1 warning (0.00 sec)
*/

-- Let's look at the warning message in detail

show warnings;

-- OK, so MariaDB is warning us about this:

/*
+---------+------+------------------------------------------------------------------------------+
| Level   | Code | Message                                                                      |
+---------+------+------------------------------------------------------------------------------+
| Warning | 1681 | Integer display width is deprecated and will be removed in a future release. |
+---------+------+------------------------------------------------------------------------------+
1 row in set (0.00 sec)
*/

-- Let's look at the description for the table `patient` in the database catalog:

describe patient;

-- Here is how MariaDB responds:
/*
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | int          | NO   | PRI | NULL    | auto_increment |
| name_first | varchar(200) | NO   | MUL | NULL    |                |
| name_last  | varchar(200) | NO   |     | NULL    |                |
| email      | varchar(255) | NO   |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
*/

-- so indeed, we did not need to explicitly specify "not null" for the primary key column.


-- Now suppose we need to create a table `provider`
-- for healthcare providers in our database, with
-- the following columns:
--  id: integer, auto_increment, not null, primary key
--  name_first, varchar, length 200, not null
--  name_last, varchar, length 200, not null
--  date_started, date, not null
--  email, varchar, length 255, not null
-- and with a unique key constraint called "name_full" based on the two columns name_first
-- and name_last

create table provider (
id int(11) auto_increment,
name_first varchar(200) not null,
name_last varchar(200) not null,
date_started date not null,
email varchar(255) not null,
primary key (id),
unique key name_full (name_first, name_last));

-- Note, the above DDL gives the same warning (1681) as we received when we
-- created the `patient` table; we don't need to worry about it at this time.

-- Now let's look at the description for the table `provider` in the
-- database catalog:

describe provider;

/*
+--------------+--------------+------+-----+---------+----------------+
| Field        | Type         | Null | Key | Default | Extra          |
+--------------+--------------+------+-----+---------+----------------+
| id           | int          | NO   | PRI | NULL    | auto_increment |
| name_first   | varchar(200) | NO   | MUL | NULL    |                |
| name_last    | varchar(200) | NO   |     | NULL    |                |
| date_started | date         | NO   |     | NULL    |                |
| email        | varchar(255) | NO   |     | NULL    |                |
+--------------+--------------+------+-----+---------+----------------+
*/

-- Once again, the primary key column `id` is automatically set to "not null".

-- Now suppose we need to create a table `injury`
-- documenting a specific injury that a `patient` has;
-- The table `injury` should have the following columns:
--   id: int, length 11, auto-incrementing, not null
--   ehr_uuid: varchar, length 36, not null (assume this is a UUID from some other software program)
--   notes: text
--   pid: int, length 11, references patient
-- Further, the column `ehr_uuid` must be unique.

create table injury (
id int(11) auto_increment,
ehr_uuid varchar(36) not null,
notes text,
pid int(11),
primary key (id), 
foreign key (pid) references patient (id),
unique key (ehr_uuid));

-- We get two more of the MariaDB warning code 1681, due to the two `int(11)`
-- columns.

-- Now, let's look at the entry for `injury` in the database catalog:

/*
+----------+-------------+------+-----+---------+----------------+
| Field    | Type        | Null | Key | Default | Extra          |
+----------+-------------+------+-----+---------+----------------+
| id       | int         | NO   | PRI | NULL    | auto_increment |
| ehr_uuid | varchar(36) | NO   | UNI | NULL    |                |
| notes    | text        | YES  |     | NULL    |                |
| pid      | int         | YES  | MUL | NULL    |                |
+----------+-------------+------+-----+---------+----------------+
*/

-- Now let's create a table `treating` with columns referenging
-- the patient and the provider:
--  provider_id int(11), foreign key to provider.id,
--  patient_id int(11), foreign key to patient.id,
--  next_appt_date: date, not null,
-- with the primary key being the combination of columns (provider_id, patient_id)

create table treats (
injury_id int(11),
provider_id int(11),
next_appt_date date not null,
primary key (injury_id, provider_id),
foreign key (injury_id) references injury (id),
foreign key (provider_id) references provider (id));

-- When we run the above DDL, we get the usual complaint about `int(11)`:

/*
Query OK, 0 rows affected, 2 warnings (0.01 sec)

show warnings;
4 rows in set (0.00 sec)


mysql> show warnings;
4 rows in set (0.00 sec)


+---------+------+------------------------------------------------------------------------------+
| Level   | Code | Message                                                                      |
+---------+------+------------------------------------------------------------------------------+
| Warning | 1681 | Integer display width is deprecated and will be removed in a future release. |
| Warning | 1681 | Integer display width is deprecated and will be removed in a future release. |
+---------+------+------------------------------------------------------------------------------+
2 rows in set (0.00 sec)
*/

-- Now let's look at the entry for the `treats` table in the database catalog:

describe treats;

/*
+----------------+------+------+-----+---------+-------+
| Field          | Type | Null | Key | Default | Extra |
+----------------+------+------+-----+---------+-------+
| injury_id      | int  | NO   | PRI | NULL    |       |
| provider_id    | int  | NO   | PRI | NULL    |       |
| next_appt_date | date | NO   |     | NULL    |       |
+----------------+------+------+-----+---------+-------+
*/

-- note that both `provider_id` and `injury_id` have been set to "not null"
-- because they are part of the composite primary key


-- Now let's suppose we need to insert some data into our tables:

-- Into the `patient` table:

/*
First Name
	

Last Name
	

Email

Sara
	

Smith
	

smiths@hello.com



*/

insert into patient (name_first, name_last, email) values ('Sara', 'Smith', 'smiths@hello.com');

-- Let's look at the table we just created:

select * from patient;

/*
+----+------------+-----------+------------------+
| id | name_first | name_last | email            |
+----+------------+-----------+------------------+
|  1 | Sara       | Smith     | smiths@hello.com |
+----+------------+-----------+------------------+
*/

-- Now, suppose that we need to add a healthcare provider to the database:
-- name_first:  Abdul
-- name_last: Rehman
-- date_started: Feb. 27, 2018
-- email: rehman@hello.com

insert into provider (name_first, name_last, date_started, email) values ('Abdul', 'Rehman', '2018-02-27', 'rehman@hello.com');

-- Let's look at the content of the provider table after the insert:

select * from provider;

/*
+----+------------+-----------+--------------+------------------+
| id | name_first | name_last | date_started | email            |
+----+------------+-----------+--------------+------------------+
|  1 | Abdul      | Rehman    | 2018-02-27   | rehman@hello.com |
+----+------------+-----------+--------------+------------------+
*/

-- Now, suppose that we need to add a row to the `injury` table with these attributes:
-- ehr_uuid: 785d9120-cfd3-11ec-8919-2576e20d97d0
-- notes: comminuted fracture
-- pid:  patient_id corresponding to 'Sara Smith'

-- To do this, we will use a *subquery* inside the values part of the `insert` statement:

insert into injury (ehr_uuid, notes, pid) values ('785d9120-cfd3-11ec-8919-2576e20d97d0',
'comminuted fracture',
(select id from patient where name_first = 'Sara' and name_last = 'Smith'));

-- Let's look at the content of the `injury` table after the insert:

select * from injury;

/*
+----+--------------------------------------+---------------------+------+
| id | ehr_uuid                             | notes               | pid  |
+----+--------------------------------------+---------------------+------+
|  1 | 785d9120-cfd3-11ec-8919-2576e20d97d0 | comminuted fracture |    1 |
+----+--------------------------------------+---------------------+------+
*/

-- Now, let's suppose that we need to add a row to the `treats`
-- table with the following attributes:
-- injury_id: the id for the row in the injury table corresponding to UUID '785d9120-cfd3-11ec-8919-2576e20d97d0'
-- provider_id: the id for the row in the provider table corresponding to Abdul Rehman
-- next_appt_date: Jan. 1, 2021

-- We'll do this using *two* subqueries, one for the `injury_id` and one for the `provider_id`:

insert into treats (injury_id, provider_id, next_appt_date) values (
(select id from injury where ehr_uuid = '785d9120-cfd3-11ec-8919-2576e20d97d0'),
(select id from provider where name_first = 'Abdul' and name_last = 'Rehman'),
'2021-01-01');

-- Let's look at the content of the `treats` table after that last insert:

 select * from treats;

/*
+-----------+-------------+----------------+
| injury_id | provider_id | next_appt_date |
+-----------+-------------+----------------+
|         1 |           1 | 2021-01-01     |
+-----------+-------------+----------------+
*/


