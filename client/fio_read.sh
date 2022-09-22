#!/bin/bash

sudo fio --name=SSD --ioengine=libaio --blocksize=4k --readwrite=randread --buffered=0 --iodepth=8 --numjobs=16 --time_based=1 --runtime=30 --group_reporting --filename=$1
