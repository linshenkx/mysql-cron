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
        - 默认功能:将所有数据库导出并按日期命名,压缩,同时删除7天前的备份数据,备份数据在`/opt/mysql/backup`目录下
        - 注意事项:
            1. 任务脚本可以有多个,命名随意,自由实现
            2. 定时任务是以mysql用户执行的,所以注意用sudo指令提权(不需要密码)
            3. 有误：`/var/lib/mysql`属于mysql用户,不需要额外授予文件操作权限,故建议将新生成文件放到该目录下
            4. 备份数据不应该和mysql本身数据在同一目录，之前有误，现改为/opt/mysql/backup目录
            5. 由于默认命名规则是按日期的，所以同一天的备份会被覆盖，如果有需要建议自行修改命名规则
2. 数据库初始化脚本(.sql或.sql.gz)和容器启动后运行脚本(.sh)放到/docker-entrypoint-initdb.d目录下
有误，现不使用/docker-entrypoint-initdb.d脚本添加cron任务
    - 注意事项:不能整个文件夹映射,否则原start.sh启动文件会丢失,应使用单文件映射或COPY(ADD)将文件添加进容器

#### 使用建议
将生成文件放到`/var/lib/mysql`下,并将`/var/lib/mysql`目录映射到宿主机
#### 使用范例
1. 第一次启动/使用数据库存储目录
应用场景：一般场景，无初始sql
- /var/lib/mysql 是数据库存储目录
- /opt/mysql/backup 是cron备份存储目录
```shell
docker run \
--name lin-mysql  \
-p 13306:3306   \
--restart=always   \
-v /opt/mysql/datadir:/var/lib/mysql  \
-v /opt/mysql/backup:/opt/mysql/backup  \
-e MYSQL_ROOT_PASSWORD=123456  \
-d linshen/mysql-cron  \
--character-set-server=utf8mb4  \
--collation-server=utf8mb4_unicode_ci

```
2. 使用sql初始化启动（数据库存储目录必须为空）
应用场景：需要通过sql备份脚本完成数据库初始化时，如使用最新的备份文件进行数据库迁移/恢复
```shell
docker run   \
--name lin-mysql   \
-p 13306:3306    \
--restart=always   \
-v /opt/mysql/datadir:/var/lib/mysql  \
-v /opt/mysql/backup:/opt/mysql/backup  \
-v /opt/mysql/init-sql/data_20180909.sql.gz:/docker-entrypoint-initdb.d/init.sql.gz    \
-e MYSQL_ROOT_PASSWORD=mypasswd   \
-d linshen/mysql-cron   \
--character-set-server=utf8mb4   \
--collation-server=utf8mb4_unicode_ci 

```
3. 提供自定义crontab和备份脚本
自己根据需要提供backup.sh和crontab.bak，参考默认写法

```shell
docker run   \
--name lin-mysql   \
-p 13306:3306    \
--restart=always   \
-v /opt/mysql/datadir:/var/lib/mysql  \
-v /opt/mysql/backup:/opt/mysql/backup  \
-v /opt/mysql/cron-shell/backup.sh:/cron-shell/backup.sh  \
-v /opt/mysql/cron-shell/crontab.bak:/cron-shell/crontab.bak  \
-e MYSQL_ROOT_PASSWORD=mypasswd   \
-d linshen/mysql-cron   \
--character-set-server=utf8mb4   \
--collation-server=utf8mb4_unicode_ci

```

#### 相关
- CSDN文章:[Dockerfile实现MySQL定时备份](https://blog.csdn.net/alinyua/article/details/82532988)
- github项目:https://github.com/linshenkx/mysql-cron
- dockerhub地址:https://hub.docker.com/r/linshen/mysql-cron/


