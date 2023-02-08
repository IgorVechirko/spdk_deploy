#!/bin/bash

cd /root/wc/sw_spdk

#Complete script for Node2 before use other part of script

#this one for append witness to existing HA device
sudo ./scripts/rpc.py bdev_ha_add_smb_witness Ha0 --smb_domain "" --smb_username "root" --smb_password "1234" --smb_server "192.168.0.131" --smb_share "smb_witness" --smb_path ""

#this one for append new node to existing HA device 
sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha0 --remote_node_id 2 --remote_node_type SYNC_REPLICA --partners_channel "SYNC TCP 10.10.10.3 7654" --partners_channel "HEARTBEAT TCP 10.10.10.3 7654"
