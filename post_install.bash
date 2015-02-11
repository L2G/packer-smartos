#!/bin/bash

# Install base64 14.3.0 zone image
zone_image_id=$(imgadm avail | awk '{if ($2 == "base64" && $3 == "14.3.0") print $1}')
imgadm import ${zone_image_id}

# Create a zone
cat >/usbkey/vagrant-guest.json <<EOF
{
  "brand": "joyent",
  "image_uuid": "${zone_image_id}",
  "alias": "vagrant-guest",
  "hostname": "vagrant-guest",
  "autoboot": true
}
EOF

vmadm create -f /usbkey/vagrant-guest.json && rm /usbkey/vagrant-guest.json
