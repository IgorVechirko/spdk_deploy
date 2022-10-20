#!/bin/bash -utf8

. ./base.sh


echo "Runing target for node $1..."

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./scripts/setup.sh cleanup
sudo HUGEMEM=$(get_node $1 "HUGEMEM") ./scripts/setup.sh

cd $(get_node $1 "bin_path")

sudo ./$(get_node $1 "exe_name") > $(get_node $1 "log_file") 2>&1 &

cd $self_path
