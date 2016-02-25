Docker Notes
============

install docker
______________

YUM based
+++++++++

sudo rpm --import "https://pgp.mit.edu/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://packages.docker.com/1.10/yum/repo/main/centos/7
sudo yum install docker-engine

APT based
+++++++++

wget -qO- 'https://pgp.mit.edu/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | sudo apt-key add --import
sudo apt-get update && sudo apt-get install apt-transport-https
sudo apt-get install -y linux-image-extra-virtual
echo "deb https://packages.docker.com/1.10/apt/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update && sudo apt-get install docker-engine

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

