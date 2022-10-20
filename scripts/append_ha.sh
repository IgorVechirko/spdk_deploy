#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

get_node() {

	if [ "$2" ]
	then
		target_node=$1
		field=$2
	else
		field=$1
	fi

	if [ "$target_node" ]
	then

		nodes=$(get_var "nodes")
		nodes_count=$(echo $nodes | jq 'length')

		for node_idx in `seq 0 $(($nodes_count-1))`
		do
			node_inf=$(echo $nodes|jq ".[$node_idx]" -r)
			node_id=$(echo $node_inf|jq '.id')

			if [ $node_id -eq $target_node ]
			then
				value=$(echo $node_inf|jq ".$field" -r)
			fi
		done
	fi

	if [ "$value" ] && [ "$value" != "null" ]
	then
		echo $value
	else
		get_var "defaults.$field"
	fi
}


self_path=$(pwd)

cd $(get_node $1 "spdk_path")

if [ '$(get_node $1 "ram_bdev.name")' != "null" ]
then
	node_bdev=$(get_node $1 "ram_bdev.name")
elif [ '$(get_node $1 "nvme_bdev.name")' != "null" ]
then
	node_bdev=$(get_node $1 "nvme_bdev.name")
fi

sudo ./scripts/rpc.py bdev_ha_create_header $(get_node $1 "header_path") --device_id $(get_var "ha.id") --device_size $(get_var "ha.size") --local_node_id $(get_node $1 "id") --local_node_type SYNC_REPLICA --local_node_nqn $(get_var "ha.nqn") --local_node_nsid $(get_node $1 "ns_id") --local_node_data_replica $node_bdev --ha_creation_action append_to_exist
sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha.name") $(get_node $1 "header_path")

cd $self_path
