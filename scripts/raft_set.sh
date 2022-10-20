#!/bin/bash

. ./base.sh


echo "Setting raft to node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/rpc.py bdev_ha_set_raft_leader_election $(get_var "ha.name")



cd $self_path
