#!/bin/bash  
db_name=$(grep -E 'DB_NAME' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(grep -E 'DB_PASSWORD' ./.env | awk 'BEGIN { FS = "=" } ; {print $2}')
db_password=$(echo $db_password | awk '{print $NF}')
db_user=$(grep -E 'DB_USER' ./.env| awk 'BEGIN { FS = "=" } ; {print $2}')
n=$(grep -E 'req_n' ./.env2| awk 'BEGIN { FS = "=" } ; {print $2}')
echo "n: $n"
gen_path="request"
dance=$(grep -E 'DANCE' ./.env2 | awk 'BEGIN { FS = "=" } ; {print $2}')


PGPASSWORD="$db_password" psql -h localhost -p 5000 -U $db_user -d $db_name  -v dance="$dance" -f "drop_idx.sql" 
PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "drop_part.sql" 

file_num=1
while [[ -f "results/$file_num" ]]
do
    let "file_num=$file_num+1"
done

echo "Без индексов " > "results/$file_num"

min_array=( )
avg_array=( )
max_array=( ) 
for file in `find $gen_path -type f -name "*.sql"` 
do
    min=10000000000000000
    max=0
    sum=0
    for (( i=1; i <= n; i++))
    do
    > "tmp.txt"
    PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "$file" -o  "tmp.txt"
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
    min_array[${#min_array[*]}]=$min
    avg_array[${#avg_array[*]}]=$avg
    max_array[${#max_array[*]}]=$max
done

PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "migrations/0.0.1.sql" 

echo "С индексами " >> "results/$file_num"

min_array_2=()
avg_array_2=()
max_array_2=()
for file in `find $gen_path -type f -name "*.sql"` 
do
    min=10000000000000000
    max=0
    sum=0
    for (( i=1; i <= "$n"; i++ ))
    do
    > "tmp.txt"
    PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "$file" -o  "tmp.txt"
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
    min_array_2[${#min_array_2[*]}]=$min
    avg_array_2[${#avg_array_2[*]}]=$avg
    max_array_2[${#max_array_2[*]}]=$max
done


PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "migrations/0.0.2.sql" 


echo "С партициями " >> "results/$file_num"

min_array_3=()
avg_array_3=()
max_array_3=()
for file in `find $gen_path -type f -name "*.sql"` 
do
    min=10000000000000000
    max=0
    sum=0
    for (( i=1; i <= "$n"; i++ ))
    do
    > "tmp.txt"
    PGPASSWORD="$db_password" psql -h localhost -p 5000  -U $db_user -d $db_name  -v dance="$dance" -f "$file" -o  "tmp.txt"
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
    min_array_3[${#min_array_3[*]}]=$min
    avg_array_3[${#avg_array_3[*]}]=$avg
    max_array_3[${#max_array_3[*]}]=$max
done




echo "----------------------------- " >> "results/$file_num"

echo "В итоге : " >> "results/$file_num"
echo $'\t\t\t  Best time \t\t Avg time \t\t Worst time '  >> "results/$file_num"
i=0
for file in `find $gen_path -type f -name "*.sql"` 
do
echo "$file" >> "results/$file_num"
echo -e $"Без опт:  \t\t ${min_array[$i]} \t\t  ${avg_array[$i]} \t\t  ${max_array[$i]}"  >> "results/$file_num"
echo -e "С индексами:  \t\t  ${min_array_2[$i]} \t\t  ${avg_array_2[$i]} \t\t  ${max_array_2[$i]}"  >> "results/$file_num"
min_proc="$(awk -v v1=${min_array_2[$i]} -v v2=${min_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
avg_proc="$(awk -v v1=${avg_array_2[$i]} -v v2=${avg_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
max_proc="$(awk -v v1=${max_array_2[$i]} -v v2=${max_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
echo -e $"Улучшения 2 отн 1: \t  $min_proc % \t\t  $avg_proc % \t\t  $max_proc %"  >> "results/$file_num"
echo -e $"С партициями: \t\t  ${min_array_3[$i]} \t\t  ${avg_array_3[$i]} \t\t  ${max_array_3[$i]}"  >> "results/$file_num"
min_proc="$(awk -v v1=${min_array_3[$i]} -v v2=${min_array_2[$i]} "BEGIN {print 100 - v1/v2*100}")"
avg_proc="$(awk -v v1=${avg_array_3[$i]} -v v2=${avg_array_2[$i]} "BEGIN {print 100 - v1/v2*100}")"
max_proc="$(awk -v v1=${max_array_3[$i]} -v v2=${max_array_2[$i]} "BEGIN {print 100 - v1/v2*100}")"
echo -e $"Улучшения 3 отн 2: \t  $min_proc % \t\t  $avg_proc % \t\t  $max_proc %" >> "results/$file_num"
min_proc="$(awk -v v1=${min_array_3[$i]} -v v2=${min_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
avg_proc="$(awk -v v1=${avg_array_3[$i]} -v v2=${avg_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
max_proc="$(awk -v v1=${max_array_3[$i]} -v v2=${max_array[$i]} "BEGIN {print 100 - v1/v2*100}")"
echo -e $"Улучшения 3 отн 1: \t  $min_proc % \t\t  $avg_proc % \t\t  $max_proc %"  >> "results/$file_num"
echo "----------------------------- " >> "results/$file_num"
let "i=$i+1"
done
