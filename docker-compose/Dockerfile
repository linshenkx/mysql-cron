FROM linshen/mysql-cron

MAINTAINER LinShen

# 1. 将cron任务表(crontab.bak)和执行脚本(如backup.sh)放到容器目录/cron-shell下
COPY cron-shell/ /cron-shell/

# 2. 数据库初始化脚本(.sql或.sql.gz)和容器启动后运行脚本(.sh)放到/docker-entrypoint-initdb.d目录下
COPY init-sql/ /docker-entrypoint-initdb.d/

