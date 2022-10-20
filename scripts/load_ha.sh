#!/bin/bash

. ./base.sh


echo "Loading ha node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha.name") $(get_node $1 "header_path")

cd $self_path
