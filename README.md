# mysql-cron
预安装cron服务的mysql镜像(基于官方5.7),提供任务表和所要运行的脚本即可使用(可快速实现数据库定时备份)


####使用说明:
- 将要定时运行的脚本文件(如backup.sh)和cron任务表(文件名必须为crontab.bak)放到容器目录/cron-shell下
- 数据库初始化脚本(.sql或.sql.gz)和容器启动后运行脚本(.sh)放到/docker-entrypoint-initdb.d目录下

####默认实现:
每分钟执行一次任务:将所有数据库导出并按日期命名,压缩,同时删除7天前的备份数据
备份数据在`/var/lib/mysql/backup`目录下


####使用范例
```docker
docker run --name lin-mysql -p 3306:3306  --restart=always -v /my/own/cron-shell:/cron-shell -v /my/own/init-sql/:/docker-entrypoint-initdb.d  -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypasswd -d linshen/mysql-cron --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

```

####注意事项:
1. 注意脚本文件和crontab.bak格式要为Unix,在windows下新建文件为dos格式,要先进行转换
2. crontab.bak结尾要换行
3. 定时任务是以mysql用户执行的,所以注意用sudo指令提权(不需要密码)
4. `/var/lib/mysql`属于mysql用户,不需要授予文件权限,故建议将新生成文件放到该目录下
5. 建议将`/var/lib/mysql`目录映射到宿主机

