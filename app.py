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

webapp = flask.Flask(__name__)

@webapp.route('/')
def get_tables():
    res_html = "<html>\n<body>\n<table border=\"1\">\n"
    cursor = db_conn.cursor()
    cursor.execute('show tables;', ())
    for [table_name] in cursor.fetchall():
        res_html += f"<tr><td>{table_name}</td></tr>\n"
    res_html += "</table>\n</body>\n</html>\n"
    return res_html
##get_tables = webapp.route('/')(get_tables)


