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

echo "Creating $dev device $node node..."

spdk_path=$(get_dev_node_field $dev $node "spdk_path")

ram_name=$(get_dev_node_field $dev $node "ram_bdev.name")
nvme_name=$(get_dev_node_field $dev $node "nvme_bdev.name")
aio_name=$(get_dev_node_field $dev $node "aio_bdev.name")

if [ "$ram_name" != "null" ]
then
	node_bdev=$(get_dev_node_field $dev $node "ram_bdev.name")
elif [ "$nvme_name" != "null" ]
then
	node_bdev=$(get_dev_node_field $dev $node "nvme_bdev.name")
elif [ "$aio_name" != "null" ]
then
	node_bdev=$(get_dev_node_field $dev $node "aio_bdev.name")
fi

create_ha_header_cmd="sudo $spdk_path/scripts/rpc.py bdev_ha_create_header $(get_dev_node_field $dev $node "header_path")"
create_ha_header_cmd="$create_ha_header_cmd --device_id $(get_dev_field $dev "id")"
create_ha_header_cmd="$create_ha_header_cmd --device_nqn $(get_dev_field $dev "nqn")"
create_ha_header_cmd="$create_ha_header_cmd --device_size $(get_dev_field $dev "size")"
create_ha_header_cmd="$create_ha_header_cmd --uuid $(get_dev_field $dev "uuid")"
create_ha_header_cmd="$create_ha_header_cmd --ha_creation_action create_new"
create_ha_header_cmd="$create_ha_header_cmd --local_node_id $node"
#create_ha_header_cmd="$create_ha_header_cmd --local_node_type SYNC_REPLICA"
create_ha_header_cmd="$create_ha_header_cmd --local_node_nsid $(get_dev_node_field $dev $node "ns_id")"
create_ha_header_cmd="$create_ha_header_cmd --local_node_data_replica $node_bdev"

workers_cores=$(get_dev_node_field $dev $node "workers_cores")
if [ "$workers_cores" != "null" ]
then
	create_ha_header_cmd="$create_ha_header_cmd --workers_cores $workers_cores"
fi

channels=$(get_dev_node_field $dev $node "partners_channels")
channels_count=$(echo $channels|jq 'length')

for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $channels|jq ".[$ch_idx]" -r)

	trt_type=$(echo $channel|jq '.type' -r)

	trt_transport=$(echo $channel|jq '.transport' -r)
	trt_transport=$(echo $trt_transport| tr '[:lower:]' '[:upper:]')

	address=$(echo $channel|jq '.address' -r)
	port=$(echo $channel|jq '.port' -r)

	create_ha_header_cmd="$create_ha_header_cmd --node_partners_channel \"$trt_type $trt_transport $address $port\""
done


create_ha_cmd="sudo $spdk_path/scripts/rpc.py bdev_ha_create $dev $(get_dev_node_field $dev $node "header_path")"

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$create_ha_header_cmd"
exe_on_host $host_addr $user $pass "$create_ha_cmd"
