#!/bin/bash
# install metrics-server
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/metrics-server/v1.8.x.yaml

# install helm
helm init
echo -n "Waiting for tiller pod to start"
while ! kubectl get pod -n kube-system | grep tiller | grep "Running" &>/dev/null; do
    echo -n "."
    sleep 5
done
echo "done!"
kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default

# install Traefik as ingress controller
helm install stable/traefik --namespace kube-system --name traefik -f values-traefik.yaml

# install monitoring components
kubectl create namespace monitoring
helm install stable/prometheus --namespace monitoring --name prometheus -f values-prometheus.yaml
helm install stable/grafana --namespace monitoring --name grafana -f values-grafana.yaml
