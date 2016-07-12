INSTALL
=======

Install kubernetes on 4 nodes, ubuntu 14.04, root

::

    172.31.0.19 rgw1    master
    172.31.0.17 ceph1   minion
    172.31.0.16 ceph2   minion
    172.31.0.18 ceph3   minion

Prerequirements
_______________

1. docker is installed on every nodes, and docker daemon is running

Install
_______

get source
++++++++++

::

    git clone https://github.com/GoogleCloudPlatform/kubernetes.git
    cd kubernetes/
    git checkout v1.1.8 -b v1.1.8　# latest stable release

build
+++++

::

    cd cluster/ubuntu
    ./build.sh  # download etcd, flannel...
    ls binaries/*

    export nodes="root@172.31.0.19 root@172.31.0.17 root@172.31.0.16 root@172.31.0.18"
    export roles="a i i i"
    export NUM_MINIONS=${NUM_MINIONS:-4}
    export SERVICE_CLUSTER_IP_RANGE=11.1.1.0/24
    export FLANNEL_NET=172.16.0.0/16

    cd ..
    KUBERNETES_PROVIDER=ubuntu ./kube-up.sh

    cp binaries/kubectl /usr/local/bin/

THIS SECTION MIGHT NOT BE NECESSARY
+++++++++++++++++++++++++++++++++++

::

    kubectl config set preferences.colors true
    kubectl config set-credentials myself --username=admin --password=secret
    kubectl config set-cluster kubernetes --server=http://localhost:8080 --insecure-skip-tls-verify=true
    kubectl config set-context default-context --cluster=kubernetes --user=myself
    kubectl config use-context default-context
    kubectl config set contexts.default-context.namespace default
    kubectl config view
    cat ~/.kube/config


check service status, start if necessary
++++++++++++++++++++++++++++++++++++++++

::

    service kube-apiserver status
    service kube-controller-manager status
    service kube-scheduler status

verification
++++++++++++

::

    root@rgw1:~# kubectl version
    Client Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.3", GitCommit:"61c6ac5f350253a4dc002aee97b7db7ff01ee4ca", GitTreeState:"clean"}
    Server Version: version.Info{Major:"1", Minor:"0", GitVersion:"v1.0.3", GitCommit:"61c6ac5f350253a4dc002aee97b7db7ff01ee4ca", GitTreeState:"clean"}
    root@rgw1:~# kubectl get nodes
    NAME          LABELS                               STATUS
    172.31.0.16   kubernetes.io/hostname=172.31.0.16   Ready
    172.31.0.17   kubernetes.io/hostname=172.31.0.17   Ready
    172.31.0.18   kubernetes.io/hostname=172.31.0.18   Ready


tear down cluster
+++++++++++++++++

KUBE_MASTER=172.31.0.19 KUBE_MASTER_IP=172.31.0.19 KUBECTL_PATH=/usr/local/bin/kubectl KUBERNETES_PROVIDER=ubuntu ./kube-down.sh

ISSUES
______

1. script bug
+++++++++++++

::

    root@rgw1:~/kubernetes/cluster# KUBERNETES_PROVIDER=ubuntu ./kube-up.sh
    ... Starting cluster using provider: ubuntu
    ... calling verify-prereqs
    Identity added: /root/.ssh/id_rsa (/root/.ssh/id_rsa)
    ... calling kube-up
    root@172.31.0.19 root@172.31.0.17 root@172.31.0.16 root@172.31.0.18
    ./../cluster/../cluster/ubuntu/util.sh: line 48: roles[${ii}]: unbound variable

::

    root@rgw1:~/kubernetes# git diff
    diff --git a/cluster/ubuntu/config-default.sh b/cluster/ubuntu/config-default.sh
    index 2614001..8097c5b 100755
    --- a/cluster/ubuntu/config-default.sh
    +++ b/cluster/ubuntu/config-default.sh
    @@ -21,7 +21,7 @@
     export nodes=${nodes:-"vcap@10.10.103.250 vcap@10.10.103.162 vcap@10.10.103.223"}
      
      # Define all your nodes role: a(master) or i(minion) or ai(both master and minion), must be the order same 
      -role=${role:-"ai i i"}
      +role=${roles:-"ai i i"}
       # If it practically impossible to set an array as an environment variable
        # from a script, so assume variable is a string then convert it to an array
         export roles=($role)
         root@rgw1:~/kubernetes#

See my PR for this issue:
https://github.com/kubernetes/kubernetes/pull/22249



2. connect refused 
++++++++++++++++++

::

    root@rgw1:~/kubernetes/cluster/ubuntu/binaries# ./kubectl get nodes
    error: couldn't read version from server: Get http://localhost:8080/api: dial tcp 127.0.0.1:8080: connection refused

::

    Steps:
    netstat -ntpl --> not finding port 8080
    service kube-apiserver start --> process runs few seconds then fail
    dmesg shows: init: kube-apiserver main process (24042) terminated with status 255
    /var/log/upstart/kube-apiserver.log shows: plugins.go:106] Unknown admission plugin: DenyEscalatingExec
    remove DenyEscalatingExec in section --admission-control from /etc/default/kube-apiserver.
    start kube-apiserver again

3. can't ping gcr.io
++++++++++++++++++++

Well, GFW, you know.

::

    root@ceph1:~# docker pull docker.io/kubernetes/pause
    Using default tag: latest
    latest: Pulling from kubernetes/pause
    a3ed95caeb02: Pull complete
    f72a00a23f01: Pull complete
    Digest: sha256:2088df8eb02f10aae012e6d4bc212cabb0ada93cb05f09e504af0c9811e0ca14
    Status: Downloaded newer image for kubernetes/pause:latest
    root@ceph1:~# docker tag docker.io/kubernetes/pause gcr.io/google_containers/pause:0.8.0
    root@ceph1:~# docker images

::

    start the kubelet like below will solve the issue that when you cannot connect to google, but can connect to docker.io:
    kubelet --pod-infra-container-image="docker.io/kubernetes/pause"

::

    https://github.com/kubernetes/kubernetes/issues/6888
    https://github.com/kubernetes/kubernetes/issues/7332

4. Enable https for API server
++++++++++++++++++++++++++++++

Our testing evn is built on top of openstack VMs, which have internal and external
networks. The cluster communicate via internal IP and client access API server via
external IP. This cause certification failure issue because the cert file doesn't contain
the external IP. Hacked below patch (in cluster/ubuntu/util.sh) to workaround this issue.

::
    
    @@ -447,6 +449,7 @@ function provision-master() {
   EXTRA_SANS=(
     IP:$MASTER_IP
     IP:${SERVICE_CLUSTER_IP_RANGE%.*}.1
+    IP:14.14.14.195
     DNS:kubernetes
     DNS:kubernetes.default
     DNS:kubernetes.default.svc
@@ -619,6 +622,7 @@ function provision-masterandnode() {
   EXTRA_SANS=(
     IP:${MASTER_IP}
     IP:${SERVICE_CLUSTER_IP_RANGE%.*}.1
+    IP:14.14.14.195
     DNS:kubernetes
     DNS:kubernetes.default
     DNS:kubernetes.default.svc




./boom -m PUT -d value="bar" -n 1000 -c 1 http://14.14.14.114:4001/v2/keys/bench
