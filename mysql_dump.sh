#!/usr/bin/bash
#@author shiwei.du
#@email  dusw0214@126.com
#@desc   Exports all databases that begin with the specified
#@created Thu Mar 10 18:34:50 CST 2016

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
		host=$hosts
	fi
	echo -e -n ${color_list[1]}
	read -p "请输入导出数据库的前缀:" prefix
	echo -e -n "\e[0m"
	if [ -z $prefix ];   then 
		echo 
		echo -e ${color_list[0]}"请输入导出数据库的前缀\e[0m";
		break
	fi
	if [ $prefix == '' ];then
		echo
		echo -e ${color_list[0]}"请输入导出数据库的前缀\e[0m";
		break
	fi

	echo -e -n ${color_list[1]}
	read -p "请输入连接数据库的端口号(默认:$port):" posts
	echo -e -n "\e[0m"
	if [ ! -z $posts ];   then 
		port=$posts
	fi

	echo -e -n ${color_list[1]}
	read -p "请输入备份数据库的路径(默认:$backdir,记得添加最后的斜线):" backdirs
	echo -e -n "\e[0m"
	if [ ! -z $backdirs ];   then 
		backdir=$backdirs
	fi
	dblists=`mysql -u$user -p$passwd -h$host -e "show databases;" | grep ^$prefix`
	for db in $dblists
		do 
		mysqldump -u$user -p$passwd -h$host  $db | gzip > $backdir$db-$backname.sql.gz
		if [[ $? == 0 ]]; then
			echo -e "${color_list[1]}备份【$db】数据成功！！\e[0m";
		else
			echo -e "${color_list[0]}备份【$db】数据失败！！\e[0m"; 
		fi
	done
	exit
done
