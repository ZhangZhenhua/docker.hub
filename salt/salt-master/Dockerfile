# EonCloud IAAS
# Salt Stack Salt Master Container

FROM ubuntu:14.04
MAINTAINER Zhang Zhenhua <zhangzhenhua@eoncloud.com.cn>

# Update System
RUN rm -f /etc/apt/sources.list
ADD sources.list /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y

# Add PPA
RUN apt-get install -y software-properties-common dmidecode
RUN add-apt-repository -y ppa:saltstack/salt
RUN apt-get update

# Install Salt
RUN apt-get install -y salt-master

# Volumes
VOLUME ['/etc/salt/pki', '/var/cache/salt', '/var/logs/salt', '/etc/salt/master.d', '/srv/salt']

# Ports
EXPOSE 4505 4506

# Run Command
ADD start-salt-master.sh /usr/local/bin/start-salt-master.sh
RUN chmod a+x /usr/local/bin/start-salt-master.sh
CMD "/usr/local/bin/start-salt-master.sh"
