#!/bin/bash

. ./base.sh

help()
{
	echo "\nPlease call:\n\t $0 <dev_name> <target_node_id> <node_to_connect>"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]
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

if [ $(check_is_dev_node_exist $1 $3) -eq "0" ]
then
	echo "\nFor device $1 node $1 doesn't exist"
	exit 1
fi

dev=$1
node=$2
remote_node=$3

echo "For $dev device connect $3 node to $2 node..."

spdk_path=$(get_dev_node_field $dev $node "spdk_path")

rpc_args="bdev_ha_add_remote_node $dev"
rpc_args="$rpc_args --remote_node_id $remote_node"
rpc_args="$rpc_args --remote_node_type SYNC_REPLICA"
rpc_args="$rpc_args --remote_node_ns $(get_dev_node_field $dev $remote_node 'ns_id')"

channels=$(get_dev_node_field $dev $remote_node "partners_channels")
channels_count=$(echo $channels|jq 'length')

for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $channels|jq ".[$ch_idx]" -r)

	trt_type=$(echo $channel|jq '.type' -r)

	trt_transport=$(echo $channel|jq '.transport' -r)
	trt_transport=$(echo $trt_type | tr '[:lower:]' '[:upper:]')

	rpc_args="$rpc_args --partners_channel \"$trt_type $trt_transport $(echo $channel|jq '.address' -r) $(echo $channel|jq '.port' -r)\""
done

add_node_cmd="sudo $spdk_path/scripts/rpc.py $rpc_args"

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$add_node_cmd"