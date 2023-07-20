#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(
	cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null
	pwd
)"
readonly SCRIPT_PATH

arch="$(uname -m)"
# shellcheck disable=2034
declare -r JAVA_URL="https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-${arch/86_/}_bin.tar.gz"

if [[ "${arch}" == 'x86_64' ]]; then
	# shellcheck disable=2034
	declare -r JAVA_SHA256SUM='74b528a33bb2dfa02b4d74a0d66c9aff52e4f52924ce23a62d7f9eb1a6744657'
else
	# shellcheck disable=2034
	declare -r JAVA_SHA256SUM=cd24d7b21ec0791c5a77dfe0d9d7836c5b1a8b4b75db7d33d253d07caa243117
fi

# shellcheck disable=2034
declare -r HADOOP_URL='https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz'
# shellcheck disable=2034
declare -r HADOOP_SHA256SUM='f5195059c0d4102adaa7fff17f7b2a85df906bcb6e19948716319f9978641a04'

function download() {
	local package
	package="$(echo "${1}" | awk '{print toupper($0)}')"
	local url_variable="${package}_URL"
	local checksum_variable="${package}_SHA256SUM"

	local url="${!url_variable}"
	local checksum="${!checksum_variable}"
	local filename
	filename="$(basename "${url}")"

	if [[ ! -f "${filename}" ]] || ! echo "${checksum} ${filename}" | sha256sum --check &>/dev/null; then
		curl -LO "${url}"
	fi
}

function main() {
	pushd "${SCRIPT_PATH}" &>/dev/null

	download 'java'
	download 'hadoop'

	popd &>/dev/null
}

main
