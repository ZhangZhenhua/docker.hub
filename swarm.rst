
cluster
_______

swarm manager : rgw1(primary manager and consul node), rgw2
swarm nodes  : ceph1, ceph2, ceph3

upgrade kernel
______________

apt-get install linux-signed-image-3.16.0-60-generic
reboot

start docker daemon
___________________

sudo docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock

setup consul(minimalist)
________________________

on rgw1:
docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap

start swarm primary manager
___________________________

on rgw1(IP: 172.31.0.19):
docker run -d -p 4000:4000 swarm manage -H :4000 --replication --advertise 172.31.0.19:4000  consul://172.31.0.19:8500

start swarm replica manager
___________________________
on rgw2(IP: 172.31.0.20):
docker run -d swarm manage -H :4000 --replication --advertise 172.31.0.20:4000  consul://172.31.0.19:8500

let swarm node join the cluster
_______________________________

on ceph1,ceph2,ceph3:
docker run -d swarm join --advertise=172.31.0.17:2375 consul://172.31.0.19:8500
docker run -d swarm join --advertise=172.31.0.16:2375 consul://172.31.0.19:8500
docker run -d swarm join --advertise=172.31.0.18:2375 consul://172.31.0.19:8500

cluster status
______________

on master node, rgw1:
docker -H :4000 info



 1159  2016-02-19-17:46:17: sudo docker -H :4000 info
 1161  2016-02-19-17:46:34: sudo docker -H 14.14.14.195:4000 info
 1162  2016-02-19-17:46:41: sudo docker -H 14.14.14.195:4000 ps
 1163  2016-02-19-17:46:44: sudo docker -H 14.14.14.195:4000 ps -n 4
 1164  2016-02-19-17:47:34: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1165  2016-02-19-17:47:39: sudo docker -H 14.14.14.195:4000 ps -n 4
 1166  2016-02-19-17:47:43: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1167  2016-02-19-17:47:45: sudo docker -H 14.14.14.195:4000 ps -n 4
 1168  2016-02-19-17:47:52: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1169  2016-02-19-17:47:53: sudo docker -H 14.14.14.195:4000 ps -n 4
 1170  2016-02-19-17:47:59: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1171  2016-02-19-17:48:04: sudo docker -H 14.14.14.195:4000 ps -n 4
 1172  2016-02-19-17:48:10: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1173  2016-02-19-17:48:12: sudo docker -H 14.14.14.195:4000 ps -n 4
 1174  2016-02-19-17:48:15: sudo docker -H 14.14.14.195:4000 ps -n 5
 1175  2016-02-19-17:49:12: sudo docker -H 14.14.14.195:4000 run ubuntu echo hello
 1176  2016-02-19-17:49:39: sudo docker -H 14.14.14.195:4000 run ubuntu echo again
 1177  2016-02-19-17:49:51: sudo docker -H 14.14.14.195:4000 ps -n 4
 1178  2016-02-19-17:49:59: sudo docker -H 14.14.14.195:4000 run ubuntu echo agai


on ceph1 to start docker daemon with specified label:
 docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --label node=`hostname` &
 docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock --label node=ceph1 --cluster-store=consul://172.31.0.19:8500 --cluster-advertise=172.31.0.19:2376 &
