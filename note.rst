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
sudo docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ${CONTAINER}

Attach salt-master
__________________

sudo docker exec -it ${CONTAINER_ID_} bash

Get MAC Address
_______________

sudo docker inspect --format='{{range .NetworkSettings.Networks}}{{.MacAddress}}{{end}}' $INSTANCE_ID

Get log path
____________
sudo docker inspect --format='{{.LogPath}}' $INSTANCE_ID

List all port bindings
______________________

sudo docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' $INSTANCE_ID

