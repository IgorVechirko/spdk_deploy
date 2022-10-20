#!/bin/bash

. ./base.sh


echo "Killing target..."

sudo ps -ax | grep $(get_node $1 "exe_name") | grep -v grep | awk '{print $1}' | sudo xargs kill -9
