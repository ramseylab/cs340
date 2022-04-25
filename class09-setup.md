# What this tutorial is about

In this tutorial, I'll walk you through how to set up Jan Harrington's 
"rare book store" database (from Chapter 16) in your MariaDB database, 
so that you can query it in MariaDB.

As with the previous tutorials in this GitHub project area, whenever you see
`ramseyst` in the commands shown below, you should substitute your own ONID
username. This tutorial assumes that you have previously created your
`~/.my.cnf` MySQL configuration file on the "flip" server system, as described
in the
[Assignment&nbsp;1](https://github.com/ramseylab/cs340/blob/main/assignment1.md)
tutorial.

## How to dump a MariaDB database to a file

At some point, you might want to make a backup copy of your MariaDB CS340
database.  To do that, you can use the `mysqldump` command on the flip servers.
I'll show you how to do it. First, log onto the flip server, using OpenSSH, like
this:

```
ssh ramseyst@access.engr.oregonstate.edu
```
Next, you'll want to add a new section to your `~/.my.cnf` file.
Using your favorite editor, open `~/.my.cnf` for editing,
```
emacs -nw ~/.my.cnf
```
(here I am using Emacs), and then add these three lines to `~/my.cnf`:
```
[mysqldump]
user=cs340_ramseyst
password=XXXXXXXX
```
where of course, you should substitute your actual MariaDB password
in place of `XXXXXXXX`. Now save and quit your editor. To make a SQL
dump file of your CS340 database, at the command-line, type
```
mysqldump cs340_ramseyst > my-dump-file.sql
```
where you can substitute any file name you want in place of
`my-dump-file.sql`. Note that if you have "noclobber" set in
your shell, then `mysqldump` will refuse to overwrite `my-dump-file.sql`
if it already exists. You can turn off that behavior using a 
one-line shell command. If you are in the tcsh shell,
```
unset noclobber
```
or if you are in the bash shell,
```
set +o noclobber
```
You can automate this for each time you log into the "flip" server by
putting the above shell script line in your `~/.cshrc` or `~/.bashrc` file
(depending on which shell you are using). To restore the behavior
where the shell refuses to overwrite an existing file, you would type
(in tcsh):
```
set noclobber
```
or in bash,
```
set -o noclobber
```
To drop all tables from your database, you would run the
mysql client
```
mysql
```
and then within your `mysql` client session, you would type:
```
drop database cs340_ramseyst;
create database cs340_ramseyst;
use cs340_ramseyst;
```
To load in your database from your dump file,
```
source ./my-dump-file.sql;
```
or equivalently, from the bash prompt,
```
mysql <./my-dump-file.sql
```

## Load database from SQL dump file

To load Harrington's Rare Books Store database from a SQL dump file, you would do the
following steps on the "flip" system:
```
curl -L -s https://raw.githubusercontent.com/ramseylab/cs340/main/class09-rare-book-database-dump.sql > class09-rare-book-database-dump.sql
```
Then drop your current `cs340_ramseyst` MariaDB as described above, and create a new
empty `cs340_ramseyst` database as described above, and load it using the following
shell command,
```
mysql <./class09-rare-book-database-dump.sql
```

## Try out the various SELECT queries in the tutorial

Now, go to the file [class09-rare-book-database-queries](https://github.com/ramseylab/cs340/blob/main/class09-rare-book-database-queries.sql)
and read the comments and try out the SQL commands that are interspersed with the comments in that file.

