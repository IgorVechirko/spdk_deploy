#!/bin/bash

#execute without sudo if not root
git clone https://gitlab.starwind.com/starwind/sw_spdk.git
cd sw_spdk
git checkout master.ha
git submodule update --init --recursive

#execute by sudo if not root
sudo ./scripts/pkgdep.sh --all
sudo ./configure --disable-tests --disable-unit-tests --with-rdma --enable-debug
