## Execute using 
## curl -s https://raw.githubusercontent.com/learnbyseven/KUBERNETES-TRAINING/master/add_node_k8.sh | bash 

#!/bin/bash
echo "Kubernetes vanilla installation begins using KubeADM"
apt-get clean
rm /var/lib/dpkg/lock    
rm /var/cache/apt/archives/lock
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
sleep 1
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
sleep 2
apt-get update -y 
sleep 1
export DEBIAN_FRONTEND=noninteractive
apt-get install -y libpq-dev apt-transport-https curl docker.io
sleep 1
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
sleep 1 
systemctl daemon-reload
systemctl restart docker
systemctl enable docker
sleep 1 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sleep 1 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sleep 1 
apt-get update
##Workaround to disable swap on Linux host 
#sed -i -e '2s/^/#/' /etc/fstab
echo "KUBERNETES DEFAULT PACKAGE INSTALLATION BEGINS"
apt-get install -y kubelet kubeadm kubectl
swapoff -a


## After running add_node_k8.sh on worker node 
## Copy  /kub.txt located at master node.
## Paste the contents on worker node and enter 
## Post sucessful execution; Check cluster status on master node command $kubectl get nodes
## finisH

## Thanks to my good friend Giri: https://github.com/learnbyseven
