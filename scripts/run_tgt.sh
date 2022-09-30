#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

self_path=$(pwd)

cd $(get_var "spdk_path")

sudo ./scripts/setup.sh cleanup
sudo HUGEMEM=4096 ./scripts/setup.sh

cd build/bin

sudo ./$(get_var "exe_name") > out.log 2>&1 &

cd $self_path
