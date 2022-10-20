#!/bin/bash

. ./base.sh


echo "Connecting node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

rpc_args="bdev_ha_add_remote_node $(get_var "ha.name")"
rpc_args="$rpc_args --remote_node_id $(get_node $1 'id')"
rpc_args="$rpc_args --remote_node_type SYNC_REPLICA"
rpc_args="$rpc_args --remote_node_nqn $(get_var 'ha.nqn')"
rpc_args="$rpc_args --remote_node_ns $(get_node $1 'ns_id')"

channels=$(get_node $1 "partners_channels")
channels_count=$(echo $channels|jq 'length')

for ch_idx in `seq 0 $(($channels_count-1))`
do
	channel=$(echo $channels|jq ".[$ch_idx]" -r)

	trt_type=$(echo $channel|jq '.type' -r)
	trt_type=$(echo $trt_type | tr '[:lower:]' '[:upper:]')

	rpc_args="$rpc_args --remote_node_channel \"$trt_type $(echo $channel|jq '.address' -r) $(echo $channel|jq '.port' -r)\""
done

sudo echo ${rpc_args}|xargs python3 -u ./scripts/rpc.py

cd $self_path