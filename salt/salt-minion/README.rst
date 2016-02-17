Salt-minion
===========

Build
_____

sudo docker build -t zhangzhenhua/salt-minion:latest .

Push
____

sudo docker push zhangzhenhua/salt-minion

Pull
____

sudo docker pull zhangzhenhua/salt-minion

Run
___

sudo docker rm salt-minion
sudo docker run -d --name=salt-minion --net eon-iaas-br0 --ip 192.188.0.101 zhangzhenhua/salt-minion
