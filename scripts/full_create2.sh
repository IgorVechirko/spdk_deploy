#!/bin/bash

sh kill_bin.sh ram512 2
sh run_bin.sh ram512 2
#sleep 3
#../../sw_spdk/scripts/rpc.py log_set_print_level DEBUG
sh setup_bin.sh ram512 2
sh setup_ha.sh ram512 2
sh load_ha.sh ram512 2
#sh load_ha.sh ram512 2
#sh create_ha.sh ram512 2
#sh connect_remote_node.sh ram512 2 1
#sh connect_remote_node.sh ram512 1 3
#sh raft_set.sh ram512 2
#sh heartbeat_set.sh ram512 2

#tail -f ../../ha/tgt_output.log
