#!/bin/bash

cd /root/wc/sw_spdk

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
sudo ./scripts/rpc.py nvmf_create_transport -t RDMA

sudo ./scripts/rpc.py bdev_malloc_create -b ram_bdev 1024 512

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha_header.json --device_id 1 --device_nqn nqn.2016-06.sw.ha:node --device_size 1GiB --uuid 6d28acdf-7d3e-49b2-ac07-f5678160d7c3 --ha_creation_action create_new --local_node_id 1 --local_node_type SYNC_REPLICA --local_node_nsid 1 --local_node_data_replica ram_bdev --node_partners_channel "SYNC TCP 10.10.10.2 7544" --node_partners_channel "HEARTBEAT TCP 10.10.10.2 7403"
sudo ./scripts/rpc.py bdev_ha_create Ha0 /root/wc/ha/ha_header.json

sudo ./scripts/rpc.py bdev_ha_set_nodemajority Ha0