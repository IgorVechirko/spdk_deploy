#!/bin/bash

. ./base.sh


echo "Appending ha node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

if [ '$(get_node $1 "ram_bdev.name")' != "null" ]
then
	node_bdev=$(get_node $1 "ram_bdev.name")
elif [ '$(get_node $1 "nvme_bdev.name")' != "null" ]
then
	node_bdev=$(get_node $1 "nvme_bdev.name")
fi

sudo ./scripts/rpc.py bdev_ha_create_header $(get_node $1 "header_path")\
 --device_id $(get_var "ha.id")\
 --device_size $(get_var "ha.size")\
 --local_node_id $(get_node $1 "id")\
 --uuid $(get_var ha.uuid)\
 --local_node_type SYNC_REPLICA\
 --local_node_nqn $(get_var "ha.nqn")\
 --local_node_nsid $(get_node $1 "ns_id")\
 --local_node_data_replica $node_bdev\
 --ha_creation_action append_to_exist
sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha.name") $(get_node $1 "header_path")

cd $self_path
