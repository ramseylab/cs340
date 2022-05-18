# run like this: FLASK_APP="class16.py" python -m flask run -h 0.0.0.0 -p 6502
# access like this: http://localhost:6502/

import MySQLdb, MySQLdb.cursors, pprint, configparser, os, flask

def read_config_section(config_file_name: str,
                        section: str) -> dict:
    config = configparser.ConfigParser()
    config.read(config_file_name)
    return dict(config[section if section is not None else 'client'])


mysql_config = read_config_section(os.path.join(os.path.expanduser("~"),
                                                ".my.cnf"),
                                   'client_local')

db_conn = MySQLdb.connect(*[mysql_config[k]
                            for k in ['host', 'user', 'password', 'database']])


webapp = flask.Flask(__name__, static_url_path='/static')

@webapp.route('/')
def main_page():
    return """<html>
    <body>
    <h3>Film Actor Database App</h3>
    <ul>
    <li><a href=\"/choose-associate-actor-to-film\">Associate an actor with a film</a></li>
    </ul>
    </body>
    </html>"""

    
@webapp.route('/choose-associate-actor-to-film')
def choose_associate_actor_to_film():
    res_html = """<html>
    <body>
    <form method=\"GET\" action=\"/associate-actor-to-film\">
    <h3>1. Choose an actor:</h3>
    <select name="actor_id" id="actor_id">
    """
    cursor = db_conn.cursor()
    cursor.execute('select actor_id, first_name, last_name from actor order by last_name, first_name;')
    for [actor_id, first_name, last_name] in cursor.fetchall():
        res_html += f"<option value=\"{actor_id}\">{first_name} {last_name}</option>\n"
    res_html += "</select>\n"
    cursor.execute('select film_id, title from film order by title;')
    res_html += """<h3>2. Choose a film:</h3>
    <select name="film_id" id="film_id">
    """
    for [film_id, title] in cursor.fetchall():
        res_html += f"<option value=\"{film_id}\">{title}</option>\n"
    res_html += """</select>
    <h3>3. When you are ready to submit:</h3>
    <input type="submit" value="associate actor and film" />
    </form>
    </body>
    </html>
    """
    return res_html


def associate_actor_to_film_func(actor_id, film_id):
    cursor = db_conn.cursor()
    cursor.execute('select count(*) from film_actor where actor_id=%s and film_id=%s;', [actor_id, film_id])
    num_rows = cursor.fetchone()[0]
    if num_rows > 0:
        return f"<html><body>Actor ID {actor_id} and film ID {film_id} are already associated in the database; <a href=\"/\">return</a></body></html>"
    cursor.execute('insert into film_actor (actor_id, film_id) values (%s, %s);', [actor_id, film_id])
    return f"<html><body>Actor ID {actor_id} and film ID {film_id} are now associated in the database; <a href=\"/\">return</a></body></html>"


@webapp.route('/associate-actor-to-film')   
def associate_actor_to_film():
    args = flask.request.args.to_dict()
    actor_id = args['actor_id']
    film_id = args['film_id']
    return associate_actor_to_film_func(actor_id, film_id)

if __name__ == "__main__":
    print(choose_associate_actor_to_film())
