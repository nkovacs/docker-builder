#!/bin/sh

dockerd-entrypoint.sh >/dev/null 2>&1 &
pid=$!


checkchild() {
    # prevent recursion
    trap '-' CHLD
    # get rid of terminated status
    jobs > /dev/null
    tmpfile=$(mktemp)
    jobs -lp > "$tmpfile"
    if ! grep "$pid" "$tmpfile" > /dev/null; then
        rm "$tmpfile"
        echo "docker daemon died"
        exit 1
    fi
    rm "$tmpfile"
    trap checkchild CHLD
}

# if dockerd-entrypoint.sh exits, fail
trap checkchild CHLD

while ! nc -vz localhost 2375 > /dev/null 2>&1; do sleep 1; done

# Docker daemon is running, don't fail if docker-entrypoint.sh exits
trap '-' CHLD

exec "$@"
