#!/bin/bash

sudo modprobe nvme-tcp

sudo nvme connect -t tcp -n nqn.2016-06.sw.ha:node2 -a 192.168.0.103 -s 4430
