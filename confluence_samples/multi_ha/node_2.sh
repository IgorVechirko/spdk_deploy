#!/bin/bash

cd /root/wc/sw_spdk

sudo ./scripts/rpc.py nvmf_create_transport -t TCP

# create Ha1 in nqn.2016-06.sw.ha1:node subsystem
sudo ./scripts/rpc.py bdev_malloc_create -b ha1_2_node 1024 512
#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha1:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha1:node -t tcp -a 192.168.0.103 -s 4421
sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha1:node -t tcp -a 192.168.0.103 -s 4430

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha1_header.json --device_id 1 --device_nqn nqn.2016-06.sw.ha1:node --uuid 6d28acdf-7d3e-49b2-ac07-f5678160d7c3 --local_node_id 2 --local_node_type SYNC_REPLICA --local_node_data_replica ha1_2_node --ha_creation_action create_new

sudo ./scripts/rpc.py bdev_ha_create Ha1 /root/wc/ha/ha1_header.json

sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha1 --remote_node_id 1 --remote_node_type SYNC_REPLICA --remote_node_channel "tcp 192.168.0.102 4421"

sudo ./scripts/rpc.py bdev_ha_set_raft_leader_election Ha1


# create Ha2 in nqn.2016-06.sw.ha2:node
sudo ./scripts/rpc.py bdev_malloc_create -b ha2_2_node 1024 512
#sudo ./scripts/rpc.py bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 0000:00:0e.0

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha2:node -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha2:node -t tcp -a 192.168.0.103 -s 4421
sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha2:node -t tcp -a 192.168.0.103 -s 4430

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha2_header.json --device_id 2 --device_nqn nqn.2016-06.sw.ha2:node --uuid 6d28acdf-0000-49b2-ac07-f5678160d7c3 --local_node_id 2 --local_node_type SYNC_REPLICA --local_node_data_replica ha2_2_node --ha_creation_action create_new

sudo ./scripts/rpc.py bdev_ha_create Ha2 /root/wc/ha/ha2_header.json

sudo ./scripts/rpc.py bdev_ha_add_remote_node Ha2 --remote_node_id 1 --remote_node_type SYNC_REPLICA --remote_node_channel "tcp 192.168.0.102 4421"

sudo ./scripts/rpc.py bdev_ha_set_raft_leader_election Ha2
