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

	docker build --build-arg PASSWORD="$(openssl passwd -1 hadoop)" -t hdfs .

	popd &>/dev/null
}

function main() {
	download_packages
	build_hdfs
}

main
