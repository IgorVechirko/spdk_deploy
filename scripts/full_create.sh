#!/bin/bash

sh kill_tgt.sh $1
sh copy_build.sh $1
sh run_tgt.sh $1
#sh setup_spdk.sh $1


