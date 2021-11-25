FROM mysql:5.7

MAINTAINER LinShen

#修正时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
      && echo 'Asia/Shanghai' >/etc/timezone \
#更新源
      && apt-get update \
#安装cron
      && apt-get install -y  --no-install-recommends cron \
#安装dos2unix工具
      && apt-get install -y  dos2unix \
#安装sudo
      && apt-get install sudo \
#授予mysql组用户sudo免密码
      && echo '%mysql ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers \
#减小镜像的体积
      && rm -rf /var/lib/apt/lists/*  \
      && apt-get clean \
#赋予脚本可执行权限
      && chmod a+x -R /docker-entrypoint-initdb.d

#将任务脚本复制进容器,需要注意不能放到/var/lib/mysql目录下,该目录随mysql初始化会被清空造成原文件丢失
COPY cron-shell/ /cron-shell/

COPY start.sh /tmp/start.sh

ENTRYPOINT ["/tmp/start.sh"]
