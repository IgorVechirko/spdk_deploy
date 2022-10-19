#!/bin/bash

userName="igor"

sudo echo "igor ALL=(ALL:ALL) NOPASSWD: /usr/bin/git" >> /etc/sudoers
sudo echo "igor ALL=(ALL:ALL) NOPASSWD: /usr/bin/gdb" >> /etc/sudoers
sudo echo "igor ALL=(ALL:ALL) NOPASSWD: /usr/bin/make" >> /etc/sudoers
