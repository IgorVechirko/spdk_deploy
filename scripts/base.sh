#!/bin/bash

vars=$(sudo cat ./vars.json)

get_dev_info() {

	ret=""
	searching_dev_name=$1

	devs_count=$(echo $vars|jq 'length')

	for dev_indx in `seq 0 $(($devs_count-1))`
	do
		dev_info=$(echo $vars|jq ".[$dev_indx]" -r)
		conf_dev_name=$(echo $dev_info|jq '.name' -r)

		if [ $searching_dev_name = $conf_dev_name ]
		then
			ret=$dev_info
			break
		fi

	done

	echo "$ret"
}

#if [ "$(get_dev_info $1)" ]
#then
#	echo "device exist"
#else
#	echo "device is absent"
#fi

check_is_dev_node_exist() {

	ret=0
	dev_name=$1
	searching_node_id=$2

	dev_info=$(get_dev_info $dev_name)

	nodes=$(echo $dev_info|jq '.nodes' -r)
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

#if [ $(check_is_dev_node_exist $1 $2) -eq "1" ]
#then
#	echo "Dev $1 contain $2 node"
#else
#	echo "Dev $1 doesn't contain $2 node"
#fi

get_dev_field() {

	dev_name=$1
	field=$2

	dev_info=$(get_dev_info $dev_name)

	var_val=$(echo $dev_info|jq ".$field" -r)
	echo $var_val
}

#dev_field=$(get_dev_field $1 $2)
#echo "$dev_field"

get_dev_node_field() {

	dev_name=$1
	node_id=$2
	field=$3

	dev_info=$(get_dev_info $dev_name)

	nodes=$(echo $dev_info|jq '.nodes' -r)
	nodes_count=$(echo $nodes | jq 'length')

	for node_idx in `seq 0 $(($nodes_count-1))`
	do
		node_inf=$(echo $nodes|jq ".[$node_idx]" -r)
		test_id=$(echo $node_inf|jq '.id')

		if [ $node_id -eq $test_id ]
		then
			value=$(echo $node_inf|jq ".$field" -r)
		fi
	done

	if [ "$value" ] && [ "$value" != "null" ]
	then
		echo $value
	else
		get_dev_field $dev_name "defaults.$field"
	fi
}

#node_field=$(get_dev_node_field $1 $2 $3)
#echo "$node_field"

exe_on_host(){

	host=$1
	user=$2
	pass=$3
	cmd=$4

	exe_localy=0

	ip_a=$(ip -j a)

	eth_count=$(echo $ip_a|jq 'length')

	for eth_indx in `seq 0 $(($eth_count-1))`
	do
		eth_info=$(echo $ip_a|jq ".[$eth_indx]" -r)
		addresses_info=$(echo $eth_info|jq '.addr_info' -r)
		addr_count=$(echo $addresses_info|jq 'length')

		for addr_indx in `seq 0 $(($addr_count-1))`
		do
			addr_info=$(echo $addresses_info|jq ".[$addr_indx]" -r)
			addr_family=$(echo $addr_info|jq '.family' -r)
			addr_ip=$(echo $addr_info|jq '.local' -r)

			if [ $addr_family = "inet" ] && [ $addr_ip = $host ]
			then
				exe_localy=1
				break
			fi
		done
	done

	echo "Exec: $cmd"

	if [ $exe_localy -eq '1' ]
	then
		eval $cmd
	else
		sshpass -p $pass ssh "$user@$host" "$cmd"
	fi
}

#exe_on_host "10.10.10.2" "root" "1234" "ls -lash"
#echo "\n"
#exe_on_host "10.10.10.3" "root" "1234" "ls"

#exit 1
