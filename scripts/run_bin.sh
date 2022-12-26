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

echo "Runing target for node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/setup.sh cleanup
sudo HUGEMEM=$(get_node $1 "HUGEMEM") ./scripts/setup.sh

cd $(get_node $1 "bin_path")

sudo ./$(get_node $1 "exe_name") > $(get_node $1 "log_file") 2>&1 &

cd $self_path
