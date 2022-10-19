#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

get_node() {

	if [ $2 ]
	then
		target_node=$1
		field=$2
	else
		field=$1
	fi


	if [ $target_node ]
	then

		nodes=$(get_var "nodes")
		nodes_count=$(echo $nodes | jq 'length')

		for node_idx in `seq 0 $(($nodes_count-1))`
		do
			node_inf=$(echo $nodes|jq ".[$node_idx]" -r)
			node_id=$(echo $node_inf|jq '.id')

			if [ $node_id -eq $target_node ]
			then
				value=$(echo $node_inf|jq ".$field" -r)
			fi
		done

	fi

	if [ $value ] && [ $value != "null" ]
	then
		echo $value
	else
		get_var "defaults.$field"
	fi
}

sudo ps -ax | grep $(get_node $1 "exe_name") | grep -v grep | awk '{print $1}' | sudo xargs kill -9
