#!/bin/bash

. ./base.sh


self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/rpc.py bdev_ha_delete $(get_var "ha.name") --delete_storage --delete_header

cd $self_path
