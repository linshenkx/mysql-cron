#!/bin/bash
#作为crontab运行的脚本,需特别注意环境变量问题,指令写成绝对路径

#读取环境变量
. /etc/profile
#如果目录不存在则新建
DIR=/var/lib/mysql/backup
if [ ! -e $DIR ]
then
/bin/mkdir -p $DIR
fi
#将所有数据库导出并按日期命名保存成sql文件并压缩
/usr/bin/mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"   | gzip > "$DIR/data_`date +%Y%m%d`.sql.gz"
#查找更改时间在7日以前的sql备份文件并删除
/usr/bin/find $DIR -mtime +7 -name 'data_[1-9]*.sql.gz' -exec rm -rf {} \;
