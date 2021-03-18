#! /bin/bash
docker build -t nio:cms .
docker run -d --rm \
	--mount source=$1-vol1,destination=/var/log/postgresql \
	--mount source=$1-vol2,destination=/var/lib/postgresql \
	--name $1 nio:cms

docker cp $2 $1:/contest
docker exec $1 cmsImportContest -i -U -u /contest
docker stop $1
