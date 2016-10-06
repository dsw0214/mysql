#!/usr/bin/bash
#@author shiwei.du
#@email  dusw0214@126.com
#@desc   Operate the database script
#@created Wed Oct 1 18:34:50 CST 2016

host='127.0.0.1'
port=3306
backdir='/home/'
backname=`date +%Y-%m-%d-%s`

color_list=("\e[0;31m" "\e[0;32m" "\e[0;33m")

while [[ true ]]; do
	echo -e -n ${color_list[1]}
	read -p "请输入连接数据库的账号:" user
	echo -e -n "\e[0m"
	if [ -z $user ];then
		echo -e ${color_list[0]}"请输入连接数据库的账号\e[0m";
		break
	fi
	if [ $user == '' ];then
		echo -e ${color_list[0]}"请输入连接数据库的账号\e[0m";
		break
	fi
	echo -e -n ${color_list[1]}
	read -p "请输入连接数据库的密码:" -s passwd
	echo -e "\e[0m"
	if [ -z $passwd ];then
		echo 
		echo -e ${color_list[0]}"请输入连接数据库的密码\e[0m";
		break
	fi
	if [ $passwd == '' ];then
		echo
		echo -e ${color_list[0]}"请输入连接数据库的密码\e[0m";
		break
	fi
	echo -e -n ${color_list[1]}
	read -p "请输入连接数据库的地址(默认:$host):" hosts
	echo -e -n "\e[0m"
	if [ ! -z $hosts ];   then 
		host = $hosts
	fi
	echo -e -n ${color_list[1]}
	read -p "请输入连接数据库的端口号(默认:$port):" posts
	echo -e -n "\e[0m"
	if [ ! -z $posts ];   then 
		port = $posts
	fi

	echo -e -n ${color_list[1]}
	read -p "请输入备份数据库的路径(默认:$backdir):" backdirs
	echo -e -n "\e[0m"
	if [ ! -z $backdirs ];   then 
		host = $backdirs
	fi

	mysql -u$user  -h$host -P$port -e "select version()" -p$passwd > /dev/null 2>&1
	if [[ $? == 0 ]];then
		comand_desc="
		    |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|\n
			|-------------------------------------------请选择以下操作 ---------------------------------------------|\n               
			|(1):备份指定数据库中的指定表的数据---------------------------------------------------------------------|\n
			|(2):备份指定数据库数据---------------------------------------------------------------------------------|\n
			|(3):清空指定数据库中指定表的数据-----------------------------------------------------------------------|\n
			|(4):导入指定数据库的数据-------------------------------------------------------------------------------|\n
			|(5):转移指定数据库对应的表的数据到指定的表中(insert)！！！[目前只支持目标表和导出表在同一个数据库中]---|\n
			|(6):转移指定数据库对应的表的数据到指定的表中(replace)！！！[目前只支持目标表和导出表在同一个数据库中]--|\n 
			|(7):创建指定的数据库-----------------------------------------------------------------------------------|\n
			|(8):在指定的数据库中克隆指定的数据表-------------------------------------------------------------------|\n
			|(9):退出-----------------------------------------------------------------------------------------------|\n
			|~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|\n"

		while true ; do
			echo -e -n ${color_list[2]}
			echo -e ${comand_desc}
			echo -e -n "\e[0m"
			echo -e -n ${color_list[1]}
			read -p "请输入你将要执行的编号:" num
			echo -e -n "\e[0m"
			case $num in
				1) 
					while true ;
						do
							echo -e -n ${color_list[1]}
							read -p "请输入你将要备份的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								while [[ true ]]; do
				                	read -p "请输入你将要备份表名称:" tablename
				                	if [[ $tablename != '' ]];then
				                		echo -e "${color_list[1]}你选择的数据名称是:["$dbname"]表名字是:["$tablename"]\e[0m"
				                		#mysqldump -u$user -p$passwd -h$host $dbname $tablename > $backdir$dbname-$tablename-$backname.sql
				                		mysqldump -u$user -p$passwd -h$host $dbname $tablename | gzip >  $backdir$dbname-$tablename-$backname.sql.gz
				                		if [[ $? == 0 ]]; then
				                			echo -e "${color_list[1]}备份数据成功！！\e[0m";
				                		else
				                			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
				                		fi
				                		break
				                	fi
								done
								break
							fi
					done
				;;
				2)
					while true ;
						do
							echo -e -n ${color_list[1]}
							read -p "请输入你将要备份的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								mysqldump -u$user -p$passwd -h$host $dbname > $backdir$dbname-$backname.sql
				        		if [[ $? == 0 ]]; then
				        			echo -e "${color_list[1]}备份数据成功！！\e[0m";
				        		else
				        			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
				        		fi
								exit 0
							fi
					done
				;;
				3)
					while true ;
						do
							echo -e ${color_list[0]} "程序会自动备份你清空的数据表!!!"
							read -p "请输入你将要清空的表对应的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								while [[ true ]]; do
									echo -e -n ${color_list[1]}
				                	read -p "请输入你将要清空表名称:" tablename
				                	echo -e -n "\e[0m"
				                	if [[ $tablename != '' ]];then
				                		echo -e "${color_list[1]}你选择的数据名称是:["$dbname"]表名字是:["$tablename"]\e[0m"
				                		#mysqldump -u$user -p$passwd -h$host $dbname $tablename > $backdir$dbname-$tablename-$backname.sql
				                		mysqldump -u$user -p$passwd -h$host $dbname $tablename | gzip >  $backdir$dbname-$tablename-$backname.sql.gz
				                		if [[ $? == 0 ]]; then
				                			echo -e "${color_list[1]}备份数据成功！！\e[0m";
				                			mysql -u$user -p$passwd -h$host $dbname -e "truncate table $tablename"
				                			if [[ $? == 0 ]];then
				                				echo -e "${color_list[1]}清空数据成功！！\e[0m";
				                			else
				                				echo -e "${color_list[0]}清空数据失败！！\e[0m";
				                			fi
				                		else
				                			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
				                		fi
				                		break
				                	fi
								done
								break
							fi
					done
				;;
				4)
					while true ;
						do
							echo -e ${color_list[1]} "程序会自动备份原来的数据表的数据!!!"
							read -p "请输入你将要操作的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								while [[ true ]]; do
									echo -e -n ${color_list[1]}
				                	read -p "请输入你导出的表名称:" tablename
				                	echo -e -n "\e[0m"
				                	if [[ $tablename != '' ]];then
				                		echo -e "${color_list[1]}你选择的数据名称是:["$dbname"]表名字是:["$tablename"]\e[0m"
				                		while [[ true ]]; do
				                			echo -e "${color_list[0]}请输入你将要导入的表名!!!\e[0m"
				                			echo -e "${color_list[0]}请确保你将要执行的sql文件路径正确!!!\e[0m"
				                			read sqldir
				                			if [[ $sqldir != '' ]];then
				                				if [[ ! -f "$sqldir" ]];then
				                					echo -e "${color_list[0]}你输入的Sql文件不存在";
				                				else
				                					#mysqldump -u$user -p$passwd -h$host $dbname $tablename > $backdir$dbname-$tablename-$backname.sql
				                					mysqldump -u$user -p$passwd -h$host $dbname $tablename | gzip >  $backdir$dbname-$tablename-$backname.sql.gz
							                		if [[ $? == 0 ]]; then
							                			echo -e "${color_list[1]}备份数据成功！！\e[0m";
							                			mysql -u$user -p$passwd -h$host $dbname  < $sqldir
							                			if [[ $? == 0 ]];then
						                					echo -e "${color_list[1]}往数据库[$dbname[表[$tablename]中数据导入成功！！\e[0m";
						                				else
						                					echo -e "${color_list[1]}往数据库[$dbname[表[$tablename]中数据导入失败！！\e[0m";
						                				fi
							                		else
							                			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
							                		fi
							                		break
				                				fi
				                			fi
				                		done
				                		break
				                	fi
								done
								break
							fi
					done
				;;
				5)
					while true ;
						do
							echo -e ${color_list[1]} "程序会自动备份原来的数据表的数据!!!"
							read -p "请输入你将要导入的表对应的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								while [[ true ]]; do
									echo -e -n ${color_list[1]}
				                	read -p "请输入将要导出的表名称:" tablename
				                	echo -e -n "\e[0m"
				                	if [[ $tablename != '' ]];then
				                		echo -e "${color_list[1]}你选择的数据名称是:["$dbname"]表名字是:["$tablename"]\e[0m"
				                		while [[ true ]]; do
				                			echo -e -n ${color_list[1]}
				                			read -p "请输入目标表的名称:" destable
				                			echo -e -n "\e[0m"
				                			if [[ $destable != '' ]];then
			                					#mysqldump -u$user -p$passwd -h$host $dbname $destable > $backdir$dbname-$destable-$backname.sql
			                				    mysqldump -u$user -p$passwd -h$host $dbname $destable | gzip >  $backdir$dbname-$destable-$backname.sql.gz
						                		if [[ $? == 0 ]]; then
						                			echo -e "${color_list[1]}目标表的数据备份成功！！\e[0m";
						                			mysql -u$user -p$passwd -h$host $dbname -e "insert into $destable select * from $tablename"
						                			if [[ $? == 0 ]];then
					                					echo -e "${color_list[1]}把数据库[$dbname]中表[$tablename]数据导入到[$destable]成功！！\e[0m";
					                				else
					                					echo -e "${color_list[1]}把数据库[$dbname]中表[$tablename]数据导入到[$destable]失败！！\e[0m";
					                				fi
						                		else
						                			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
						                		fi
						                		break
				                			fi
				                		done
				                		break
				                	fi
								done
								break
							fi
					done
				;;
				6)
					while true ;
						do
							echo -e ${color_list[1]} "程序会自动备份原来的数据表的数据!!!"
							read -p "请输入你将要导入的表对应的数据库名称:" dbname
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:["$dbname"]\e[0m"
								while [[ true ]]; do
									echo -e -n ${color_list[1]}
				                	read -p "请输入将要导出的表名称:" tablename
				                	echo -e -n "\e[0m"
				                	if [[ $tablename != '' ]];then
				                		echo -e "${color_list[1]}你选择的数据名称是:["$dbname"]表名字是:["$tablename"]\e[0m"
				                		while [[ true ]]; do
				                			echo -e -n ${color_list[1]}
				                			read -p "请输入目标表的名称:" destable
				                			echo -e -n "\e[0m"
				                			if [[ $destable != '' ]];then
			                					#mysqldump -u$user -p$passwd -h$host $dbname $destable > $backdir$dbname-$destable-$backname.sql
			                					mysqldump -u$user -p$passwd -h$host $dbname $destable | gzip >  $backdir$dbname-$destable-$backname.sql.gz
						                		if [[ $? == 0 ]]; then
						                			echo -e "${color_list[1]}目标表的数据备份成功！！\e[0m";
						                			mysql -u$user -p$passwd -h$host $dbname -e "replace into $destable select * from $tablename"
						                			if [[ $? == 0 ]];then
					                					echo -e "${color_list[1]}把数据库[$dbname]中表[$tablename]数据导入到[$destable]成功！！\e[0m";
					                				else
					                					echo -e "${color_list[1]}把数据库[$dbname]中表[$tablename]数据导入到[$destable]失败！！\e[0m";
					                				fi
						                		else
						                			echo -e "${color_list[0]}备份数据失败！！\e[0m"; 
						                		fi
						                		break
				                			fi
				                		done
				                		break
				                	fi
								done
								break
							fi
					done
				;;
				7)
					while true ;
						do
							echo -e -n ${color_list[1]}
							read -p "请输入你将要创建的表对应的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
	                			mysql -u$user -p$passwd -h$host -e "create database $dbname"
	                			if [[ $? == 0 ]];then
                					echo -e "${color_list[1]}创建数据库【$dbname】成功！！\e[0m";
                				else
                					echo -e "${color_list[1]}创建数据库【$dbname】失败！！\e[0m";
                				fi
                				break
                			fi
					done
				;;
				8)
					while true ;
						do
							echo -e -n ${color_list[1]}
							read -p "请输入你将要克隆表对应的数据库名称:" dbname
							echo -e -n "\e[0m"
							if [ $dbname != '' ]; then
								echo -e "${color_list[1]}你选择的数据库名称是:【"$dbname"】\e[0m"
	                			while [[ true ]]; do
		                			echo -e -n ${color_list[1]}
		                			read -p "请输入克隆的表的名称:" stable
		                			echo -e -n "\e[0m"
		                			if [[ $stable != '' ]];then
		                				echo -e "${color_list[1]}克隆的表的名称是:【"$stable"】\e[0m"
		                				while [[ true ]]; do
		                					echo -e -n ${color_list[1]}
		                					read -p "请输入被克隆的表的名称:" dtable
		                					echo -e -n "\e[0m"
		                					if [[ $dtable != '' ]];then
		                						mysql -u$user -p$passwd -h$host $dbname -e "create table $stable like $dtable"
						                		if [[ $? == 0 ]]; then
					                				echo -e "${color_list[1]}在数据库【$dbname】中克隆【$stable】表成功！！\e[0m";
						                		else
					                				echo -e "${color_list[1]}在数据库【$dbname】中克隆【$stable】表失败！！\e[0m";
						                		fi
						                		break
		                					fi
		                				done
				                		break
									fi
		                		done
                				break
							fi
					done
				;;
				9)
					echo -e ${color_list[1]} "你选择了退出操作\e[0m";
					exit 0
				;;
			esac
		done
	else
		echo "输入的账号信息有误,请重试！！！";
	fi
done
