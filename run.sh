#! /bin/bash

container_name="$1"

function cleanup {
    docker stop $container_name
}

trap cleanup EXIT

docker build -t nio:cms .
docker run -d --privileged --rm \
    --mount source=$1-vol1,destination=/var/log/postgresql \
    --mount source=$1-vol2,destination=/var/lib/postgresql \
    -p $2:8888 -p $3:8889 --name $1 nio:cms

docker exec $1 cmsResourceService -a $4
