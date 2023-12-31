#!/usr/bin/env bash

set -e

PROJECT_PATH="$(
	cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null
	pwd
)"
readonly PROJECT_PATH

function download_packages() {
	pushd "${PROJECT_PATH}/packages" &>/dev/null
	bash download_packages.sh
	popd &>/dev/null
}

function build_hdfs() {
	pushd "${PROJECT_PATH}/hdfs" &>/dev/null

	ln -f "${PROJECT_PATH}/packages"/jdk-*.tar.gz .
	ln -f "${PROJECT_PATH}/packages"/hadoop-*.tar.gz .

	docker build -t hdfs .

	popd &>/dev/null

	minikube image load --alsologtostderr hdfs:latest
}

function build_zookeeper() {
	pushd "${PROJECT_PATH}/zookeeper" &>/dev/null

	ln -f "${PROJECT_PATH}/packages"/jdk-*.tar.gz .
	ln -f "${PROJECT_PATH}/packages"/apache-zookeeper-*.tar.gz .

	docker build -t zookeeper .

	popd &>/dev/null

	minikube image load --alsologtostderr zookeeper:latest
}

function build_hbase() {
	pushd "${PROJECT_PATH}/hbase" &>/dev/null

	ln -f "${PROJECT_PATH}/packages"/jdk-*.tar.gz .
	ln -f "${PROJECT_PATH}/packages"/hbase-*.tar.gz .

	docker build -t hbase .

	popd &>/dev/null

	minikube image load --alsologtostderr hbase:latest
}

function main() {
	download_packages

	if [[ "${#@}" == 0 ]]; then
		build_hdfs
		build_zookeeper
		build_hbase
	else
		for package in "${@}"; do
			local cmd="build_${package}"
			"${cmd}"
		done
	fi
}

main "${@}"
