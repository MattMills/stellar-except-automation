#!/usr/bin/python3
import psycopg2
import psycopg2.extras
import gzip
from datetime import datetime

target_version = '3.4.5'
target_platform_left = 'gog'
target_platform_right = 'steam'
target_os = 'windows'
hash_type = 'pic_hash'


# Connect to Postgres
dbh = psycopg2.connect("dbname=stellar-fnaddr user=postgres") or logging.critical('Unable to connect to database');
cur = dbh.cursor(cursor_factory = psycopg2.extras.RealDictCursor) #results return associative dicts instead of tuples.
psycopg2.extensions.register_adapter(dict, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(list, psycopg2.extras.Json)
psycopg2.extensions.register_adapter(tuple, psycopg2.extras.Json)


limit = 100
total_rows = 0
symbols = "'CTrigger::Evaluate', 'CTrigger::EvaluateExtended', 'CEffect::ExecuteActual','CEvent::ExecuteActual','CEvent::PerformImmediate','COnActionDatabase::PerformEvent','CEveryInListEffect::ExecuteActual','CRandomInListEffect::ExecuteActual','CShip::DailyUpdateRepair','CShip::CalcRegenAmount','CPlanetView::UpdatePopulationTab','CFleetManagerView::Update','CPlanetView::GetToolTip'"


query = cur.mogrify('with \n'
                ' v_l as (select id, upper(md5) as md5 from versions where version=%s and os=%s and platform=%s),\n'
                ' v_r as (select id, upper(md5) as md5 from versions where version=%s and os=%s and platform=%s)\n'
        'select s_l.symbol as symbol_l, to_hex(f2h_l.addr) as addr_l, to_hex(f2h_r.addr) as addr_r, s_r.symbol as symbol_r\n'
        ' from  v_l, v_r, symbols s_l\n'
        '  left join symbol_addr sa_l on (s_l.id = sa_l.symbol_id)\n'
        '  left join fn2hash f2h_l on (f2h_l.addr = sa_l.addr )\n'
        '  left join fn2hash f2h_r on (f2h_l.'+hash_type+' = f2h_r.'+hash_type+')\n'
        '  left join symbol_addr sa_r on (f2h_r.addr = sa_r.addr)\n'
        '  left join symbols s_r on (sa_r.symbol_id = s_r.id)\n'
        ' where \n'
        '  s_l.symbol in ('+symbols+')\n'
        '   and f2h_l.version_id = v_l.id\n'
        '   and f2h_r.version_id = v_r.id\n'
        '   and sa_l.version_id = v_l.id\n'
        '   and (sa_r.version_id = v_r.id or sa_r.version_id is null)\n'
        ' order by s_l.symbol asc, f2h_l.addr asc, f2h_r.addr asc, s_r.symbol asc\n'
        #' limit %s offset %s\n'
        , (target_version, target_os, target_platform_left, target_version, target_os, target_platform_right,)# limit, offset)
        )

cur.execute(query)
print('[%s]: rowcount: %s total: %s' % (datetime.now(), cur.rowcount, total_rows))
for row in cur:
    total_rows += 1
    print('addr_map[VERSION_3_4_5][OS_WINDOWS][GOG]["%s"] = %s' % (row['symbol_l'], row['addr_l'],))

    




