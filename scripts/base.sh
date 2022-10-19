#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

get_node() {

	nodes=$(get_var "nodes")
	nodes_count=$(echo $nodes | jq 'length')


	for node_idx in `seq 0 $(($nodes_count-1))`
	do
		node_inf=$(echo $nodes|jq ".[$node_idx]" -r)
		node_id=$(echo $node_inf|jq '.id')

		if [ $node_id -eq $1 ]
		then
			value=$(echo $node_inf|jq ".$2" -r)

			if [ $value = "null" ]
			then
				get_var "defaults.$2"
			else
				echo $value
			fi
		fi
	done
}

self_path=$(pwd)



cd $self_path
