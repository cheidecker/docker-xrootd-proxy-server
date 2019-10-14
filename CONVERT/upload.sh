#!/bin/bash
if [ -z $1 ]; then
    echo "No ID given!"
    exit 1
else
    docker tag $1 cheidecker/xrootd-caching-proxy:testing
    docker login
    docker push cheidecker/xrootd-caching-proxy:testing
fi