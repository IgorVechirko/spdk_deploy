#!/bin/bash

. ./base.sh

self_path=$(pwd)

cd $(get_node $1 "spdk_path")

sudo ./configure --disable-tests --disable-unit-tests --with-rdma --enable-debug

cd $self_path
