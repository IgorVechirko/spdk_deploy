#!/bin/bash

cd /root/wc/sw_spdk

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
sudo ./scripts/rpc.py nvmf_create_transport -t RDMA


# create Ha1 in nqn.2016-06.sw.ha1:node subsystem
sudo ./scripts/rpc.py bdev_malloc_create -b ram_bdev 512 512
#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha_header.json --device_id 1 --device_nqn nqn.2016-06.sw.ha:node --device_size 512MB --uuid 6d28acdf-7d3e-49b2-ac07-f5678160d7c3 --ha_creation_action create_new --local_node_id 2 --local_node_type SYNC_REPLICA --local_node_nsid 1 --local_node_data_replica ram_bdev --node_partners_channel "SYNC TCP 10.10.10.3 7654" --node_partners_channel "HEARTBEAT TCP 10.10.10.3 7654"
sudo ./scripts/rpc.py bdev_ha_create Ha0 /root/wc/ha/ha_header.json

sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha0 --remote_node_id 1 --remote_node_type SYNC_REPLICA --partners_channel "SYNC TCP 10.10.10.2 7544" --partners_channel "HEARTBEAT TCP 10.10.10.2 7403"

sudo ./scripts/rpc.py bdev_ha_set_nodemajority Ha0



# create Ha2 in nqn.2016-06.sw.ha2:node
sudo ./scripts/rpc.py bdev_malloc_create -b ha2_1_node 512 512
#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha2:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha2_header.json --device_id 2 --device_nqn nqn.2016-06.sw.ha2:node --device_size 512MB --uuid 6d28acdf-0000-49b2-ac07-f5678160d7c4 --ha_creation_action create_new --local_node_id 2 --local_node_type SYNC_REPLICA --local_node_nsid 1 --local_node_data_replica ha2_1_node --node_partners_channel "SYNC TCP 10.10.10.3 7654" --node_partners_channel "HEARTBEAT TCP 10.10.10.3 7654"

sudo ./scripts/rpc.py bdev_ha_create Ha2 /root/wc/ha/ha2_header.json

sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha2 --remote_node_id 1 --remote_node_type SYNC_REPLICA --partners_channel "SYNC TCP 10.10.10.2 7544" --partners_channel "HEARTBEAT TCP 10.10.10.2 7403"

sudo ./scripts/rpc.py bdev_ha_set_heartbeat Ha2