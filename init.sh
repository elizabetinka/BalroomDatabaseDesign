#!/bin/bash
db_name=$(grep -E 'DB_NAME' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_user=$(grep -E 'DB_USER' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')
psql -U $db_user -d $db_name -c "CREATE ROLE admin WITH LOGIN CREATEDB;"

last_version="0.0.0"
mig_path="/docker-entrypoint-initdb.d/migrations"
num=$(grep -E 'MIG_VERSION' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')
if [[ "$num" == "" ]]
then
    psql -U admin -d $db_name -f "$mig_path/$last_version.sql"
else
    array=$(ls $mig_path | sort )
    for file in "$array"
    do 
    psql -U admin -d $db_name -f "$mig_path/$file"
    if [[ "$file" == "$num.sql" ]]
    then 
        break
    fi

    done;
fi
gen_path="/docker-entrypoint-initdb.d/generator"
count=$(grep -E 'COUNT' /docker-entrypoint-initdb.d/env | awk 'BEGIN { FS = "=" } ; {print $2}')

if [[ "$num" == "" ]]
then
    psql  -U admin -d $db_name -v count=$count -f "$gen_path/$last_version.sql"
else
    array=$(ls $gen_path | sort )
    for file in "$array"
    do 
    psql  -U admin -d $db_name -v count=$count -f "$gen_path/$file"
    if [[ "$file" == "$num.sql" ]]
    then 
        break
    fi

    done;
fi
