#!/bin/bash  
# GRANT pg_monitor TO postgres_exporter;
#ALTER USER postgres_exporter SET SEARCH_PATH TO postgres_exporter,pg_catalog,public;
db_name=$(grep -E 'DB_NAME' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_user=$(grep -E 'DB_USER' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(grep -E 'DB_PASSWORD' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(echo $db_password | awk '{print $NF}')

 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE reader WITH LOGIN; GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;"
 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE  writer WITH LOGIN; GRANT SELECT, UPDATE, INSERT ON ALL TABLES IN SCHEMA public TO writer;"
 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE  analytic WITH LOGIN; GRANT SELECT ON ProtocolFinal TO analytic;"
 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE  exporter LOGIN ENCRYPTED PASSWORD 'exporter';  GRANT CONNECT ON DATABASE $db_name TO exporter; GRANT SELECT ON ALL TABLES IN SCHEMA public TO exporter;"
 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE  exporter LOGIN ENCRYPTED PASSWORD 'exporter';  GRANT CONNECT ON DATABASE $db_name TO exporter; GRANT SELECT ON ALL TABLES IN SCHEMA public TO exporter;"

 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "GRANT pg_monitor TO exporter; ALTER USER exporter SET SEARCH_PATH TO exporter,pg_catalog,public;"

   PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE EXTENSION IF NOT EXISTS pg_stat_statements;"
   #PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "DROP EXTENSION  pg_stat_statements;"

   PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements' "

   PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "SET  pg_stat_statements.track TO 'all' "

   #PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "DROP EXTENSION  pg_stat_statements;"
   # python3 ./patronictl.py -c /home/postgres/postgres0.yml edit-config -p shared_preload_libraries=pg_stat_statements  
      # python3 ./patronictl.py -c /home/postgres/postgres0.yml edit-config -p  pg_stat_statements.track=all  
names_str=$(grep -E 'NAMES' ./.env| awk 'BEGIN { FS = "=" } ; {print $2}')
names=($(echo $names_str | tr ',' '\n'))  
  
for i in "${names[@]}"  
do  
 PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -c "CREATE ROLE  $i; GRANT group_role TO $i;"
done  