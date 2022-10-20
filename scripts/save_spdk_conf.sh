#!/bin/bash

. ./base.sh


self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/rpc.py save_config > $(get_node $1 "spdk_conf")

cd $self_path
