#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py bdev_ha_delete $(get_var "ha_name") --delete_storage --delete_header

cd $self_path
