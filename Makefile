BOXES=smartos_virtualbox.box

all: $(BOXES)

clean:
	rm -rvf output-virtualbox-iso packer_cache $(BOXES)

download:
	for suffix in .iso -USB.img.bz2; do \
		curl -z smartos-latest$$suffix -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest$$suffix ; \
	done

smartos-latest-USB.img: smartos-latest-USB.img.bz2
	bzip2 -dk $<

%.vmdk: %.img
	vboxmanage convertfromraw $< $@ --format VMDK

smartos-seed.ovf: smartos-latest-USB.vmdk
	vboxmanage createvm --name $* --ostype Solaris11_64 --register
	vboxmanage modifyvm $* --memory 1024 --acpi on --pae on --cpus 2 \
		--boot1 dvd --boot2 disk --nic1 nat --audio none --clipboard disabled \
		--usb on
	vboxmanage storagectl $* --name ide0 --add ide --portcount 2 --bootable on
	vboxmanage storageattach $* --storagectl ide0 --port 0 --device 0 --type hdd \
		--medium $<
	vboxmanage export $* --output $@
	vboxmanage unregistervm $* --delete

smartos_virtualbox.box: smartos-latest.json smartos-seed.ovf Vagrantfile.template post_install.bash
	packer build smartos-latest.json

integrate: $(BOXES)
	vagrant destroy -f
	vagrant box add smartos_virtualbox.box --name smartos --force
	vagrant up

.PHONY: download clean integrate
.SECONDARY: smartos-latest-USB.vmdk

# vim:noet:
