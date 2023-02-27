#!/bin/bash

sh kill_bin.sh ram512 2
sh run_bin.sh ram512 2
#sleep 3
#sh set_debug_log.sh ram512 1
sh setup_bin.sh ram512 2
sh setup_ha.sh ram512 2
#sh load_ha.sh ram512 2
sh create_ha.sh ram512 2
#sh append_ha.sh ram512 2
#sh connect_remote_node.sh ram512 2 1
#sh connect_remote_node.sh ram512 1 3
sh add_witness.sh rma512 1
sh nodemajority_set.sh ram512 2
#sh heartbeat_set.sh ram512 2

#tail -f ../../ha/tgt_output.log
