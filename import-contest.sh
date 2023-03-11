#! /bin/bash
podman build -t nio:cms .
podman run -d --rm --network slirp4netns \
	--mount type=volume,src=$1-vol1,destination=/var/log/postgresql \
	--mount type=volume,src=$1-vol2,destination=/var/lib/postgresql \
	--name $1 nio:cms

podman cp $2 $1:/contest
podman exec $1 cmsImportContest -i -U -u /contest
podman stop $1
