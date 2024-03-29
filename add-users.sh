#! /bin/bash
while read line; do
    username="$(echo $line | cut -d, -f1)"
    firstname="$(echo $line | cut -d, -f2)"
    lastname="$(echo $line | cut -d, -f3)"
    password="$(echo $line | cut -d, -f5)"
    podman exec $1 cmsAddUser -p "$password" "$firstname" "$lastname" "$username"
    podman exec $1 cmsAddParticipation -c $3 ${@:4} "$username"
done < $2
