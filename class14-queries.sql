create table foo (
bar decimal(6,2) constraint checkprice check (bar >= 19.05));

insert into foo values (20.00);

insert into foo values (19.00);

insert into foo values (19.00);

alter table foo drop constraint checkprice;

insert into foo values (19.00);

delete from foo;

alter table foo add constraint checkprice check (bar >= 19.05);

insert into foo values (19.00);

set check_constraint_checks=0;


select version();

create table bar (fk int unsigned,
constraint bar_foo foreign key (fk) references foo (pk));

create table foo (id int unsigned auto_increment primary key);

create table bar (foo_id int unsigned);

insert into foo values (1);

alter table bar add constraint foreign key (foo_id) references foo (id);

insert into bar values (2);

alter table bar drop constraint bar_ibfk_1;

alter table bar add constraint bar_foo foreign key (foo_id) references foo (id);

set foreign_key_checks=0;

set foreign_key_checks=1;

alter table foo disable keys;


create table foo (bar int,  index myindex (bar));

alter table foo drop index myindex;

alter table foo add index myindex (bar);

create index myindex on foo (bar);

drop table foo;

create table foo (bar int, index (bar));

show index from foo;

drop table foo;

create table foo (c1 int, c2 int);

alter table foo drop column c2;

describe foo;

create table foo (c1 int);

alter table foo add column c2 int;

describe foo;

drop table foo;

create table foo (id int);

rename table foo to bar;

describe bar;

drop table bar

create table foo (id int);

insert into foo values (1), (2), (3);

select count(*) from foo;

truncate foo;

select count(*) from foo;

create table team (id int unsigned primary key, conference_id int, team_name varchar(100));

create table player (player_name varchar(100),
                     team_id int unsigned not null references team(id),
                     salary decimal(13,2));

insert into team values (1, 1, 'Beavers'), (2, 1, 'Ducks'), (3, 2, 'Bears');

insert into player values
('Jim', 1, 300.0),
('Alice', 2, 400.0),
('Bob', 3, 200.0),
('Wanda', 3, 150.0);


select count(*), sum(salary) as s, conference_id
from player
join team on player.team_id = team.id
group by conference_id
having s > 1000.0;

select if (
select count(*), sum(salary) as s, conference_id
from player
join team on player.team_id = team.id
group by conference_id
having s > 1000.0)
then
  signal sqlstate '45001'
      set message_text='error';
end if;


delimiter //
create procedure
check_salary_cap8 ()
begin
  declare s decimal(13,2);
  declare conference_id int;
  declare found int;
  select sum(salary) as s, conference_id
   from player        
   join team on player.team_id = team.id
   group by conference_id
   having s > 1000.0;
  set found = found_rows();
  if found = 1
  then
    signal sqlstate '45001';
  end if;
  select found;
end //
delimiter ;

create trigger salary_cap
after insert on player
for each row
call check_salary_cap();



select count(*) as c from (select sum(salary) as s, conference_id
   from player        
   join team on player.team_id = team.id
   group by conference_id
   having s > 1000.0) as foo;

delimiter //
create procedure
check_salary_cap ()
begin
  declare found int;
  select count(*) from (select sum(salary) as s, conference_id
   from player        
   join team on player.team_id = team.id
   group by conference_id
   having s > 1000.0) as foo into found;
  if found = 1
  then
    signal sqlstate '45001';
  end if;
end //
delimiter ;

create trigger salary_cap
after insert on player
for each row
call check_salary_cap();
