#!/bin/bash

. ./base.sh

help()
{
	echo "\nPlease call:\n\t $0 <dev_name> <node_id>"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ] || [ -z "$2" ]
then
	help
	exit 1
fi

if [ -z "$get_dev_info $1" ]
then
	echo "\nDevice $1 doesn't exist"
	exit 1
fi

if [ $(check_is_dev_node_exist $1 $2) -eq "0" ]
then
	echo "\nFor device $1 node $1 doesn't exist"
	exit 1
fi

dev=$1
node=$2

echo "Setuping $dev device on $node node..."

spdk_path=$(get_dev_node_field $dev $node "spdk_path")

ram_name=$(get_dev_node_field $dev $node "ram_bdev.name")
nvme_name=$(get_dev_node_field $dev $node "nvme_bdev.name")
#ram_name=$(get_node $1 "ram_bdev.name")
#nvme_name=$(get_node $1 "nvme_bdev.name")

if [ "$ram_name" != "null" ]
then
	ram_size=$(get_dev_node_field $dev $node "ram_bdev.size")
	ram_blk_size=$(get_dev_node_field $dev $node "ram_bdev.block_size")

	create_bdev_cmd="sudo $spdk_path/scripts/rpc.py bdev_malloc_create -b $ram_name $ram_size $ram_blk_size"
elif [ "$nvme_name" != "null" ]
then
	nvme_prefix=$(get_dev_node_field $dev $node "nvme_bdev.prefix")
	nvme_ctrlr=$(get_dev_node_field $dev $node "nvme_bdev.controller")

	#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b $(get_node $1 "nvme_bdev.prefix") -t PCIe -a $(get_node $1 "nvme_bdev.controller")
	create_bdev_cmd="sudo $spdk_path/scripts/rpc.py bdev_nvme_attach_controller -b $nvme_prefix -t PCIe -a $nvme_ctrlr"
fi

dev_nqn=$(get_dev_field $dev "nqn")
#sudo ./scripts/rpc.py nvmf_create_subsystem $(get_var "ha.nqn") -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting
create_subsys_cmd="sudo $spdk_path/scripts/rpc.py nvmf_create_subsystem $dev_nqn -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting"

partners_channels=$(get_dev_node_field $dev $node "partners_channels")
channels_count=$(echo $partners_channels|jq 'length')
for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $partners_channels|jq ".[$ch_idx]")

	rpc_args="nvmf_subsystem_add_listener $dev_nqn"
	rpc_args="$rpc_args -t $(echo $channel|jq '.type' -r)"
	rpc_args="$rpc_args -a $(echo $channel|jq '.address' -r)"
	rpc_args="$rpc_args -s $(echo $channel|jq '.port' -r)"

	#sudo ./scripts/rpc.py $rpc_args
	add_partners_lst_cmd="$spdk_path/scripts/rpc.py $rpc_args"
done

clients_channels=$(get_dev_node_field $dev $node "clients_channels")
channels_count=$(echo $clients_channels|jq 'length')
for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $clients_channels|jq ".[$ch_idx]")

	rpc_args="nvmf_subsystem_add_listener $dev_nqn"
	rpc_args="$rpc_args -t $(echo $channel|jq '.type' -r)"
	rpc_args="$rpc_args -a $(echo $channel|jq '.address' -r)"
	rpc_args="$rpc_args -s $(echo $channel|jq '.port' -r)"

	#sudo ./scripts/rpc.py $rpc_args
	add_clients_lst_cmd="$spdk_path/scripts/rpc.py $rpc_args"
done

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$create_bdev_cmd"
exe_on_host $host_addr $user $pass "$create_subsys_cmd"
exe_on_host $host_addr $user $pass "$add_partners_lst_cmd"
exe_on_host $host_addr $user $pass "$add_clients_lst_cmd"

