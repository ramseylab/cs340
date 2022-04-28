import MySQLdb
import flask
import configparser


def read_mysql_config(mysql_config_file_name: str):
    config = configparser.ConfigParser()
    config.read(mysql_config_file_name)
    return dict(config['client'])


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


