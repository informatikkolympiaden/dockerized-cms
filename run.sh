#! /bin/bash

container_name="$1"

function cleanup {
    podman stop $container_name
}

trap cleanup EXIT

args=("$@")

podman build -t nio:cms .
podman run -d --privileged --rm --network slirp4netns \
    --mount type=volume,src=$1-vol1,destination=/var/log/postgresql \
    --mount type=volume,src=$1-vol2,destination=/var/lib/postgresql \
    -p $2:8888 -p $3:8889 --name $1 ${args[@]:4} nio:cms

podman exec $1 cmsResourceService -a $4
