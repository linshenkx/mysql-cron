# mysql-cron
预安装cron服务的mysql镜像(基于官方5.7),提供任务表和所要运行的脚本即可使用(可快速实现数据库定时备份)


####使用说明:
将要定时运行的脚本文件(如backup.sh)和cron任务表(文件名必须为crontab.bak)放到容器目录/cron-shell下

####默认实现:
每分钟执行一次任务:将所有数据库导出并按日期命名,压缩,同时删除7天前的备份数据
备份数据在`/var/lib/mysql/backup`目录下

####注意事项:
1. 注意脚本文件和crontab.bak格式要为Unix,在windows下新建文件为dos格式,要先进行转换
2. crontab.bak结尾要换行
3. 定时任务是以mysql用户执行的,所以注意用sudo指令提权(不需要密码)
4. `/var/lib/mysql`属于mysql用户,不需要授予文件权限,故建议将新生成文件放到该目录下
5. 建议将`/var/lib/mysql`目录映射到宿主机

