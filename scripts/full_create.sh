#!/bin/bash

sh kill_bin.sh ha1 1
sh clean_spdk_conf.sh ha1 1
sh run_bin.sh ha1 1

sleep 2

/root/wc/sw_spdk/scripts/rpc.py nvmf_set_config -m [2]
/root/wc/sw_spdk/scripts/rpc.py framework_start_init
#/root/wc/sw_spdk/scripts/rpc.py framework_set_scheduler dynamic

sh remove_header.sh ha1 1
#sh remove_header.sh ha2 1
#sh remove_header.sh ha3 1
#sleep 2
#sh set_debug_log.sh ha1 1 bdev_ha
#sh set_debug_log.sh ha1 1 bdev_ha_raft
sh setup_bin.sh ha1 1
sh setup_ha.sh ha1 1
#sh load_ha.sh ha1 1
sh create_ha.sh ha1 1
#sh append_ha.sh ha1 1
sh connect_remote_node.sh ha1 1 2
#sh nodemajority_set.sh ha1 1
sh heartbeat_set.sh ha1 1

#sh remove_header.sh ha2 1
#sh setup_ha.sh ha2 1
#sh create_ha.sh ha2 1
#sh connect_remote_node.sh ha2 1 2
#sh heartbeat_set.sh ha2 1 

#sh remove_header.sh ha3 1
#sh setup_ha.sh ha3 1
#sh create_ha.sh ha3 1
#sh connect_remote_node.sh ha3 1 2
#sh heartbeat_set.sh ha3 1
