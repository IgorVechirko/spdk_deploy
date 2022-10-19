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

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
sudo ./scripts/rpc.py nvmf_create_transport -t RDMA

#if [ $(get_node $1 "ram_bdev") != "null" ]
#then
#	sudo ./scripts/rpc.py bdev_malloc_create -b $(get_node $1 "ram_bdev") 1024 512
#elif [ $(get_node $1 "nvme_bdev.name") != "null")
#then
#	sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0
#fi

sudo ./scripts/rpc.py nvmf_create_subsystem $(get_var "ha.nqn") -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

partners_channels=$(get_node $1 "partners_channels")
echo $partners_channels
channels_count=$(echo $partners_channels|jq 'length')
echo $channels_count
for ch_idx in `seq 0 $(($channels_count-1))`
do
	echo $ch_idx
	channel=$(echo $partners_channels|jq ".[$ch_idx]")

	echo $channel

	rpc_args="nvmf_subsystem_add_listener $(get_var 'ha.nqn')"
	rpc_args="$rpc_args -t $(echo $channel|jq '.type' -r)"
	rpc_args="$rpc_args -a $(echo $channel|jq '.address' -r)"
	rpc_args="$rpc_args -s $(echo $channel|jq '.port' -r)"

	echo $rpc_args

	sudo ./scripts/rpc.py $rpc_args
done


#sudo ./scripts/rpc.py nvmf_subsystem_add_listener $(get_var "nqn") -t tcp -a $(get_var "ip") -s 4421
#sudo ./scripts/rpc.py nvmf_subsystem_add_listener $(get_var "nqn") -t tcp -a $(get_var "ip") -s 4430

cd $self_path
