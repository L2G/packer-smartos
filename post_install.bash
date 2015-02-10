#!/bin/bash

# Install base64 14.3.0 zone image
zone_image_id=$(imgadm avail | awk '{if ($2 == "base64" && $3 == "14.3.0") print $1}')
imgadm import ${zone_image_id}

# Create a zone
cat >vagrant-guest.json <<EOF
{
  "brand": "joyent",
  "image_uuid": "${zone_image_id}",
  "alias": "vagrant-guest",
  "hostname": "vagrant-guest",
  "max_physical_memory": 512
}
EOF

vm_id=$(vmadm create -f vagrant-guest.json | awk '/^Successfully created / {print $3}')
rm vagrant-guest.json
