#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

get_node() {

	if [ "$2" ]
	then
		target_node=$1
		field=$2
	else
		field=$1
	fi

	if [ "$target_node" ]
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

	if [ "$value" ] && [ "$value" != "null" ]
	then
		echo $value
	else
		get_var "defaults.$field"
	fi
}

check_is_node_exist() {

	ret=0
	searching_node_id=$1

	nodes=$(get_var "nodes")
	nodes_count=$(echo $nodes | jq 'length')

	for node_idx in `seq 0 $(($nodes_count-1))`
	do
		node_info=$(echo $nodes|jq ".[$node_idx]" -r)
		node_id=$(echo $node_info|jq '.id')

		if [ $node_id -eq $searching_node_id ]
		then
			ret=1
			break
		fi

	done

	echo "$ret"
}

#ret=$(check_is_node_exist $1)
#echo $ret
#
#if [ $(check_is_node_exist $1) -eq "1" ]
#then
#	echo "yes"
#fi

#exit 1