#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

sh setup_spdk.sh

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py bdev_ha_create $(get_var "ha_name") $(get_var "ha_header")

sudo ./scripts/rpc.py nvmf_subsystem_add_ns $(get_var "nqn") $(get_var "ha_name")


cd $self_path
