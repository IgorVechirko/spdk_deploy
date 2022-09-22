#!/bin/bash

sh create_ha.sh
sh connect_remote_nodes.sh
sh add_witness.sh
sh raft_set.sh


