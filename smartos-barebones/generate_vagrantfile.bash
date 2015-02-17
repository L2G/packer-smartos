#!/bin/bash

eval $(< ../smartos-seed.macaddrs)

cat <<EOVF
# This file was generated by a script ($0),
# so future changes should be made to that script, not this file.

Vagrant.configure('2') do |config|
  macaddr = [
    nil, '$macaddress1', '$macaddress2', '$macaddress3', '$macaddress4'
  ]

  config.vm.guest = :smartos
  config.vm.base_mac = macaddr[1]
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.ssh.username = 'root'
  config.ssh.password = 'packer'
  config.ssh.insert_key = false

  config.vm.provider 'virtualbox' do |v|
    (1..4).each do |n|
      v.customize ['modifyvm', :id, "--nic#{n}", 'nat']
      v.customize ['modifyvm', :id, "--cableconnected#{n}", 'on']
      v.customize ['modifyvm', :id, "--macaddress#{n}", macaddr[n]]
    end
  end
end
EOVF
