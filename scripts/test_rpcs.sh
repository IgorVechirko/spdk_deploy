#!/bin/bash


#sh kill_bin.sh ram512 1
#sh run_bin.sh ram512 1
sh setup_bin.sh ram512 1
sh setup_ha.sh ram512 1

echo "\n"
sh create_ha.sh ram512 1
echo "\n"
sh connect_remote_node.sh ram512 1 2
echo "\n"
sh remove_node.sh ram512 1 2
echo "\n"

sh add_witness.sh ram512 1
echo "\n"
sh del_witness.sh ram512 1
echo "\n"

echo "\n"
#remove/add channels

#sh nodemajority_set.sh ram512 1
sh heartbeat_set.sh ram512 1
echo "\n"

echo "\n"
#sync

echo "\n"
#delete ha