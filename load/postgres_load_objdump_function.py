#!/usr/bin/python3
import psycopg2
import psycopg2.extras

target_version = '3.5.2'
target_platform = 'steam'
target_os = 'windows'


# Connect to Postgres
dbh = psycopg2.connect("dbname=stellar-fnaddr user=postgres") or logging.critical('Unable to connect to database');
cur = dbh.cursor(cursor_factory = psycopg2.extras.RealDictCursor) #results return associative dicts instead of tuples.
psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(list, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(tuple, psycopg2.extras.Json)


cur.execute('select id from versions where version=%s and platform=%s and os=%s', (target_version, target_platform, target_os));

this_version_id = cur.fetchall()[0]['id']


base_query = 'insert into objdump_function (version_id, vma, start_addr, end_addr, unwind) values '.encode('utf-8')
query = base_query
query_x = 0

with open('exec/%s/%s/%s/stellaris.exe.objdump.functions' % (target_version, target_platform, target_os) , 'r') as fh:
    for line in fh:
        try:
            row = line.split(":")
            row2 = row[1].strip().split(' ')
        
            query += cur.mogrify('(%s, %s, %s, %s ,%s),', (this_version_id, int(row[0].strip(),16), int(row2[0],16), int(row2[1],16), int(row2[2],16)))
        except:
            continue
        query_x += 1

        if query_x >= 100:
            query = query[:-1] + cur.mogrify(' on conflict do nothing')
            cur.execute(query)
            dbh.commit()
            query = base_query
            query_x = 0
    

query = query[:-1] + cur.mogrify(' on conflict do nothing')
cur.execute(query)
dbh.commit()

# 0000000142818330:      00000001400038b0 00000001400038e3 0000000141ac9f48
# 000000014281833c:      0000000140003940 00000001400039f8 0000000141ae4dc4

