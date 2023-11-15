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
	echo "\nFor device $1 node $2 doesn't exist"
	exit 1
fi

dev=$1
node=$2

echo "Runing binary for device $dev on node $node..."

spdk_path=$(get_dev_node_field $dev $node "spdk_path")
bin_path=$(get_dev_node_field $dev $node "bin_path")
bin_name=$(get_dev_node_field $dev $node "bin_name")
huge_size=$(get_dev_node_field $dev $node "HUGEMEM")
log_file=$(get_dev_node_field $dev $node "log_file")
spdk_conf=$(get_dev_node_field $dev $node "spdk_conf")

cleanup_cmd="$spdk_path/scripts/setup.sh cleanup"
setup_cmd="sudo HUGEMEM=$huge_size $spdk_path/scripts/setup.sh"
run_bin_cmd="sudo $bin_path/$bin_name -f $spdk_conf > $log_file 2>&1 &"

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$cleanup_cmd"
exe_on_host $host_addr $user $pass "$setup_cmd"
exe_on_host $host_addr $user $pass "$run_bin_cmd"
