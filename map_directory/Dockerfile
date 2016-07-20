# EonCloud IAAS

FROM debian:jessie
MAINTAINER Zhang Zhenhua <zhangzhenhua@eoncloud.com.cn>

RUN apt-get update && apt-get install -y vim supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD timerprint.sh /root/timerprint.sh

CMD "/usr/bin/supervisord"
