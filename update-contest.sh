#! /bin/bash
docker exec $1 rm -rf /contest
docker cp $2 $1:/contest
docker exec $1 cmsImportContest -i -U -u /contest
