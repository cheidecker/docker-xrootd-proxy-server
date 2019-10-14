#!/usr/bin/env bash

# create voms-proxy
voms-proxy-init --voms cms:/cms/dcms --valid 192:00

exit $?