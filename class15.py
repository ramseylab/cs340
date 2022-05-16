import MySQLdb, MySQLdb.cursors, pprint, configparser, os
from typing import Callable

VERBOSE = True

ASC_DESC = ['desc', 'asc'];

def read_config_section(config_file_name: str,
                        section: str) -> dict:
    config = configparser.ConfigParser()
    config.read(config_file_name)
    return dict(config[section if section is not None else 'client'])

def invalid_direction(c: list):
    raise ValueError(f"invalid value for order by direction: {c[1]}")
    return None

def make_select_querier(db_cursor: MySQLdb.cursors.Cursor) -> Callable:
    def select_querier(columns: list,
                       relation_sql: str = None,
                       filter_conditions: dict = None,
                       order_by: list = None,
                       select_col_aliases: dict = None):
        where_list, param_list = [], []
        if filter_conditions is not None:
            for column_name, column_filter_value in filter_conditions.items():
                if type(column_filter_value) in {float, int}:
                    where_list.append(f'{column_name} = %s')
                    param_list.append(column_filter_value)
                elif type(column_filter_value) in {str}:
                    where_list.append(f'{column_name} like %s')
                    param_list.append(f'%{column_filter_value}%')
                else:
                    raise ValueError(f"column {column_name} filter value {column_filter_value} " +
                                     f"has invalid type: {type(column_filter_value)}")
        sql_where_str = ' and '.join(where_list)
        if len(sql_where_str) > 0:
            sql_where_str = f' where {sql_where_str}';
        if select_col_aliases is None:
            columns_with_aliases = columns
        else:
            columns_with_aliases = [(c + (f" as {select_col_aliases[c]}") if c in select_col_aliases else c)
                               for c in columns]
        sql_columns = '*' if len(columns_with_aliases) == 0 else ', '.join(columns_with_aliases)
        sql_from_str = f" from {relation_sql}" if (relation_sql is not None and len(relation_sql) > 0) else ""

        if order_by is not None:
#            sql_order_by_substr = ', '.join([(f"{c[0]} asc" if c[1] == 1 else (f"{c[0]} desc" if c[1] == -1 else invalid_direction(c))) for c in order_by ])
            sql_order_by_substr = ', '.join([f"{c[0]} {ASC_DESC[int((c[1] + 1) / 2)]}" for c in order_by ])
            sql_order_by_str = f' order by {sql_order_by_substr}'
        else:
            sql_order_by_str = ''
        
        ## assemble the SQL statement from its four parts
        sql = f"select {sql_columns}{sql_from_str}{sql_where_str}{sql_order_by_str};"
        if VERBOSE: print(sql)
        if VERBOSE: pprint.pprint(param_list)
        db_cursor.execute(sql, param_list)
        return db_cursor.fetchall()
    return select_querier

mysql_config = read_config_section(os.path.join(os.path.expanduser("~"), ".my.cnf"), 'client_local')

db_conn = MySQLdb.connect(*[mysql_config[k]
                            for k in ['host', 'user', 'password', 'database']])

db_cursor = db_conn.cursor()
select_querier = make_select_querier(db_cursor)

# select_querier(['1'], None, None)
# results in: cursor.execute('select 1;', [])

# select_querier(['1+1'])
# results in: cursor.execute('select 1+1;', [])

# select_querier([], 'player', {'team_id': 3})
# results in: cursor.execute('select * from player where team_id = %s;', [3])

# select_querier([], 'player', {'player_name': 'e'})
# results in: cursor.execute('select * from player where player_name like %s;', ['%e%'])

# select_querier([], 'player', None)
# results in: cursor.execute('select * from player;', [])

# select_querier([], 'player')
# results in: cursor.execute('select * from player;', [])

# select_querier(['player_name', 'salary'], 'player', {})
# results in: cursor.execute('select player_name, salary from player;', [])

# select_querier(['player_name', 'team_name'], 'player join team on player.team_id = team.id', {})
# results in: cursor.execute('select player_name, team_name from player join team on player.team_id = team.id;', [])

# select_querier(['player_name', 'team_name'],
#                 'player join team on player.team_id = team.id',
#                 {'team_name': 'eav'})
# results in: cursor.execute('select player_name, team_name from player join team on player.team_id = team.id where team_name like %s;', ['%eav%'])

# select_querier(['player_name', 'team_name'],
#                 'player join team on player.team_id = team.id',
#                 {'team_name': 'eav'},
#                 select_col_aliases={'team_name': 'n'})
# results in: cursor.execute('select player_name, team_name as n from player join team on player.team_id = team.id where team_name like %s;', ['%eav%'])

# select_querier(['player_name', 'team_name'],
#                     'player join team on player.team_id = team.id',
#                     {'team_name': 'eav'},
#                     select_col_aliases={'player_name': 'n'},
#                     order_by=[['n', 1]])
# results in: cursor.execute('select player_name as n, team_name from player join team on player.team_id = team.id where team_name like %s order by n;', ['%eav%'])

# select_querier(['player_name', 'team_name'],
#                'player join team on player.team_id = team.id',
#                {'team_name': 'eav'},
#                select_col_aliases={'player_name': 'n'},
#                order_by=[['n', -1]])
# results in: cursor.execute('select player_name as n , team_name from player join team on player.team_id = team.id where team_name like %s order by n desc;', ['%eav%'])

