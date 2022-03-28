# An in-class demonstration of how to do Assignment&nbsp;1 for CS340

## Stephen Ramsey
## CS340, Spring 2022

# Some documentation references you might find useful
In this class, we will be using the MariaDB relational database management
system. The definitive set of documentation for how to use MariaDB server is the
[MariaDB Server Documentation website](https://mariadb.com/kb/en/documentation/);
you'll want to bookmark that site for CS340. We will also be using the "mysql"
client program, to connect to MariaDB; the definitive set of documentation for
that program is the
[mysql - The MySQL Command-Line Client web pages](https://dev.mysql.com/doc/refman/8.0/en/mysql.html)
in Section 4.5.1 of the MySQl documentation at mysql.com.  You'll also be making
use of OpenSSH in this course; the definitive documentation for OpenSSH is the
[OpenSSH Manual Pages](https://www.openssh.com/manual.html) at openssh.com.

# Doing Assignment&nbsp;1, via the command-line interface (CLI) method

In this tutorial, I will show you how to set things up so that you can ssh into
the COE T.E.A.C.H. Linux servers and to connect (using the `mysql` client) to the
MariaDB server that COE provides on the host `classmysql.engr.oregonstate.edu`.
In all the steps below, `ramseyst` represents an ONID username; you should
substitute your own ONID username instead of `ramseyst`.

<!-- If your local computer is not on an IP address whose hostname is in the -->
<!-- `oregonstate.edu` domain, you will need to open a VPN connection to -->
<!-- OSU, before you can  -->

If you have not previously created an account for yourself on the College of
Engineering T.E.A.C.H. system, you'll need to do that first. Using a web
browser, go to
[https://teach.engr.oregonstate.edu](https://teach.engr.oregonstate.edu) and
click on "Create a new account (Enable your Engineering resources)". You'll have
to authenticate using your ONID username and password. It may take a few minutes
for your T.E.A.C.H. account to be set up. After that is done, you can proceed
with following these steps:

Since you will likely be doing some connecting to remote servers on the COE
T.E.A.C.H. infrastructure in this course, I recommend setting up key-based
authentication for ssh connections to T.E.A.C.H. Check if you already have an RSA
public key like this:
```
ls -alh ~/.ssh
```
(If you see files `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`, you already have an RSA key
pair; skip to the part below that starts with "Then copy the file to T.E.A.C.H.".)
Assuming you don't already have an RSA key pair, you need to create an RSA ssh key.
On Linux or macOS, you would do it like this (for Windows&nbsp;10, see 
[these instructions](https://phoenixnap.com/kb/generate-ssh-key-windows-10)):
```
ssh-keygen -t rsa -b 4096 
```
and hit return twice. This will create a file `id_rsa.pub` in the `~/.ssh` directory:
```
ls -alh ~/.ssh
```
Then copy the `~/.ssh/id_rsa.pub` file to T.E.A.C.H. like this:
```
scp ~/.ssh/id_rsa.pub ramseyst@access.engr.oregonstate.edu:.ssh/id_rsa.pub
```
you'll have to authenticate using a password and 2FA using "Duo push". 
To get signed up for 2FA using Duo, visit [beav.es/duo](https://beav.es/duo).
Now ssh in using your password
```
ssh ramseyst@access.engr.oregonstate.edu
```
You'll be prompted to enter a "Terminal type"; just hit return to accept the
default terminal type, `xterm-color`. You'll note that the shell prompt says "flip"
and then a number. There are three COE Linux servers that students ssh into: flip1, 
flip2, and flip3; you can see from the shell prompt which one you are logged into.
Now in the remote session, install your RSA public key file into
`~/.ssh/authorized_keys` and clean up the file that you no longer need:

```
cat id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
rm -f id_rsa.pub
```
Now exit the remote session so you can test out the key-based authentication:
```
exit
```
Now ssh back into`access.engr.oregonstate.edu`; you should no longer be challenged for
a password when you do so:
```
ssh ramseyst@access.engr.oregonstate.edu`
```
but you will still be asked to specify a terminal type (just accept the default).
At this point, on the remote server, you will want to make a directory for this assignment and change
the current working directory to be inside it: 
```
mkdir assignment1 cd
assignment1
```
Now, you'll want to download the SQL file that defines the database that we will
use for this assignment, into the `assignment1` subdirectory:
```
wget https://raw.githubusercontent.com/ramseylab/cs340/main/bsg_db.sql
```
You should have a MariaDB user account already created for you on the Linux
server `classmysql.engr.oregonstate.edu`, with username like `cs340_ramseyst`
(substitute your ONID for mine). The default password is the last four digits of
your OSU ID number. Let's test out connecting to MariaDB via the command-line.
Because MariaDB is a GPL-licensed fork of MySQL that strives for compatibility,
the command-line client program is still `mysql`. From the shell session on
flip, to display a quick-reference on how to use `mysql`, you can use the command:
```
man mysql
```
To connect and open a command session on the MariaDB server, from a remote shell session
on one of the "flip" servers, run this command:
```
mysql -u cs340_ramseyst -h classmysql.engr.oregonstate.edu -p
```
and it will prompt you for your password. Enter your default password, and
you should get a prompt like `MariaDB [(none)]> `. Now you should change
your password to something you will remember:
```
set password = password('xxxxxxxx');
```
substitute your actual password for `xxxxxxxx`. Don't use your ONID password or
a password that you use for anything else, here. This password will be stored in
your home directory on the T.E.A.C.H. infrastructure in a config file, in an
unencrypted format. So it will not be stored securely. Thus it should not also
be the same as the password for any other account that you are responsible for
keeping secure or that you care about. It should acknowledge with `Query OK, 0 rows affected (0.001 sec)`.
Now exit using `quit;`, and then rerun the above `mysql` command to try logging in with your
new password:
```
mysql -u cs340_ramseyst -h classmysql.engr.oregonstate.edu -p
```
autheticate with your new password, and you should once again see the new prompt
`MariaDB [(none)]> `. Now, exit again using `quit;` and we're going to set up a
`mysql` client config file so you don't have to type your MariaDB password again
and again.  Using your favorite text editor (`vi`, `emacs`, `nano`, etc.),
create a text file `~/mysql.conf`,
```
emacs -nw ~/.my.cnf
```
and in that file you would put the following lines:
```
[client]
host=classmysql.engr.oregonstate.edu
database=cs340_ramseyst
user=cs340_ramseyst
password=xxxxxxxx
```
substituting your _new_ MariaDB password instead of `xxxxxxxx`. *Right away*, we need
to make that file readable only by your Linux user:
```
chmod 600 ~/.my.cnf
```
Now let's try to connect to MariaDB using your config file, without having to type
the hostname, a username, or a password to authenticate:
```
mysql
```
it should immediately show you the MariaDB session prompt. A MariaDB user can access
multiple databases on a given database server. Which one is our default database? 
Let's take a look, using the `select database()` command:
```
select database();
```
it returns
```
+----------------+
| database()     |
+----------------+
| cs340_ramseyst |
+----------------+
```
so the default database is the same as your MariaDB username, `cs340_ramseyst`.
You can load the database file `bsg_db.sql` into that database, from within
a `mysql` client session, using the `source` command:
```
source ./bsg_db.sql
```
It should print a bunch of rows that look like "Query OK, N rows affected",
where *N* varies from line to line of the output. How many databases are there?
Probably two:
```
show databases;
```
should return
```
+--------------------+
| Database           |
+--------------------+
| cs340_ramseyst     |
| information_schema |
+--------------------+
```
where the `information_schema` database is a "virtual database" (it's just
internal settings of MariaDB cosplaying as a database so that you can query it
using the same kind of query syntax you use for querying a real database with
real tables and rows); for now, we won't mess with `information_schema`.  A
MariaDB database is a collection of named _tables_. Let's see what tables we
created:
```
MariaDB [cs340_ramseyst]> show tables;
+--------------------------+
| Tables_in_cs340_ramseyst |
+--------------------------+
| bsg_cert                 |
| bsg_cert_people          |
| bsg_people               |
| bsg_planets              |
+--------------------------+
```
But what if you want to create your BSG database programmatically, via a script?
I'll show you how, but first you should delete all the existing stuff you just
imported into the `cs340_ramseyst` database, like this:
```
drop database cs340_ramseyst;
```
Verify that it is gone:
```
show databases;
```
should produce
```
+--------------------+
| Database           |
+--------------------+
| information_schema |
+--------------------+
```
Now create a new database `cs340_ramseyst`,
```
create database cs340_ramseyst;
```
Now you see it:
```
MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| cs340_ramseyst     |
| information_schema |
+--------------------+
```
but are you currently using it? Let's check:
```
MariaDB [(none)]> select database();
+------------+
| database() |
+------------+
| NULL       |
+------------+
```
no, there is no current database. But we can select it
as the current database, like this:
```
use cs340_ramseyst
```
to which MariaDB should respond, "Database changed". Let's check that it worked:
```
MariaDB [cs340_ramseyst]> select database();
+----------------+
| database()     |
+----------------+
| cs340_ramseyst |
+----------------+
```
Let's make sure there are no tables:
```
MariaDB [cs340_ramseyst]> show tables;
Empty set (0.000 sec)
```
We are ready to exit out of the `mysql` client and to load the database file
`bsg_db.sql` into a new database named `cs340_ramseyst`. Make sure 
your current directory is 
```
mysql <~/assignment1/bsg_db.sql
```
If it worked, `mysql` doesn't give a response at all (i.e., no error
message). Let's run a query from the command-line, to look at the tables:
```
mysql -e "show tables"
```
(note, you don't need a semicolon here if you are running one command) which prints
```
+--------------------------+
| Tables_in_cs340_ramseyst |
+--------------------------+
| bsg_cert                 |
| bsg_cert_people          |
| bsg_people               |
| bsg_planets              |
+--------------------------+
```
and returns control to the shell session (i.e., the `mysql` client in this mode
just executes one query and then terminates). Now, let's look at the structure 
of the table `bsg_planets`:
```
mysql -e "describe bsg_planets"
```
which prints a bunch of output
```
+------------+--------------+------+-----+---------+----------------+
| Field      | Type         | Null | Key | Default | Extra          |
+------------+--------------+------+-----+---------+----------------+
| id         | int(11)      | NO   | PRI | NULL    | auto_increment |
| name       | varchar(255) | NO   | UNI | NULL    |                |
| population | bigint(20)   | YES  |     | NULL    |                |
| language   | varchar(255) | YES  |     | NULL    |                |
| capital    | varchar(255) | YES  |     | NULL    |                |
+------------+--------------+------+-----+---------+----------------+
```
each row in the output describes a _column_ of the table `bsg_planets`.
If you want to know what the data types mean, you can read tye
[Data Types](https://mariadb.com/kb/en/data-types/) page in the MariaDB
knowledge base. It's too soon to explain everything in this output, but
it will become clearer over the next four weeks as the course progresses.
For now, it's enough to know that columns have names in a MariaDB database.
Now let's look at a single row of output from the `bsg_planets` table:
```
mysql -e "select * from bsg_planets limit 1"
```
which prints out:
```
+----+---------+------------+--------------+---------+
| id | name    | population | language     | capital |
+----+---------+------------+--------------+---------+
|  1 | Gemenon | 2800000000 | Old Gemenese | Oranu   |
+----+---------+------------+--------------+---------+
```
Now let's run the query that you are asked to run in the assignment:
```
mysql -e "select * from bsg_people"
```
which returns:
```
+----+-----------+-----------+-----------+------+
| id | fname     | lname     | homeworld | age  |
+----+-----------+-----------+-----------+------+
|  1 | William   | Adama     |         3 |   61 |
|  2 | Lee       | Adama     |         3 |   30 |
|  3 | Laura     | Roslin    |         3 | NULL |
|  4 | Kara      | Thrace    |         3 | NULL |
|  5 | Gaius     | Baltar    |         3 | NULL |
|  6 | Saul      | Tigh      |      NULL |   71 |
|  7 | Karl      | Agathon   |         1 | NULL |
|  8 | Galen     | Tyrol     |         1 |   32 |
|  9 | Callandra | Henderson |      NULL | NULL |
+----+-----------+-----------+-----------+------+
```

# Doing Assignment&nbsp;1, using the phpMyAdmin method

- Make sure you are on the OSU network (use VPN if you are not on the OSU network).

- Download the `bsg_db.sql` file:

```
curl -L -s https://raw.githubusercontent.com/ramseylab/cs340/main/bsg_db.sql > bsg_db.sql
```

- With your web browser, navigate to [classmysql.engr.oregonstate.edu](https://classmysql.engr.oregonstate.edu)

- Authenticate using your MariaDB username (like `cs340_ramseyst`) and your new password.

- Click the "Databases" tab on the top-level row of tabs and select the `cs340_ramseyst` database

- Click the "Import" tab on the top-level row of tabs and click the "Browse..." button. Select your local `bsg_db.sql` file and click the "Open" button. 

- Click the "Query" tab on the top-level row of tabs and in the bottom text-box with "1" next to it, type
```
select * from bsg_people
```

