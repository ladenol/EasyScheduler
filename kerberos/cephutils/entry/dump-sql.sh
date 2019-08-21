#!/bin/bash

if [ ! -d /opt/mntcephutils/sql/ ]; then
    exit
fi

shopt -s  expand_aliases

DATABASE=escheduler
alias m='mysql -u${BD_MYSQL_USERNAME} -p${BD_MYSQL_PASSWD} -h${BD_MYSQL_SERVER}'

r=`m -N -e "show databases like '${DATABASE}'" | wc -l`

if [ $r -eq 1 ]; then 
    exit
fi

for file in `ls -1 --color=never /opt/mntcephutils/sql/*.sql`
do
    m < $file
done
