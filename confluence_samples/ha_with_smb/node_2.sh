#!/bin/bash

cd /root/wc/sw_spdk

sudo ./scripts/rpc.py nvmf_create_transport -t TCP
sudo ./scripts/rpc.py nvmf_create_transport -t RDMA

sudo ./scripts/rpc.py bdev_malloc_create -b ram_bdev 1024 512
#bdev_nvme_attach_controller -b Nvme0 -t PCIe -a 00.00.00.e8

sudo ./scripts/rpc.py nvmf_create_subsystem nqn.2016-06.sw.ha:ha0 -a -s SPDK00000000000001 -d SPDK_Controller1 --ana-reporting

sudo ./scripts/rpc.py bdev_ha_create_header /root/wc/ha/ha_header.json --device_id 1 --device_nqn nqn.2016-06.sw.ha:ha0 --device_size 1GiB --uuid 6d28acdf-7d3e-49b2-ac07-f5678160d7c3 --ha_creation_action create_new --local_node_id 2 --local_node_nsid 1 --local_node_data_replica ram_bdev --node_partners_channel "SYNC TCP 30.30.30.102 9735"
sudo ./scripts/rpc.py bdev_ha_create Ha0 /root/wc/ha/ha_header.json

sudo ./scripts/rpc.py bdev_ha_append_node Ha0 --node_id 1 --node-nsid 1 --partners_channel "SYNC TCP 30.30.30.101 8523"

sudo ./scripts/rpc.py bdev_ha_add_smb_witness Ha0 --smb_domain "" --smb_username "root" --smb_password "1234" --smb_server "192.168.0.131" --smb_share "smb_witness" --smb_path ""

sudo ./scripts/rpc.py bdev_ha_set_nodemajority Ha0

#listener for clients connections
sudo ./scripts/rpc.py nvmf_subsystem_add_listener nqn.2016-06.sw.ha:ha0 -t tcp -a "40.40.40.102" -s 4420