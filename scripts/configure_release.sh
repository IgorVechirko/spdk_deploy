#!/bin/bash

. ./base.sh


self_path=$(pwd)

#cd $(get_node $1 "spdk_path")
cd ../../sw_spdk

sudo ./configure --disable-tests --disable-unit-tests --with-rdma

cd $self_path
