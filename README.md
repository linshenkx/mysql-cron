# mysql-cron
预安装cron服务的mysql镜像(基于官方5.7),提供任务表和所要运行的脚本即可使用(可快速实现数据库定时备份)


#### 使用说明:
1. 将cron任务表(crontab.bak)和执行脚本(如backup.sh)放到容器目录/cron-shell下
    1. crontab.bak
        - 默认内容: */1 * * * * /cron-shell/backup.sh
        - 默认功能: 每分钟运行一次/cron-shell/backup.sh
        - 注意事项: 
            1. 任务表文件只能有一个,且文件名必须为crontab.bak
            2. 该任务列表属mysql用户,root用户下可通过`gosu mysql crontab -l`查看
    2. backup.sh
        - 默认功能:将所有数据库导出并按日期命名,压缩,同时删除7天前的备份数据,备份数据在`/var/lib/mysql/backup`目录下
        - 注意事项:
            1. 任务脚本可以有多个,命名随意,自由实现
            2. 定时任务是以mysql用户执行的,所以注意用sudo指令提权(不需要密码)
            3. `/var/lib/mysql`属于mysql用户,不需要额外授予文件操作权限,故建议将新生成文件放到该目录下
2. 数据库初始化脚本(.sql或.sql.gz)和容器启动后运行脚本(.sh)放到/docker-entrypoint-initdb.d目录下
    - 注意事项:不能整个文件夹映射,否则原start.sh启动文件会丢失,应使用单文件映射或COPY(ADD)将文件添加进容器

#### 使用建议
将生成文件放到`/var/lib/mysql`下,并将`/var/lib/mysql`目录映射到宿主机
#### 使用范例
- docker run 形式
```docker
docker run --name lin-mysql -p 3306:3306  --restart=always -v /my/own/cron-shell:/cron-shell -v /my/own/init-sql/data_20180909.sql.gz:/docker-entrypoint-initdb.d/init.sql.gz  -v /my/own/datadir:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=mypasswd -d linshen/mysql-cron --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
```
- docker-compose 形式
参考[docker-compose文件夹](https://github.com/linshenkx/mysql-cron/tree/master/docker-compose)

CSDN文章:
[Dockerfile实现MySQL定时备份](https://blog.csdn.net/alinyua/article/details/82532988)



