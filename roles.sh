#!/bin/bash  
db_name=$(grep -E 'DB_NAME' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_user=$(grep -E 'DB_USER' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')

psql -U $db_user -d $db_name -c "CREATE ROLE reader WITH LOGIN; GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;"
psql -U $db_user -d $db_name -c "CREATE ROLE writer WITH LOGIN; GRANT SELECT, UPDATE, INSERT ON ALL TABLES IN SCHEMA public TO writer;"
psql -U $db_user -d $db_name -c "CREATE ROLE analytic WITH LOGIN; GRANT SELECT ON ProtocolFinal TO analytic;"


psql -U $db_user -d $db_name -c "CREATE ROLE group_role; GRANT CONNECT ON DATABASE $db_name TO group_role;"

names_str=$(grep -E 'NAMES' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')
names=($(echo $names_str | tr ',' '\n'))  
  
for i in "${names[@]}"  
do  
psql -U $db_user -d $db_name -c "CREATE ROLE $i; GRANT group_role TO $i;"
done  