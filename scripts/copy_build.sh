#!/bin/bash

. ./base.sh


echo "Coping build..."

wget -O $(get_node $1 "ftp_dest_path")$(get_node $1 "exe_name") --ftp-user=$(get_node $1 "ftp_user") --ftp-password=$(get_node $1 "ftp_passwd") $(get_node $1 "bin_ftp_path")$(get_node $1 "exe_name")
