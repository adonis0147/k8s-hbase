#!/usr/bin/env bash

set -e

PROJECT_PATH="$(
	cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null
	pwd
)"
readonly PROJECT_PATH

function main() {
	pushd "${PROJECT_PATH}"

	local dirs=(helm-hadoop helm-zookeeper helm-hbase)
	local dir

	for dir in "${dirs[@]}"; do
		"${dir}/build-image.sh"
	done

	popd
}

main "${@}"
