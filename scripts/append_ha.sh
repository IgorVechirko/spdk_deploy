#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

sudo sh setup_spdk.sh

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py bdev_ha_create_header $(get_var "ha_header") --device_id $(get_var "ha_dev_id") --local_node_id $(get_var "local_node_id") --local_node_type SYNC_REPLICA --local_node_nqn $(get_var "nqn") --local_node_data_replica $(get_var "local_node_bdev") --ha_creation_action append_to_exist
sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha_name") $(get_var "ha_header")

sudo ./scripts/rpc.py nvmf_subsystem_add_ns $(get_var "nqn") $(get_var "ha_name")

cd $self_path
