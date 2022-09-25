#!/usr/bin/python3
import psycopg2
import psycopg2.extras

target_version = '3.5.2'
target_platform = 'gog'
target_os = 'windows'


# Connect to Postgres
dbh = psycopg2.connect("dbname=stellar-fnaddr user=postgres") or logging.critical('Unable to connect to database');
cur = dbh.cursor(cursor_factory = psycopg2.extras.RealDictCursor) #results return associative dicts instead of tuples.
psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(list, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(tuple, psycopg2.extras.Json)


cur.execute('select id from versions where version=%s and platform=%s and os=%s', (target_version, target_platform, target_os));

this_version_id = cur.fetchall()[0]['id']

base_query = 'insert into symbols (symbol) values '.encode('utf-8')
query = base_query
query_x = 0

with open('exec/%s/%s/%s/func_addr.txt' % (target_version, target_platform, target_os) , 'r') as fh:
    for line in fh:
        row = line.split("###")
        query += cur.mogrify('(%s),', (row[1], ))
        query_x += 1
        if query_x >= 100:
            query = query[:-1] + cur.mogrify( ' on conflict do nothing')
            cur.execute(query)
            dbh.commit()
            query = base_query
            query_x = 0
if(query_x > 0):
    query = query[:-1] + cur.mogrify( ' on conflict do nothing')
    cur.execute(query)
    dbh.commit()



cur.execute('select id,symbol from symbols');
symbols = {}
for result in cur:
    symbols[result['symbol']] = result['id']

base_query = 'insert into symbol_addr (version_id, addr, symbol_id) values '.encode('utf-8')
query = base_query
query_x = 0

with open('exec/%s/%s/%s/func_addr.txt' % (target_version, target_platform, target_os) , 'r') as fh:
    for line in fh:
        row = line.split("###")
        query += cur.mogrify('(%s, %s, %s),', (this_version_id, int(row[0],16), symbols[row[1]]))
        query_x += 1

        if query_x >= 100:
            query = query[:-1] + cur.mogrify(' on conflict do nothing')
            cur.execute(query)
            dbh.commit()
            query = base_query
            query_x = 0

if query_x > 0:
    query = query[:-1] + cur.mogrify(' on conflict do nothing')
    cur.execute(query)
    dbh.commit()

#14009c4b0###CContextOwner::AccessGameControllerGroup###CPdxGameControllerGroup * __thiscall AccessGameControllerGroup(void)###CPdxGameControllerGroup * thiscall AccessGameControllerGroup(void)###[]###[CPdxGameControllerGroup* <RETURN>@RAX:8]###<bound method ghidra.program.database.function.FunctionDB.getSignatureSource of CContextOwner::AccessGameControllerGroup>


