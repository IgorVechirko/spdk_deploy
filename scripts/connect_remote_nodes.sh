#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py bdev_ha_add_remote_node $(get_var "ha_name") --remote_node_id 2 --remote_node_type SYNC_REPLICA --remote_node_nqn $(get_var "nqn") --remote_node_nsid 1 --remote_node_channel "tcp 192.168.0.103 4421"

#sudo ./scripts/rpc.py bdev_ha_add_remote_node $(get_var "ha_name") --remote_node_id 3 --remote_node_type SYNC_REPLICA --remote_node_nqn $(get_var "nqn") --remote_node_nsid 1 --remote_node_channel "tcp 192.168.0.131 4421"

cd $self_path
