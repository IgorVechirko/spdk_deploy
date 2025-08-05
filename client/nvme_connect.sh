#!/bin/bash

sudo modprobe nvme-tcp

sudo nvme connect -t tcp -n nqn.2016-06.sw.ha:ha1 -a 40.40.40.3 -s 4420
#sudo nvme connect -t tcp -n nqn.2016-06.sw.ha:ha1 -a 40.40.40.4 -s 4420
#sudo nvme connect -t tcp -n nqn.2016-06.sw.ha:ha1 -a 20.20.20.3 -s 5846


echo "round-robin" > /sys/class/nvme-subsystem/nvme-subsys0/iopolicy
