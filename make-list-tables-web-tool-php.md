# A simple web page that lists tables in your CS340 MariaDB database

In this tutorial, I'll walk you through how to make a simple web page with 
server-side scripting to query a database (the `bsg_db.sql` database from 
Assignment&nbsp;1) to find the names of all the tables in the database, and
to print the results in a little HTML table. 

Just a reminder, wherever you see `ramseyst` in the tutorial, you should
substitute your own ONID username.

# PHP solution

To do this in PHP, you will first want to ssh into `access.engr.oregonstate.edu` 
```
ssh ramseyst@access.engr.oregonstate.edu
```
(hit return to accept the default terminal type, "xterm-color").  Once on one of
the "flip" server, you'll need to set up your `public_html` directory, if it
doesn't already exist, like this:
```
mkdir -p public_html
```
and it should be owned by you (with octal permissions 755), which you can verify by doing 
```
ls -alh | grep public_html
```
which should produce
```
drwxr-xr-x.     2 ramseyst upg52106   27 Mar 27 10:03 public_html
```
If you don't see `drwxr-xr-x`, then you'll need to set the permissions
like this:
```
chmod 755 public_html
```
Next, you'll want to edit a file `list-tables.php` inside `public_html`, like this:
```
emacs -nw public_html/list-tables.php
```
where of course, instead of `emacs`, you can use your favorite editor, such as
`vim` or `nano`.  Note, if you want to use a desktop editor like `atom` on a
remote flip server, you should probably ssh into the flip server using X
forwarding, like this:
```
ssh -C -X ramseyst@access.engr.oregonstate.edu
```
You'll want to know which version of PHP is installed on the server:
```
php --version
```
which returns
```
PHP 7.4.28 (cli) (built: Feb 15 2022 13:23:10) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
```
but of course, that's a binary installed on the "flip" servers, not 
necessarily the binary that is being used to serve PHP on
`web.engr.oregonstate.edu`. So we can use phpMyAdmin and log in, and 
click on "PHP Information". Or you could make a little PHP 
script file `~/public_html/info.php` containing the following code:
```
<html>
    <body>
<?php
  print phpinfo();
?>
    </body>
</html>
```
then access it using
```
curl https://web.engr.oregonstate.edu/~ramseyset/info.php
```
or by pointing your web browser to the same URL. You'll see that
`web.engr.oregonstate.edu` is running PHP version 7.4.28.

Now, inside your editor, you want to make a web page, like this:
```
<html>
    <body>
<?php
    error_reporting(E_ALL);
    ini_set('display_errors', 'On');
    $settings = parse_ini_file('../.my.cnf', true, INI_SCANNER_RAW)['client'];
    $host = $settings['host'];
    $db = $settings['database'];
    echo "<h1>Tables for database: ", $db, "</h1>";
    echo "    <table border=\"1\">";
    $user = $settings['user'];
    $pass = $settings['password'];
    $charset = 'utf8mb4';
    $dsn = "mysql:host=$host;dbname=$db;charset=$charset";
    $opt = [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ];
    try {
        $pdo = new PDO($dsn, $user, $pass, $opt);
        $res = $pdo->query("SHOW TABLES");
        foreach ($res as $row) {
            echo "<tr><td>", $row['Tables_in_cs340_ramseyst'], "</td></tr>\n";
        }
    } catch (\PDOException $e) {
        $error_message = $e->getMessage();
        echo "<tr><td>", $error_message, "</td></tr>\n";
    }
?>
        </table>
    </body>
</html>
```
Now check the syntax of the file, like this:
```
cd public_html
php -l list-tables.php
```
which should produce the output:
```
No syntax errors detected in list-tables.php
```
Make sure your file has permissions 644, which does not seem to be the default:
```
chmod 644 list-tables.php
```
Note that this strategy for reading `.my.cnf` only works because the following two
conditions hold:

1. PHP is running as your own username, which you can verify by calling
`get_current_user()` from within PHP and printing the result.
2. The current working directory that PHP runs in for your PHP script, is
`~/public_html`.

When you run the script using 
```
curl https://web.engr.oregonstate.edu/~ramseyst/list-tables.php
```
it should produce a HTML table of output, like this:
```
<html>
    <body>
<h1>Tables for database: cs340_ramseyst</h1>    <table border="true"><tr><td>bsg_cert</td></tr>
<tr><td>bsg_cert_people</td></tr>
<tr><td>bsg_people</td></tr>
<tr><td>bsg_planets</td></tr>
        </table>
    </body>
</html>
```

