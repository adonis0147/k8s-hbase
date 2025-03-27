#!/usr/bin/env bash

helm install --name-template=hadoop helm-hadoop

kubectl rollout status --watch --timeout=600s statefulset/jn
kubectl rollout status --watch --timeout=600s statefulset/nn
kubectl rollout status --watch --timeout=600s statefulset/dn

sleep 30

helm install --name-template=zookeeper helm-zookeeper

kubectl rollout status --watch --timeout=600s statefulset/zk

sleep 30

helm install --name-template=hbase helm-hbase

kubectl rollout status --watch --timeout=600s statefulset/hm
kubectl rollout status --watch --timeout=600s statefulset/rs
