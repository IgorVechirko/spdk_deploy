#!/bin/bash

fio --name=SSD --ioengine=libaio --blocksize=4k --readwrite=randwrite --buffered=0 --iodepth=8 --numjobs=6 --time_based=1 --runtime=500 --group_reporting --filename=$1
