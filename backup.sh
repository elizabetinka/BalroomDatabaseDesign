#!/bin/bash  
db_name=$(grep -E 'DB_NAME' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(grep -E 'DB_PASSWORD' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(echo $db_password | awk '{print $NF}')
db_user=$(grep -E 'DB_USER' ./.env| awk 'BEGIN { FS = "=" } ; {print $2}')
n=$(grep -E 'backup_n' ./.env2| awk 'BEGIN { FS = "=" } ; {print $2}')
m=$(grep -E 'backup_m' ./.env2| awk 'BEGIN { FS = "=" } ; {print $2}')
gen_path="backup"

while [[ true ]]
do
rm $gen_path/*.dump

idx=1
while  [[ -f "$gen_path/$idx.dump" ]]
do
let "idx=$idx+1"
done



for (( i=1; i <= "$m"; i++ ))
do
    PGPASSWORD="$db_password" pg_dump -U $db_user  -h localhost -p 5000  $db_name > "$gen_path/$idx.dump"
    let "idx=$idx+1"
done
let "sec=$n * 3600"
sleep $sec
done


