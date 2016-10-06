#!/bin/bash
#!/usr/bin/bash
#@author shiwei.du
#@email  dusw0214@126.com
#@desc   Monitor Mysql database performance scripts
#@created Saturday sep 2 18:34:50 CST 2016

all_n=("\e[0;31m" "\e[0;32m" "\e[0;33m" "\e[0;35m" "\e[0;36m" "\e[0;37m")
user="test"
passwd="123456"
hosts=("127.0.0.1" "127.0.0.1")
port=3306
len=${#hosts[@]}
num_n=${#all_n[*]}
while(true);do
echo -e -n ${all_n[$((RANDOM%num_n))]}
echo '----------|---------|--- MySQL Command Status --|----- Innodb row operation ----|-- Buffer Pool Read --|------------- Open -------------';
echo "---Time---|---QPS---|select insert update delete| read inserted updated deleted |-- logical  physical--| fopen fopened topen topened--|--threadsed threadsing--|";
for((i=0;i<$len;i++));do
mysql=`mysqladmin -u$user -p$passwd -h${hosts[$i]} -P$port ext |\
awk -F "|" \
"BEGIN{count=0;queries=0;com_select=0;com_insert=0;com_update=0;com_delete=0;innodb_rows_read=0;innodb_rows_deleted=0;innodb_rows_inserted=0;innodb_rows_updated=0;innodb_lor=0;innodb_phr=0
}"\
'{if($2 ~ /Variable_name/ && ++count){}
else if ($2 ~ /Queries/){queries=$3;}\
else if ($2 ~ /Com_select /){com_select=$3;}\
else if ($2 ~ /Com_insert /){com_insert=$3;}\
else if ($2 ~ /Com_update /){com_update=$3;}\
else if ($2 ~ /Com_delete /){com_delete=$3;}\
else if ($2 ~ /Innodb_rows_read/){innodb_rows_read=$3;}\
else if ($2 ~ /Innodb_rows_deleted/){innodb_rows_deleted=$3;}\
else if ($2 ~ /Innodb_rows_inserted/){innodb_rows_inserted=$3;}\
else if ($2 ~ /Innodb_rows_updated/){innodb_rows_updated=$3;}\
else if ($2 ~ /Innodb_buffer_pool_read_requests/){innodb_lor=$3;}\
else if ($2 ~ /Open_files/){fopening=$3;}\
else if ($2 ~ /Opened_files/){fopened=$3;}\
else if ($2 ~ /Open_tables/){topening=$3;}\
else if ($2 ~ /Opened_tables/){topened=$3;}\
else if ($2 ~ /Threads_connected/){threadsed=$3;}\
else if ($2 ~ /Threads_running/){threadsing=$3;}\
else if ($2 ~ /Uptime / && count == 1){\
	printf("|%s | %9d |%6d %6d %6d %6d ",strftime("%H:%M:%S"),queries,com_select,com_insert,com_update,com_delete);\
    printf("| %6d %8d %7d %7d |%7d 	%20d ",innodb_rows_read,innodb_rows_inserted,innodb_rows_updated,innodb_rows_deleted,innodb_lor,innodb_phr);\
    printf("| %7d %8d %8d %8d |%7d 	%20d ",fopening,fopened,topening,topened,threadsed,threadsing);\
}}\'`

echo $mysql
done
printf '|-------------------------------------------------------------------------------------------------------\e[0m\n'
sleep 1s
done
