#!/usr/bin/env bash

kubectl delete --ignore-not-found statefulsets.apps nn jn dn zk hm rs
kubectl delete --ignore-not-found service namenode journalnode datanode zookeeper hmaster regionserver
kubectl delete --ignore-not-found pvc \
	namenode-data-nn-{0..1} journalnode-data-jn-{0..2} datanode-data-dn-{0..2} zookeeper-data-zk-{0..2}
kubectl delete --ignore-not-found configmaps hdfs-conf zk-conf hbase-conf namenode-entrypoint zookeeper-entrypoint
