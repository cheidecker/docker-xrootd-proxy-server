#!/bin/bash

# get script path
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

# get singularity major version
VERSION=`singularity --version`
MAJORVERSION=${VERSION:0:1}


if [ "$MAJORVERSION" -eq "3" ]; then
    echo "Building image for singularity version 3"
    # for singularity version >=3.0:
    echo "1. Extracting docker image to tar ball..."
    sudo docker save xrootd-caching-proxy-test-image -o xrootd-caching-proxy.tar
    echo "2. Converting tar ball to sif-image..."
    sudo singularity build xrootd-caching-proxy.sif docker-archive://xrootd-caching-proxy.tar

elif [ "$MAJORVERSION" -eq "2" ]; then
    echo "Building image for singularity version 2"
    echo "1. Uploading docker image to dockerhub..."
    # determing image to upload
    IMAGEID=`docker images --filter=reference='xrootd-caching-proxy-test-image:latest' --format "{{.ID}}"`
    echo ${IMAGEID}
    if ! [ -z ${IMAGEID} ]; then
        echo "Type your dockerhub path where to upload the image, followed by [ENTER]:"
        read DOCKERHUBPATH
        if ! [ -z ${DOCKERHUBPATH} ]; then
            docker tag ${IMAGEID} ${DOCKERHUBPATH}
            docker login
            docker push ${DOCKERHUBPATH}
            echo "2. Pulling and converting image to simg-image..."
            sudo singularity pull docker://${DOCKERHUBPATH}
        else
            echo "No valid docker hub path given, skipping conversion..."
        fi
    else
        echo "No valid docker image ID found, skipping conversion..."
    fi

else
    echo "Unknown singularity version, skipping conversion..."
fi