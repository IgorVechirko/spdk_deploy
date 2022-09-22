#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

wget -O ../sw_spdk/build/bin/$(get_var "exe_name") ftp://igor:1234@192.168.0.102/wc/sw_spdk/build/bin/$(get_var "exe_name")
