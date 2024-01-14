echo " Install curl, helm and kubectl."

snap install curl 
snap install helm --classic
snap install kubectl --classic
sleep 2

echo "Running the installer..."
curl -sfL https://get.rke2.io | sh -

echo "Enabling RKE2 Server Service..."
systemctl enable rke2-server.service

echo "Starting the RKE2 Server Service..."
systemctl start rke2-server.service

mkdir -p $HOME/.kube
cp /etc/rancher/rke2/rke2.yaml $HOME/.kube/config
chmod 644 $HOME/.kube/config

echo "Wait while initializing rke2 cluster ..."
while [ `kubectl get deploy -n kube-system | grep 1/1 | wc -l` -ne 4 ]
do
  sleep 5
  kubectl get po -n kube-system
done

echo "The cluster is ready now ---->"
kubectl get nodes