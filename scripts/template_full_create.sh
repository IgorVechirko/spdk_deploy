#!/bin/bash

sh kill_bin.sh ram512 1
sh run_bin.sh ram512 1
sh remove_header.sh ram512 1
#sleep 3
#sh set_debug_log.sh ram512 1
sh setup_bin.sh ram512 1
sh setup_ha.sh ram512 1
#sh load_ha.sh ram512 1
sh create_ha.sh ram512 1
sh connect_remote_node.sh ram512 1 2
#sh connect_remote_node.sh ram512 1 3
#sh nodemajority_set.sh ram512 1
sh heartbeat_set.sh ram512 1

#tail -f ../../ha/tgt_output.log
