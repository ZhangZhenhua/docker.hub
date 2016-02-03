Salt-master
===========

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
