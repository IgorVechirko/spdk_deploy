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

echo "Killing $dev device binary on $node node..."

bin_name=$(get_dev_node_field $dev $node "bin_name")

kill_cmd="sudo ps -ax | grep $bin_name | grep -v grep | awk '{print \$1}' | sudo xargs kill -9"

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$kill_cmd"