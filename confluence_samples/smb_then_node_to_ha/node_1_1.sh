#!/bin/bash

cd /root/wc/sw_spdk

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
#sudo ./scripts/rpc.py nvmf_create_transport -t RDMA

sudo ./scripts/rpc.py bdev_malloc_create -b ram_bdev 1024 512

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha_header.json --device_id 1 --device_nqn nqn.2016-06.sw.ha:node --uuid 6d28acdf-7d3e-49b2-ac07-f5678160d7c3 --device_size 1GiB --local_node_id 1 --local_node_type SYNC_REPLICA --ha_creation_action create_new --local_node_data_replica ram_bdev
sudo ./scripts/rpc.py bdev_ha_create Ha0 /root/wc/ha/ha_header.json

#sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha:node -t rdma -a 192.168.0.10 -s 4421
sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha:node -t tcp -a 192.168.0.102 -s 4421
sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha:node -t tcp -a 192.168.0.102 -s 4430

sudo ./scripts/rpc.py bdev_ha_set_raft_leader_election Ha0
