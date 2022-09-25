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

base_query = 'insert into fn2hash (executable_md5, addr, num_basic_blocks, num_basic_blocks_in_cfg, num_instructions, num_bytes, exact_hash, pic_hash, composite_pic_hash, mnemonic_hash, mnemonic_count_hash, mnemonic_category_hash, mnemonic_category_count_hash, version_id) values '.encode('utf-8')

query = base_query
query_x = 0

with open('exec/%s/%s/%s/fn2hash.csv' % (target_version, target_platform, target_os) , 'r') as fh:
    for line in fh:
        row = line.split(",")
        query += cur.mogrify('(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s),', (row[0], int(row[1],16), row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], this_version_id))
        query_x += 1
        if query_x >= 100:
            query = query[:-1] + cur.mogrify( ' on conflict do nothing')
            cur.execute(query)
            dbh.commit()
            query = base_query
            query_x = 0
        
query = query[:-1] + cur.mogrify( ' on conflict do nothing')
cur.execute(query)
dbh.commit()


#14009c4b0###CContextOwner::AccessGameControllerGroup###CPdxGameControllerGroup * __thiscall AccessGameControllerGroup(void)###CPdxGameControllerGroup * thiscall AccessGameControllerGroup(void)###[]###[CPdxGameControllerGroup* <RETURN>@RAX:8]###<bound method ghidra.program.database.function.FunctionDB.getSignatureSource of CContextOwner::AccessGameControllerGroup>


