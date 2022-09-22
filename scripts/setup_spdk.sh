#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/rpc.py nvmf_create_transport -t TCP

sudo ./scripts/rpc.py bdev_malloc_create -b $(get_var "local_node_bdev") 1024 512
#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0

sudo ./scripts/rpc.py nvmf_create_subsystem $(get_var "nqn") -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py nvmf_subsystem_add_listener $(get_var "nqn") -t tcp -a $(get_var "ip") -s 4421
sudo ./scripts/rpc.py nvmf_subsystem_add_listener $(get_var "nqn") -t tcp -a $(get_var "ip") -s 4430

cd $self_path
