#!/bin/bash  
db_name=$(grep -E 'DB_NAME' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(grep -E 'DB_PASSWORD' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(echo $db_password | awk '{print $NF}')
db_user=$(grep -E 'DB_USER' ./.env| awk 'BEGIN { FS = "=" } ; {print $2}')
n=$(grep -E 'n' ./.env2| awk 'BEGIN { FS = "=" } ; {print $2}')
gen_path="request"
dance=$(grep -E 'DANCE' ./.env2 | awk 'BEGIN { FS = "=" } ; {print $2}')


PGPASSWORD="$db_password" psql -h localhost -p 5432 -U $db_user -d $db_name  -v dance="$dance" -f "migrations/0.0.1.sql" 

file_num=1
while [[ -f "results/$file_num" ]]
do
    let "file_num=$file_num+1"
done

let "file_num=$file_num-1"

echo "C индексами " >> "results/$file_num"

for file in `find $gen_path -type f -name "*.sql"` 
do
    min=10000000000000000
    max=0
    sum=0
    for (( i=1; i <= "$n"; i++ ))
    do
    > "tmp.txt"
    PGPASSWORD="$db_password" psql -h localhost -p 5432 -U $db_user -d $db_name  -v dance="$dance" -f "$file" -o  "tmp.txt"
    execution=$(grep -E 'Execution Time' tmp.txt | tr ":" " " | awk '{print $3}' )
    sum="$(bc<<<"scale=5;$sum+$execution")"
    
    if (( $(echo "$min > $execution" |bc -l) )); 
    then
     min="$execution"
    fi

    if (( $(echo "$execution > $max" |bc -l) )); 
    then
      max="$execution"
    fi
  
    #planning=$(grep -E 'Planning Time' tmp.txt | tr ":" " " | awk '{print $3}' )
    #echo $planning
    done
    avg="$(awk -v v1=$sum -v v2=$n "BEGIN {print v1/v2}")"
    echo "file: $file    n: $n" >> "results/$file_num"
    echo "Лучшее время: $min"  >> "results/$file_num"
    echo "Среднее время: $avg"  >> "results/$file_num"
    echo "Худшее время: $max"  >> "results/$file_num"
    echo " " >> "results/$file_num"
done