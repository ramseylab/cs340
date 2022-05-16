let ini = require('node-ini');

const path = require('node:path');

const VERBOSE = true;

const homedir = require('os').homedir();

// parse the MySQL client configuration file, ~/.my.cnf 
// and extract the configuration info under the "client_local" key
let mysql_config = ini.parseSync(path.join(homedir, '.my.cnf')).client_local;


// load the "mysql" module 
let mysql = require('mysql');


const asc_desc = ["desc", "asc"];

function make_select_querier(conn) {
    return (function (columns,
                      relation_sql = null,
                      filter_conditions = null,
                      order_by = null,
                      select_col_aliases = null) {
        var [where_list, param_list] = [[], []];
        if (! (filter_conditions === null)) {
            for (const [column_name, column_filter_value] of Object.entries(filter_conditions)) {
                if (typeof(column_filter_value) == "number") {
                    where_list.push(`${column_name} = ?`);
                    param_list.push(column_filter_value);
                } else if (typeof(column_filter_value) == "string") {
                    where_list.push(`${column_name} like ?`);
                    param_list.push(`%${column_filter_value}%`);
                } else {
                    throw new TypeError(`column ${column_name} filter value ${column_filter_value} has invalid type`);
                }
            }
        }
        var sql_where_str = where_list.join(' and ');
        if (sql_where_str.length > 0) {
            sql_where_str = ` where ${sql_where_str}`;
        }
        if (select_col_aliases === null) {
            var columns_with_aliases = columns;
        } else {
            var columns_with_aliases = columns.map(c =>
                ((c in select_col_aliases) ? `${c} as ${select_col_aliases[c]}` : c));
        }
        var sql_columns = (columns_with_aliases.length == 0) ? '*' : columns_with_aliases.join(', ');
        var sql_from_str = ((! (relation_sql === null)) && relation_sql.length > 0) ? ` from ${relation_sql}` : '';
        if (! (order_by === null)) {
            var sql_order_by_substr = order_by.map(c =>
                ( `${c[0]} ${asc_desc[(c[1] + 1)/2]}` )).join(', ');
            var sql_order_by_str = ` order by ${sql_order_by_substr}`;
        } else {
            var sql_order_by_str = '';
        }
        var sql = `select ${sql_columns}${sql_from_str}${sql_where_str}${sql_order_by_str};`;
        if (VERBOSE) {
            console.log(sql);
            console.log(param_list);
        }
        return new Promise (data => {
            conn.query(sql, param_list, function (error, results, fields) {
                if (error) {
                    console.log(error);
                    throw error;
                }
                try {
                    data(results);
                } catch (error) {
                    data({});
                    throw error;
                }
            });
        });
    });
}     


var main = async function() {
    let mysql_conn = mysql.createPool(mysql_config)
    var select_querier = make_select_querier(mysql_conn);
    var res = await select_querier(['1'], null, null);
    // results in: conn.query('select 1;', [])
    console.log(res);

    res = await select_querier(['1+1'], null, null);
    // results in: conn.query('select 1+1;', [])
    console.log(res);

    res = await select_querier([], 'player', {'team_id': 3});
    // results in: conn.query('select * from player where team_id = ?;', [3])
    console.log(res);

    res = await select_querier([], 'player', {'player_name': 'e'});
    // results in: conn.query('select * from player where player_name like ?;', ['%e%'])
    console.log(res);

    res = await select_querier([], 'player', null);
    // results in: conn.query('select * from player;', [])
    console.log(res);

    res = await select_querier([], 'player')
    // results in: conn.query('select * from player;', [])
    console.log(res);

    res = await select_querier(['player_name', 'salary'], 'player', {});
    // results in: conn.query('select player_name, salary from player;', [])
    console.log(res);

    res = await select_querier(['player_name', 'team_name'], 'player join team on player.team_id = team.id', {});
    // results in: conn.query('select player_name, team_name from player join team on player.team_id = team.id;', [])
    console.log(res);

    res = await select_querier(['player_name', 'team_name'],
                               'player join team on player.team_id = team.id',
                               {'team_name': 'eav'});
    // results in: conn.query('select player_name, team_name from player join team on player.team_id = team.id where team_name like ?;', ['%eav%'])
    console.log(res);

    res = await select_querier(['player_name', 'team_name'],
                               'player join team on player.team_id = team.id',
                               {'team_name': 'eav'},
                               null,
                               {'team_name': 'n'});
    // results in: conn.query('select player_name, team_name as n from player join team on player.team_id = team.id where team_name like ?;', ['%eav%'])
    console.log(res);

    res = await select_querier(['player_name', 'team_name'],
                               'player join team on player.team_id = team.id',
                               {'team_name': 'eav'},
                               order_by=[['n', 1]],
                               select_col_aliases={'player_name': 'n'});
    // results in: conn.query('select player_name as n, team_name from player join team on player.team_id = team.id where team_name like ? order by n;', ['%eav%'])
    console.log(res);

    res = await select_querier(['player_name', 'team_name'],
                               'player join team on player.team_id = team.id',
                               {'team_name': 'eav'},
                               order_by=[['n', -1]],                               
                               select_col_aliases={'player_name': 'n'});
    // results in: conn.query('select player_name as n , team_name from player join team on player.team_id = team.id where team_name like ? order by n desc;', ['%eav%'])
    console.log(res);
    
    mysql_conn.end();
}

try{
    main();
} catch ({ message }) {
    console.log(message);
}

