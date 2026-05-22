# AGENTS.md

## Repo Shape
- Root repo is an orchestrator over three Git submodules: `helm-hadoop`, `helm-zookeeper`, and `helm-hbase`.
- Most real code lives in the submodules; check diffs/status inside each submodule, not only the root repo.
- Charts deploy local images only: `local/hadoop:latest`, `local/zookeeper:latest`, and `local/hbase:latest` with `imagePullPolicy: Never`.

## Build Images
- Build all images from the root with `bash build_images.sh`; it runs Hadoop, ZooKeeper, then HBase image builds.
- Component build scripts are `helm-*/docker/build_image.sh`; each downloads tarballs, runs `docker build`, then `minikube image load`.
- Apache release tarballs should use fixed `https://archive.apache.org/dist/...` URLs, not `downloads.apache.org`.
- Keep package checksum variables and validation on SHA-512 (`*_SHA512SUM`, `gsha512sum`/`sha512sum`) unless the repo intentionally changes this.
- Java distribution is Amazon Corretto; Dockerfiles expect `amazon-corretto-*` tarballs.

## Cluster Lifecycle
- Start the full stack with `bash start_cluster.sh`.
- Deployment order matters: Hadoop first, then ZooKeeper, then HBase.
- `start_cluster.sh` waits for StatefulSets in this order: `jn`, `nn`, `dn`, `zk`, `hm`, `rs`.
- Destroy with `bash destroy_cluster.sh`; it uninstalls Helm releases and deletes PVCs for Hadoop and ZooKeeper data.

## Verification
- For shell-only changes, run `bash -n` on touched scripts.
- For chart rendering checks, use `helm template <release> <chart-dir>` before trying a cluster deploy.
- Full image builds are expensive because they download large Hadoop/HBase/JDK tarballs and require Docker plus Minikube.
- Full cluster verification requires Minikube, Helm, kubectl, and loaded local images.

## Platform Notes
- macOS setup in submodule READMEs uses `minikube start --driver qemu --network socket_vmnet ...`.
- Linux setup in submodule READMEs uses `minikube start --driver docker ...`.
- Service access docs rely on cluster DNS/routes and may require `minikube tunnel`; do not assume services are reachable from the host without that setup.
