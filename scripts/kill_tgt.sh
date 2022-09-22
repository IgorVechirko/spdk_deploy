#!/bin/bash

vars=$(sudo cat ./vars.json)

get_var() {
	var_val=$(echo $vars|jq ".$1" -r)
	echo $var_val
}

sudo ps -ax | grep $(get_var "exe_name") | grep -v grep | awk '{print $1}' | sudo xargs kill -9
