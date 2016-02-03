Docker Notes
============

Set IP address
______________

Since 1.10,
docker network create -d bridge --subnet 172.25.0.0/16 mynet
docker run -itd --net=mynet --ip=172.25.3.3 alpine sh

Get salt-master IP
__________________

sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${CONTAINER_ID_}

Attach salt-master
__________________

sudo docker exec -it ${CONTAINER_ID_} bash

