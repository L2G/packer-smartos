#!/bin/bash

# Make script errors fatal
set -e

# Install base64 14.3.0 zone image
zone_image_id=$(imgadm avail | awk '{if ($2 == "base64" && $3 == "14.3.0") print $1}')
imgadm import ${zone_image_id}

# Create a zone
vm_json_file=/usbkey/vagrant-guest.json
cat >${vm_json_file} <<EOF
{
  "brand": "joyent",
  "image_uuid": "${zone_image_id}",
  "alias": "vagrant-base64",
  "hostname": "vagrant-base64",
  "autoboot": true,
  "resolvers": ["10.0.2.3"],
  "maintain_resolvers": true,
  "nics": [
    {
      "nic_tag": "vagrant",
      "ip": "dhcp"
    }
  ]
}
EOF

# Catch any stupid mistakes
vmadm validate create -f ${vm_json_file}

# Make errors non-fatal again
set +e

# This almost never works on the first 4 or 5 tries, so we try 10 times
for attempt in {1..10}; do
  echo "Creating OS VM (attempt $attempt of 10)..."
  if vmadm create -f ${vm_json_file}; then break
  else
    echo "Fail! Mopping up..."
    vmadm delete $(vmadm list -po uuid)
  fi
done

# Check to make sure the VM got installed and is running
vmadm list | grep -q running

# Make script errors fatal again
set -e

# Send a script to the VM
vagrant_vm=$(vmadm list -po uuid)
zlogin -i $vagrant_vm /bin/bash -c '
  useradd -d /vagrant -m vagrant
'
