# How to set up a basic Node.js application that queries MySQL

In this tutorial, I'll show you how to set up a toy Node.js web
application that will query your CS340 MariaDB database to get the
full list of tables in the database, and to display the
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
Next, on the `flipN` server (where _N_ is either 1, 2, or 3), you'll want to
make a subdirectory `cs340-node`,
```
mkdir -p cs340-node
```
Next, `cd` inside that directory
```
cd cs340-node
```
Now, let's install the `mysql` package for Node.js. To do that, we'll use a
command called `npm`, like this:
```
/bin/npm install mysql
```
The `npm` command will print a bunch of stuff to the terminal session, like this:
```
hello-world@1.0.0 /nfs/stak/users/ramseyst
└─┬ mysql@2.18.1
  ├── bignumber.js@9.0.0
  ├─┬ readable-stream@2.3.7
  │ ├── core-util-is@1.0.3
  │ ├── inherits@2.0.4
  │ ├── isarray@1.0.0
  │ ├── process-nextick-args@2.0.1
  │ ├── string_decoder@1.1.1
  │ └── util-deprecate@1.0.2
  ├── safe-buffer@5.1.2
  └── sqlstring@2.3.1
```
Next, we'll need the `express` package for Node.js, which will act as our
HTTP routing middleware,
```
/bin/npm install express
```
which should print a bunch of other stuff to the terminal session,
```
hello-world@1.0.0 /nfs/stak/users/ramseyst
└─┬ express@4.17.3
  ├─┬ accepts@1.3.8
  │ ├─┬ mime-types@2.1.35
  │ │ └── mime-db@1.52.0
  │ └── negotiator@0.6.3
  ├── array-flatten@1.1.1
  ├─┬ body-parser@1.19.2
  │ ├── bytes@3.1.2
  │ ├─┬ http-errors@1.8.1
  │ │ └── toidentifier@1.0.1
  │ ├─┬ iconv-lite@0.4.24
  │ │ └── safer-buffer@2.1.2
  │ └── raw-body@2.4.3
  ├─┬ content-disposition@0.5.4
  │ └── safe-buffer@5.2.1
  ├── content-type@1.0.4
  ├── cookie@0.4.2
  ├── cookie-signature@1.0.6
  ├─┬ debug@2.6.9
  │ └── ms@2.0.0
  ├── depd@1.1.2
  ├── encodeurl@1.0.2
  ├── escape-html@1.0.3
  ├── etag@1.8.1
  ├─┬ finalhandler@1.1.2
  │ └── unpipe@1.0.0
  ├── fresh@0.5.2
  ├── merge-descriptors@1.0.1
  ├── methods@1.1.2
  ├─┬ on-finished@2.3.0
  │ └── ee-first@1.1.1
  ├── parseurl@1.3.3
  ├── path-to-regexp@0.1.7
  ├─┬ proxy-addr@2.0.7
  │ ├── forwarded@0.2.0
  │ └── ipaddr.js@1.9.1
  ├── qs@6.9.7
  ├── range-parser@1.2.1
  ├── safe-buffer@5.2.1
  ├─┬ send@0.17.2
  │ ├── destroy@1.0.4
  │ ├── mime@1.6.0
  │ └── ms@2.1.3
  ├── serve-static@1.14.2
  ├── setprototypeof@1.2.0
  ├── statuses@1.5.0
  ├─┬ type-is@1.6.18
  │ └── media-typer@0.3.0
  ├── utils-merge@1.0.1
  └── vary@1.1.2
```
We will also need the `node-ini` package, so that we can read the `.my.cnf` file
from your Node.js application,
```
/bin/npm install node-ini
```
which should print the following to the terminal session,
```
hello-world@1.0.0 /nfs/stak/users/ramseyst
└── node-ini@1.0.0
```
Finally, we'll want to specify the TCP port number that Node.js should use, for
its built-in HTTP server (you'll recall from the Python demo that the port
number must be an integer between 1,024 and 65,535, that is not already in use
by another application running on the same flip server.  I prefer to pass the
port number to the Node.js application via the command-line, so that the port
number appears in the process table and is required to be explicitly shown on
the command-line.  (Environment variables, which are sometimes used for
configuration, _can_ be set elsewhere such as in the `.bashrc`, which makes it
harder for someone who needs to maintain your software, to see the exact runtime
parameters under which it is running.) So, to enable your Node.js application
to parse an argument from the command-line, you'll need to install the 
`process.argv` pcakage,
```
/bin/npm install process.argv
```
which should display the following text to the terminal session,
```
hello-world@1.0.0 /nfs/stak/users/ramseyst
└─┬ process.argv@0.6.0
  └── obop@0.2.1
```
If you list the current directory, 
```
ls -l
```
you'll see that the `npm install` commands have created a `node_modules` subdirectory
```
flip1 ~/cs340-node 164% ls -l
total 128
drwxrwx---. 109 ramseyst upg52106 2957 Apr 12 21:48 node_modules
```
with 483 files in it, which you can see by using `find`,
```
flip1 ~/cs340-node 165% find node_modules/ -type f | wc -l
483
```
Next, create a subdirectory `static` for your static content, 
like PNG images,
```
mkdir -p static
```
Copy your OSU logo PNG image into that subdirectory,
```
curl -L -s https://raw.githubusercontent.com/ramseylab/cs340/main/logo.png > static/logo.png
```
Now, let's create our Node.js application by creating a file
`app.js` using our favorite editor (here shown using `emacs`):
```
emacs -nw app.js
```
and let's paste the following code in there:
```
// load the "node-ini" module and assign it to variable "ini"
let ini = require('node-ini');

// parse the MySQL client configuration file, ~/.my.cnf 
// and extract the configuration info under the "client" key
let mysql_config = ini.parseSync('../.my.cnf').client;

// load the "mysql" module 
let mysql = require('mysql');

// create a MySQL connection pool object using the
// database server hostname, database username, 
// database user password, and database name specified
// in the MySQL client configuration file
let mysql_pool = mysql.createPool({
    connectionLimit : 10,
    host            : mysql_config.host,
    user            : mysql_config.user,
    password        : mysql_config.password,
    database        : mysql_config.database});

// load the "express" module
let express = require('express');

// create the Express application object
let app = express();

// get the TCP port number from the ccommandline
let port = process.argv[2];

// configure static routing for the '/static/' subdirectory
app.use('/static', express.static('static'));

app.get('/', (req, res) => { // the arrow notation means: function(req, res) { ...
    let pool = req.app.get('mysql');
    mysql_pool.query('show tables;',   // could opt to use a setting on `app` instead of a module variable
               function(error, results, fields) {
                   if (error) {
                       res.write(JSON.stringify(error));
                       res.end();
                   }
                   let table_names = results.map(obj => Object.keys(obj).map(k => obj[k])[0]);
                   /* The following line of code is nicer, but only can be used if you are using ES2017 or newer: */
//                 let table_names = results.map(obj => Object.values(obj)[0]);
                   res.write("<html>\n<body>\n<h1>Tables in my CS340 database:</h1>\n<table border=\"1\">\n");
                   table_names.map(table_name => res.write(`<tr><td>${table_name}</td></tr>\n`));
		   res.write("</table>\n");
                   res.write("<img src=\"static/logo.png\" />\n</body>\n</html>\n");
		   res.end();
    	       });
});

// start the Node.js webserver
app.listen(port, () => {
  // note, for a string delimited with backticks, there is variable 
    // interpolation within the string
    let pid = require('process').pid;
    console.log(`Example app listening on port ${port}; PID: ${pid}`);
});
```
Alternatively, if you don't want to paste in all that code, you can get it from 
GitHub using `curl`,
```
curl -L -s https://raw.githubusercontent.com/ramseylab/cs340/main/app.js > app.js
```
Let's check what TCP ports are available; from the python demo, let's reuse
this shell command,
```
netstat -tulpn | grep LISTEN | cut -f4 -d\: | cut -f1 -d\  | sort -n | uniq
```
Perhaps you will find that on your flip server, TCP port 65521 is open. In that
case, to start your Node.js application and have it listen on port 65521,
while still in the `cs340-node` subdirectory, you would enter this command:
```
node app.js 65521
```
It should print the following to the terminal session:
```
Example app listening on port 65521; PID: 23180
```
(Note, PID means process identifier, and yours will be different from 23180).
Now, with your web browser (making sure that if you are off campus, you are
logged into the campus VPN on the device on which you are using your web browser),
navigate to `http://flipN.engr.oregonstate.edu:65521`, substituting of course
the specific server number (1, 2, 3) for the server on which you started your
Node.js app, instead of `N`. It should display a list of tables, in HTML
(along with an inline image tag), like this:
```
<html>
<body>
<h1>Tables in my CS340 database:</h1>
<table border="1">
<tr><td>Customer</td></tr>
<tr><td>ProductOrder</td></tr>
<tr><td>bsg_cert</td></tr>
<tr><td>bsg_cert_people</td></tr>
<tr><td>bsg_people</td></tr>
<tr><td>bsg_planets</td></tr>
<tr><td>t1</td></tr>
</table>
<img src="static/logo.png" />
</body>
</html>
```
Note, with the simple Node.js / Express application setup that we are using
here, HTTPS is not supported. So you can't use 
`https://flipN.engr.oregonstate.edu:PORT`, you must use HTTP. For
information on how to set up HTTPS in Node.js, see 
the [Node.js documentation page on HTTPS](https://nodejs.org/api/https.html).

## Using `package.json`
Instead of having to manually install packages using `npm install`, you
could use a file that describes your application's Node.js package dependencies,
in JavaScript Object Notation (JSON) format. This file would be called 
`package.json` and it would live in your `cs340-node` subdirectory.
To create the file, just type
```
/bin/npm init -y
```
You'll see that your resulting `package.json` will look like this:
```
{
  "name": "cs340-node",
  "version": "1.0.0",
  "description": "",
  "main": "app.js",
  "dependencies": {
    "express": "^4.17.3",
    "mysql": "^2.18.1",
    "node-ini": "^1.0.0",
    "process.argv": "^0.6.0"
  },
  "devDependencies": {},
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```
Then, if you commit that `package.json` file to your project source code 
repository, the next time you want to install your Node.js packages for
a new deployment on some server, you could just use the command
```
/bin/npm install
```
and it will auto-detect the `package.json` file and install the four
package dependencies specified in the `package.json` file.

To turn off your Node.js application, just issue a SIGINT (`Ctrl-C`)
to the application in the terminal window. To run your Node.js application
in the background and have it keep running even after you log out,
normally we would use the Linux systemd framework, but that would require
superuser access so that we could add a script to `/etc/systemd/system`.
So instead, we can use a crude workaround, `nohup`:
```
nohup node app.js 65521 &
```
When you try that, it will print out the process ID (PID); make a note of it
(let's suppose it is 23180). 
Then log out of the terminal session, and your app
should still be running. To kill it, you can reference the process ID:
```
kill -9 23180
```


