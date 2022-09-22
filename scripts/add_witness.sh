#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py bdev_ha_add_witness_node $(get_var "ha_name") --witness-node-domain "" --witness-node-username "igor" --witness-node-password "1234" --witness-node-server "192.168.0.131" --witness-node-share "witness_share" --witness-node-path ""


cd $self_path
