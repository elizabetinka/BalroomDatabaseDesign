#!/bin/bash
db_name=$(grep -E 'DB_NAME' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_user=$(grep -E 'DB_USER' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(grep -E 'DB_PASSWORD' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(echo $db_password | awk '{print $NF}')
psql -p 5000 -U $db_user -d $db_name -c  "CREATE ROLE admin WITH LOGIN CREATEDB;"

last_version="0.0.0"
mig_path="migrations"
num=$(grep -E 'MIG_VERSION' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
echo "num $num"
if [[ "$num" == "" ]]
then
   PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -f $mig_path/$last_version.sql
else
    array=$(ls $mig_path | sort )

    for file in ${array[*]}
    do 
    echo "start;$mig_path/$file:END"

    PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -f "$mig_path/$file"
    if [[ "$file" == "$num.sql" ]]
    then 
        break
    fi

    done;
fi
gen_path="generator"
count=$(grep -E 'COUNT' ./.env| awk 'BEGIN { FS = "=" } ; {print $2}')

if [[ "$num" == "" ]]
then
    PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -v count=$count -f "$gen_path/$last_version.sql"
else
    array=$(ls $gen_path | sort )
    for file in "$array"
    do 
    PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name -v count=$count -f "$gen_path/$file"
    if [[ "$file" == "$num.sql" ]]
    then 
        break
    fi

    done;
fi
