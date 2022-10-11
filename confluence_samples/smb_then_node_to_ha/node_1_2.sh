#!/bin/bash

cd /root/wc/sw_spdk

#Complete script for Node2 before use other part of script

#this one for append witness to existing HA device
sudo ./scripts/rpc.py bdev_ha_add_raft_smb_witness Ha0 --witness_domain "" --witness_username "root" --witness_password "1234" --witness_server "192.168.0.131" --witness_share "witness_share_root" --witness_path ""

#this one for append new node to existing HA device 
sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha0 --remote_node_id 2 --remote_node_type SYNC_REPLICA --remote_node_nqn nqn.2016-06.sw.ha:node --remote_node_channel "TCP 192.168.0.103 4421" #--remote_node_channel "RDMA 192.168.0.11 4421"
