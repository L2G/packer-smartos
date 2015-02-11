#!/bin/bash

# Set up a virtual NIC for use by Vagrant boxes that build upon this one
eth_mac=$(dladm show-phys -m | awk '!/ADDRESS/ {print $3}')
echo "vagrant_nic=${eth_mac}" >> /usbkey/config
echo "vagrant0_ip=dhcp" >> /usbkey/config