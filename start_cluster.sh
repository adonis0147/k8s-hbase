#!/usr/bin/env bash

kubectl create configmap hdfs-conf --from-file=hdfs/conf --save-config --dry-run=client -o yaml |
	kubectl apply -f -
kubectl create configmap zk-conf --from-file=zookeeper/conf --save-config --dry-run=client -o yaml |
	kubectl apply -f -
kubectl create configmap hbase-conf --from-file=hbase/conf --save-config --dry-run=client -o yaml |
	kubectl apply -f -

kubectl apply -f hdfs/journalnode.yaml
kubectl rollout status --watch --timeout=600s statefulset/jn

kubectl apply -f hdfs/namenode.yaml
kubectl rollout status --watch --timeout=600s statefulset/nn

kubectl apply -f hdfs/datanode.yaml
kubectl rollout status --watch --timeout=600s statefulset/dn

sleep 30

while ! kubectl exec -it nn-0 -- hdfs haadmin -transitionToActive nn0; do
	sleep 10s
done

kubectl apply -f zookeeper/zookeeper.yaml
kubectl rollout status --watch --timeout=600s statefulset/zk

sleep 30

kubectl apply -f hbase/hmaster.yaml
kubectl rollout status --watch --timeout=600s statefulset/hm

kubectl apply -f hbase/regionserver.yaml
kubectl rollout status --watch --timeout=600s statefulset/rs
