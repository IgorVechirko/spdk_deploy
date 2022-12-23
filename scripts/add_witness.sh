#!/bin/bash

. ./base.sh

help()
{
	echo "\nPlease call:\n\t $0 <node_id>"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ -z "$1" ]
then
	help
	exit 1
fi

if [ $(check_is_node_exist $1) -eq "0" ]
then
	echo "\nNode $1 doesn't exist"
	exit 1
fi

node_id=$1

echo "\nAdding smb witness..."

self_path=$(pwd)

cd $(get_node $node_id "spdk_path")

rpc_args="bdev_ha_add_raft_smb_witness $(get_var 'ha.name')"
rpc_args="$rpc_args --witness-domain \"$(get_var 'smb_witness.domain')\""
rpc_args="$rpc_args --witness-username \"$(get_var 'smb_witness.username')\""
rpc_args="$rpc_args --witness-password \"$(get_var 'smb_witness.passwd')\""
rpc_args="$rpc_args --witness-server \"$(get_var 'smb_witness.server')\""
rpc_args="$rpc_args --witness-share \"$(get_var 'smb_witness.share')\""
rpc_args="$rpc_args --witness-path \"$(get_var 'smb_witness.path')\""

sudo echo ${rpc_args}|xargs python3 -u ./scripts/rpc.py

cd $self_path
