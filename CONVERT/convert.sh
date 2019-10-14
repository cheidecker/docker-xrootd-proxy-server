#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname ${SCRIPT}`

#sudo docker save test-image -o test-image.tar

# for singularity version >=3.0:
# sudo singularity build test-image.sif docker-archive://test-image.tar

sudo singularity pull docker://cheidecker/xrootd-caching-proxy:testing