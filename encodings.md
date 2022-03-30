# About character encodings

Before using MariaDB in CS340, we should probably check which character encoding
our database server is configured to use, so that we can specify the correct
encoding when we connect to the database server programmatically.

There are two ways to do this. To do this using the `mysql` command-line
tool (which is convenient if you are outside of OSU since you don't have
to use a VPN), you would ssh into `acess.engr.oregonstate.edu`
```
ssh ramseyset@access.engr.oregonstate.edu
```
and then (assuming your `.my.cnf` file is already set up as in Assignment&nbsp;1) 
you would run this command:
```
mysql -e "SHOW VARIABLES LIKE 'character_set%'; SHOW VARIABLES LIKE 'collation%'"
```
which produces:
```
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8mb3                    |
| character_set_connection | utf8mb3                    |
| character_set_database   | utf8mb3                    |
| character_set_filesystem | binary                     |
| character_set_results    | utf8mb3                    |
| character_set_server     | utf8mb3                    |
| character_set_system     | utf8mb3                    |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
+----------------------+--------------------+
| Variable_name        | Value              |
+----------------------+--------------------+
| collation_connection | utf8mb3_general_ci |
| collation_database   | utf8mb3_general_ci |
| collation_server     | utf8mb3_general_ci |
+----------------------+--------------------+
```
so we are using `utf8mb3` for connectiong; however, MySQL (including the `mysql`
command-line client tool) uses `utf8` as an alias for this character encoding;
see
[Section 10.9.2 of the MySQL 8.0 Reference Manual](https://dev.mysql.com/doc/refman/8.0/en/charset-unicode-utf8mb3.html),
so we should refer to this character encoding as `utf8` when we connect to the
database.  We could also have checked this using phpMyAdmin, by navigating your
web browser to
[classmysql.engr.oregonstate.edu](https://classmysql.engr.oregonstate.edu),
authenticating, then clicking on the "Variables" tab, and then entering
`character_set` in the text box next to the prompt "Containing the word: ".  You
can see that we are connecting using `utfmb4_unicode_ci`. You can change it by
clicking on the link "Server: classmysql.engr.oregonstate.edu" at the top of the
screen, and changing "Server connection collation".  You'll need to log out and
back in. Click the right arrow in the upper-left corner to display the
left-hand-side tabbed pane, and then click the little icon of the exit door with
the tiny left-facing green arrow. Then log back in.

Now, `utf8mb3` is not ideal because it only supports the Unicode Basic Multilingual
Plane (BMP); it cannot encode the full set of Chinese characters or emojis.

Let's fix that for our existing database. First, add this line to your `~/.my.cnf`:
```
default-character-set=utf8mb4
```
Next, you'll need to modify the `mysql` client to always specify 
`utf8mb4` as the `character-set-server` variable; normally this would
be done in the global MariaDB config file or in SQL by setting
```
set global character-set-server='utf8mb4';
```
but you don't have permission to do that. So, as a workaround, you can set 
a shell alias to do it each time you connect, by adding these two lines
to your `~/.cshrc` file:
```
set backslash_quote
alias mysql mysql "--init-command=\"set character_set_server='utf8mb4';\""
```
and then logging out and then back in. Next, be sure to do this exactly as shown:
```
mysql
```
Then within `mysql`, do this:
```
drop database cs340_ramseyst;
create database cs340_ramseyst;
source ./bsg_db.sql
```
Now, let's look at the encoding again:
```
show variables like 'character_set%';
+--------------------------+----------------------------+
| Variable_name            | Value                      |
+--------------------------+----------------------------+
| character_set_client     | utf8mb4                    |
| character_set_connection | utf8mb4                    |
| character_set_database   | utf8mb4                    |
| character_set_filesystem | binary                     |
| character_set_results    | utf8mb4                    |
| character_set_server     | utf8mb4                    |
| character_set_system     | utf8mb3                    |
| character_sets_dir       | /usr/share/mysql/charsets/ |
+--------------------------+----------------------------+
```
Note that `character_set_system` is a read-only variable, so there is 
nothing that can be done about that; I think that just means that
you can't have an emoji in a table name, or that kind of thing.
To verify that it worked, do this:
```
mysql -e "select default_character_set_name from information_schema.SCHEMATA where schema_name='cs340_ramseyst';"
+----------------------------+
| default_character_set_name |
+----------------------------+
| utf8mb4                    |
+----------------------------+
```
Now go to `classmysql.engr.oregonstate.edu`, log into phpMyAdmin,
and click on the "Databases" tab. The character 
encoding for `cs340_ramseyst` should show up as `utf8mb4_general_ci`.
