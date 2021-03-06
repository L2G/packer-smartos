#!/bin/bash

eval $(< ../smartos-seed.macaddrs)

cat <<EOVF
# This file was generated by a script ($0),
# so future changes should be made to that script, not this file.

Vagrant.configure('2') do |config|
  config.vm.provider 'virtualbox' do |v|
    # This attempts to switch the MAC addresses of NICs 1 and 2
    v.customize ['modifyvm', :id, "--nic1", 'nat']
    v.customize ['modifyvm', :id, "--cableconnected1", 'on']
    v.customize ['modifyvm', :id, "--macaddress1", '$macaddress2']

    v.customize ['modifyvm', :id, "--nic2", 'nat']
    v.customize ['modifyvm', :id, "--cableconnected2", 'on']
    v.customize ['modifyvm', :id, "--macaddress2", '$macaddress1']
  end

  config.vm.base_mac = '$macaddress2'
end
EOVF
