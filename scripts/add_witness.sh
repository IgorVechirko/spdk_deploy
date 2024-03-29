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

echo "Add smbWitness to $dev device on $node node..."


spdk_path=$(get_dev_node_field $dev $node "spdk_path")

add_smb_cmd="sudo $spdk_path/scripts/rpc.py bdev_ha_add_smb_witness $dev"
#add_smb_cmd="$add_smb_cmd --smb_domain \"$(get_dev_field $dev 'smb_witness.domain')\""
add_smb_cmd="$add_smb_cmd --smb_username \"$(get_dev_field $dev 'smb_witness.username')\""
add_smb_cmd="$add_smb_cmd --smb_password \"$(get_dev_field $dev 'smb_witness.passwd')\""
add_smb_cmd="$add_smb_cmd --smb_server \"$(get_dev_field $dev 'smb_witness.server')\""
add_smb_cmd="$add_smb_cmd --smb_share \"$(get_dev_field $dev 'smb_witness.share')\""
#add_smb_cmd="$add_smb_cmd --smb_path \"$(get_dev_field $dev 'smb_witness.path')\""

host_addr=$(get_dev_node_field $dev $node "ssh_ftp_addr")
user=$(get_dev_node_field $dev $node "ssh_ftp_user")
pass=$(get_dev_node_field $dev $node "ssh_ftp_pass")

exe_on_host $host_addr $user $pass "$add_smb_cmd"
