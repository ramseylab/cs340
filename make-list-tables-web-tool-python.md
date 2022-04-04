# How to set up a basic Flask application that queries MySQL

In this tutorial, I'll show you how to set up a toy Python/Flask
web application that will query your CS340 MariaDB database
to get the list of tables in the database, and to display the
list in an HTML table. It will also display the OSU logo
as an inline image, as an example of how we can serve static
files (i.e., static content) through your Flask applicaiton.

In all of the steps below, `ramseyst` should be understood to
represent your ONID username.

If you are not on-campus, you'll want to start by establishing
a VPN connection to the OSU campus network (you don't need that to
SSH into the "flip" servers as you know, but you will need it to
be able to connect to your Flask application via HTTP). See the
[OSU VPN Knowledge Base](https://oregonstate.teamdynamix.com/TDClient/1935/Portal/KB/?CategoryID=6889).

Now, for this exercise, you'll want to log into the flip servers,
as explained in the tutorial [assignment1.md](assignment1.md),
```
ssh ramseyst@access.engr.oregonstate.edu
```
Make note of which `flip` server you have logged into (it should be shown in
your shell prompt, but you can also see it by entering the command `hostname`).
Next, you'll want to create a python3 virtual environment (virtualenv) which is
essentially your own private copy of python3, where you can install whatever
python packages your application will need.
```
python3 -m venv venv
```
Next, you'll want to activate your virtualenv, like this:
```
source venv/bin/activate.csh
```
Your prompt should now have the string `[venv]` prepended to it.
Next, you will want to create a subdirectory for your flask
project, like this:
```
mkdir -p cs340-flask
```
Check which pip you are using
```
which pip
```
it should be 
```
/nfs/stak/users/ramseyst/venv/bin/pip
```
Now install (from PyPI) the packages that you will need, which are `mysqlclient` and `Flask`:
```
pip install mysqlclient Flask
```
Go into your `cs34-flask` directory:
```
cd cs340-flask
```
You'll need a subdirectory for static content; so make one (inside your `cs340-flask` directory):
```
mkdir -p static
```
And copy a little image file into the static folder, to test it out:
```
curl -L -s https://raw.githubusercontent.com/ramseylab/cs340/main/logo.png > static/logo.png
```
Now, use your favorite text editor to create a file `app.py`,
```
import MySQLdb
import flask

def read_mysql_config(mysql_config_file_name: str):
    with open(mysql_config_file_name, "r") as mysql_conf:
        config_info = dict()
        for line in mysql_conf.readlines():
            if line.startswith('['): continue
            config_info.update(dict([(substr.split()[0] for substr in line.split('='))]))
    return config_info

config_info = read_mysql_config("../.my.cnf")

db_conn = MySQLdb.connect(config_info['host'],
                          config_info['user'],
                          config_info['password'],
                          config_info['database'])

webapp = flask.Flask(__name__, static_url_path='/static')

@webapp.route('/')
def get_tables():
    res_html = "<html>\n<body>\n<table border=\"1\">\n"
    cursor = db_conn.cursor()
    cursor.execute('show tables;', ())
    for [table_name] in cursor.fetchall():
        res_html += f"<tr><td>{table_name}</td></tr>\n"
    res_html += "</table>\n"
    res_html += "<img src=\"/static/logo.png\" />\n</body>\n</html>\n"
    return res_html
##get_tables = webapp.route('/')(get_tables)
```
The last comment shows (in plain python syntax) what the somewhat
mysterious-looking "decorator" directive `@webapp.route('/')` does.  Before we
go any further, let's set up Flask to run in "development" mode (the default is
"production" mode), which will show an interactive traceback if an error occurs,
rather than "internal server error".
```
setenv FLASK_ENV development
```
Note, this only sets `FLASK_ENV` for your current terminal session,
it isn't permanent; you can configure it permanently using your `~/.cshrc` file
or alternatively, by using a virtualenv `postactivate` hook.
Now, to make sure that you are running in the virtualenv, try
```
which python
```
and it should print a result like this:
```
/nfs/stak/users/ramseyst/venv/bin/python
```
Now, still in your virtualenv, start up the Flask application, like this:
```
python -m flask run -h 0.0.0.0 -p NNNN
```
where in place of `NNNN`, you would specify a TCP port number, 
an integer between 1,024 and 65,535 that is not already in use by another application. How
can you tell which TCP ports are in use by another application?
```
netstat -tulpn | grep LISTEN | cut -f4 -d\: | cut -f1 -d\  | sort -n | uniq
```
When you run the above `python` command specifying a port number
(e.g., 65,505), you would see something like this:
```
[venv] flip3 ~/cs340-flask 232% python -m flask run -h 0.0.0.0 -p 65505
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://128.193.36.41:65505/ (Press CTRL+C to quit)
 ```
Your Flask application is serving as a webserver, at least until you terminate
it by giving it a SIGINT or logging out of your remote terminal session). 
There is a way to make your Flask application run in the background so that 
you don't have to leave a remote terminal session running long-term (leaving a
remote terminal session running for a long time is not really practical because it
can be terminated unexpectedly due to a transient network interruptation, and
is also somewhat of a security anti-pattern). To run your Flask application in
the background, you can use Green Unicorn (`gunicorn`) as outlined in the 
[CS340 starter Flask app on GitHub](https://github.com/knightsamar/CS340_starter_flask_app).
For the purpose of this simple tutorial, just leave your Flask application running
in your remote terminal session. Now, for the next step, you will need to either
be on-campus or your computer will need to be logged into the VPN. Assuming that's
the case, you can point your web browser to:
```
http://flip3.engr.oregonstate.edu
```
and you should see the following HTML output (rendered of course):
```
<html>
<body>
<table border="1">
<tr><td>bsg_cert</td></tr>
<tr><td>bsg_cert_people</td></tr>
<tr><td>bsg_people</td></tr>
<tr><td>bsg_planets</td></tr>
</table>
</body>
</html>
```
Once you are done with your testing, you can terminate your Flask application
by going to the terminal session in which you started the Flask application
and typing `<ctrl>-c` which will issue a SIGINT signal to the application.

When you are ready to run your server for real, you can install `gunicorn`
like this:
```
pip install gunicorn
```
Then (making sure that your current working directory is `~/cs340-flask`), run
```
~/venv/bin/gunicorn -w 4 -b 0.0.0.0:NNN -D app:webapp
```
and it will run in the background. To shut it down, use
`ps axwf | less` and look for your specific TCP port number; it will
look something like this:
```
18608 ?        S      0:00 /nfs/stak/users/ramseyst/venv/bin/python3 /nfs/stak/users/ramseyst/venv/bin/gunicorn -w 4 -b 0.0.0.0:6550
18611 ?        S      0:00  \_ /nfs/stak/users/ramseyst/venv/bin/python3 /nfs/stak/users/ramseyst/venv/bin/gunicorn -w 4 -b 0.0.0.0:
18612 ?        S      0:00  \_ /nfs/stak/users/ramseyst/venv/bin/python3 /nfs/stak/users/ramseyst/venv/bin/gunicorn -w 4 -b 0.0.0.0:
18614 ?        S      0:00  \_ /nfs/stak/users/ramseyst/venv/bin/python3 /nfs/stak/users/ramseyst/venv/bin/gunicorn -w 4 -b 0.0.0.0:
18615 ?        S      0:00  \_ /nfs/stak/users/ramseyst/venv/bin/python3 /nfs/stak/users/ramseyst/venv/bin/gunicorn -w 4 -b 0.0.0.0:
```
Kill the parent process (the top-level one shown, which has PID 18605 in this case)
using `kill -9`.
