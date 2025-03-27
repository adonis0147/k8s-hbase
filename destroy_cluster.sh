#!/usr/bin/env bash

helm uninstall hbase
helm uninstall zookeeper
helm uninstall hadoop

kubectl delete --ignore-not-found pvc \
	namenode-data-nn-{0..1} journalnode-data-jn-{0..2} datanode-data-dn-{0..2} zookeeper-data-zk-{0..2}
