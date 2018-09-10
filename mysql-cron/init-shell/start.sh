#!/bin/bash

#此脚本由mysql用户执行,故需要加sudo避免权限不够,同时,新建文件一般放在/var/lib/mysql目录下,否则同样权限不够

#修改文件夹权限,否则无法在该目录下创建文件
sudo chmod 777 /etc/default
#将docker的环境变量输出到locale,使得cron定期运行的脚本可以使用这些环境变量,否则执行备份脚本时可能提示密码为空
env >> /etc/default/locale

#启动cron并将其启动结果写入文件
# 这里需要使用sudo,否则会提示cron: can't open or create /var/run/crond.pid: Permission denied
# 这个问题无法通过修改/var/run/crond或/run文件夹权限解决
# 需要注意的是,使用sudo后cron是在root用户下运行的,root用户下使用`service cron status`会出现` [ ok ] cron is running. `
# 而mysql执行`service cron status`则会出现` [FAIL] cron is not running ... failed! `
# 虽然如此,mysql用户身份制定的定时任务还是会执行的
sudo /usr/sbin/service cron start &>> /var/lib/mysql/cron-start.log

#以/cron-shell/crontab.bak作为crontab的任务列表文件并载入
# 注意,该文件必须为unix格式,且结尾必须换行,否则会报错
crontab /cron-shell/crontab.bak
