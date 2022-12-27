#!/bin/bash

#sh kill_tgt.sh 1
#sh run_tgt.sh 1
#sleep 2
#sh setup_spdk.sh 1
#sh create_ha.sh 1
#sh connect_remote_node.sh 2
#sh add_witness.sh
#sh raft_set.sh 1
#sh hb_set.sh 1
#sh hb_set.sh 1

#tail -f ../../ha/tgt_output.log

sh kill_bin.sh Ha2 2
sh run_bin.sh Ha2 2
sh setup_ha.sh Ha2 2
sh create_ha.sh Ha2 2
#sh append_ha.sh Ha2 2
sh connect_remote_node.sh Ha2 2 1
sh raft_set.sh Ha2 2