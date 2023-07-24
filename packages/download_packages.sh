#!/usr/bin/env bash

set -e

SCRIPT_PATH="$(
	cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null
	pwd
)"
readonly SCRIPT_PATH

arch="$(uname -m)"
if [[ "${arch}" == 'arm64' ]]; then
	arch='aarch64'
fi

if [[ "${arch}" == 'x86_64' ]]; then
	# shellcheck disable=2034
	declare -r JAVA_URL="https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-${arch/86_/}_bin.tar.gz"
	# shellcheck disable=2034
	declare -r JAVA_SHA256SUM='74b528a33bb2dfa02b4d74a0d66c9aff52e4f52924ce23a62d7f9eb1a6744657'
	# shellcheck disable=2034
	declare -r HADOOP_URL='https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz'
	# shellcheck disable=2034
	declare -r HADOOP_SHA256SUM='f5195059c0d4102adaa7fff17f7b2a85df906bcb6e19948716319f9978641a04'
else
	# shellcheck disable=2034
	declare -r JAVA_URL="https://download.oracle.com/java/17/archive/jdk-17.0.8_linux-${arch}_bin.tar.gz"
	# shellcheck disable=2034
	declare -r JAVA_SHA256SUM=cd24d7b21ec0791c5a77dfe0d9d7836c5b1a8b4b75db7d33d253d07caa243117
	# shellcheck disable=2034
	declare -r HADOOP_URL="https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6-${arch}.tar.gz"
	# shellcheck disable=2034
	declare -r HADOOP_SHA256SUM='e4bbf6b80ef604912f6b9bf6ca77323dee6028d08d38f36ca077df56de8a5d0d'
fi

# shellcheck disable=2034
declare -r ZOOKEEPER_URL='https://dlcdn.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz'
# shellcheck disable=2034
declare -r ZOOKEEPER_SHA256SUM='dedf166f9a5fb12240041385a74ec81ce9de63f2a49454883027cf6acae202a5'
# shellcheck disable=2034
declare -r HBASE_URL='https://dlcdn.apache.org/hbase/2.5.5/hbase-2.5.5-bin.tar.gz'
# shellcheck disable=2034
declare -r HBASE_SHA256SUM='e67d717e96d17980f92d9afb948b9368d13fe2422a3b1f6e978e39b20d6d4df7'

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
	download 'zookeeper'
	download 'hbase'

	popd &>/dev/null
}

main
