#! /bin/bash
podman exec $1 rm -rf /contest
podman cp $2 $1:/contest
podman exec $1 cmsImportContest -i -U -u /contest
