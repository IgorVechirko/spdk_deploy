#!/bin/bash

. ./base.sh


echo "Setuping spdk for node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
sudo ./scripts/rpc.py nvmf_create_transport -t RDMA

ram_name=$(get_node $1 "ram_bdev.name")
nvme_name=$(get_node $1 "nvme_bdev.name")

if [ "$ram_name" != "null" ]
then
	sudo ./scripts/rpc.py bdev_malloc_create -b $(get_node $1 "ram_bdev.name") $(get_node $1 "ram_bdev.size") $(get_node $1 "ram_bdev.block_size")
elif [ "$nvme_name" != "null" ]
then
	sudo ./scripts/rpc.py bdev_nvme_attach_controller -b $(get_node $1 "nvme_bdev.prefix") -t PCIe -a $(get_node $1 "nvme_bdev.controller")
fi

sudo ./scripts/rpc.py nvmf_create_subsystem $(get_var "ha.nqn") -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

partners_channels=$(get_node $1 "partners_channels")
channels_count=$(echo $partners_channels|jq 'length')
for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $partners_channels|jq ".[$ch_idx]")

	rpc_args="nvmf_subsystem_add_listener $(get_var 'ha.nqn')"
	rpc_args="$rpc_args -t $(echo $channel|jq '.type' -r)"
	rpc_args="$rpc_args -a $(echo $channel|jq '.address' -r)"
	rpc_args="$rpc_args -s $(echo $channel|jq '.port' -r)"

	sudo ./scripts/rpc.py $rpc_args
done

clients_channels=$(get_node $1 "clients_channels")
channels_count=$(echo $clients_channels|jq 'length')
for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $clients_channels|jq ".[$ch_idx]")

	rpc_args="nvmf_subsystem_add_listener $(get_var 'ha.nqn')"
	rpc_args="$rpc_args -t $(echo $channel|jq '.type' -r)"
	rpc_args="$rpc_args -a $(echo $channel|jq '.address' -r)"
	rpc_args="$rpc_args -s $(echo $channel|jq '.port' -r)"

	sudo ./scripts/rpc.py $rpc_args
done


cd $self_path
