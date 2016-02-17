Salt-master
===========

Create new network
__________________

create new network
+++++++++++++++++++
zhangzh@base[~/git/docker/mydockerhub/salt/salt-master]$sudo docker network create --driver=bridge --subnet=192.188.0.0/16 eon-iaas-br0
26ffefc2ac090991328429aeb3a6dcc7ad62bf7973446d6bb0ac47b0821f348f

assign specified IP when launching container
++++++++++++++++++++++++++++++++++++++++++++
zhangzh@base[~/git/docker/mydockerhub/salt/salt-master]$sudo docker run -d --name salt-master --net eon-iaas-br0 --ip 192.188.0.100 zhangzhenhua/salt-master
70161de946826849257f8b4a6763946ded35a52f2791dc0ae5a775596b5d4068

retrive back container's IP
+++++++++++++++++++++++++++
zhangzh@base[~/git/docker/mydockerhub/salt/salt-master]$sudo docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' salt-master
192.188.0.100

Build
_____

sudo docker build -t zhangzhenhua/salt-master:latest .

Push
____

sudo docker push zhangzhenhua/salt-master

Pull
____

sudo docker pull zhangzhenhua/salt-master

Run
___

sudo docker rm salt-master
sudo docker run -d --name=salt-master zhangzhenhua/salt-master
