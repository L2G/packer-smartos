# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
  end

  %w(barebones base64).each do |flavor|
    config.vm.define flavor do |b|
      b.vm.box = "smartos-#{flavor}"
    end
  end
end
