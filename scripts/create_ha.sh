#!/bin/bash

. ./base.sh


echo "Creating ha node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

ram_name=$(get_node $1 "ram_bdev.name")
nvme_name=$(get_node $1 "nvme_bdev.name")


if [ "$ram_name" != "null" ]
then
	node_bdev=$(get_node $1 "ram_bdev.name")
elif [ "$nvme_name" != "null" ]
then
	node_bdev=$(get_node $1 "nvme_bdev.name")
fi

sudo ./scripts/rpc.py bdev_ha_create_header $(get_node $1 "header_path") \
 --device_id $(get_var "ha.id")\
 --device_nqn $(get_var "ha.nqn")\
 --device_size $(get_var "ha.size")\
 --uuid $(get_var "ha.uuid")\
 --local_node_id $(get_node $1 "id")\
 --local_node_type SYNC_REPLICA\
 --local_node_nsid $(get_node $1 "ns_id")\
 --local_node_data_replica $node_bdev\
 --ha_creation_action create_new

sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha.name") $(get_node $1 "header_path")

cd $self_path
