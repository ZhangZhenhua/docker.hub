#!/bin/bash

# install docker

# thanks to gfw
sudo docker pull index.tenxcloud.com/google_containers/kube-cross:v1.6.2-2
sudo docker tag index.tenxcloud.com/google_containers/kube-cross:v1.6.2-2 gcr.io/google_containers/kube-cross:v1.6.2-2

sudo docker pull index.tenxcloud.com/google_containers/debian-iptables-amd64:v3
sudo docker tag index.tenxcloud.com/google_containers/debian-iptables-amd64:v3 gcr.io/google_containers/debian-iptables-amd64:v3


# get code
#git clone https://github.com/kubernetes/kubernetes.git

# build from inside kubernetes source code
cd kubernetes; make quick-release

# output tarball
ls -lh _output/release-tars/kubernetes.tar.gz
