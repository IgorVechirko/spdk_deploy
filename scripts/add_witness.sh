#!/bin/bash

. ./base.sh


echo "Adding smb witness..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

rpc_args="bdev_ha_add_raft_smb_witness $(get_var 'ha.name') --witness-domain \"$(get_var 'smb_witness.domain')\" --witness-username \"$(get_var 'smb_witness.username')\" --witness-password \"$(get_var 'smb_witness.passwd')\" --witness-server \"$(get_var 'smb_witness.server')\" --witness-share \"$(get_var 'smb_witness.share')\" --witness-path \"$(get_var 'smb_witness.path')\""

sudo echo ${rpc_args}|xargs python3 -u ./scripts/rpc.py

cd $self_path
