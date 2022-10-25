#!/bin/bash

sh kill_tgt.sh 1
#sh copy_build.sh 1
sh run_tgt.sh 1
sleep 2
sh setup_spdk.sh 1
sh create_ha.sh 1
sh connect_remote_node.sh 1
sh raft_set.sh 1
