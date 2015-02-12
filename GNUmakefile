BOXES=smartos-barebones-virtualbox.box smartos-barebones.ovf \
	smartos-barebones-disk1.vmdk smartos-barebones-disk2.vmdk \
	smartos-base64-virtualbox.box
SEED_NAME=smartos-seed

all: $(BOXES)

clean:
	rm -rvf output-virtualbox-* packer_cache smartos-latest-USB.img \
		smartos-latest-USB.vmdk $(SEED_NAME)* $(BOXES)
	# --> Errors from VBoxManage below are expected, so do not be alarmed...
	vboxmanage unregistervm $(SEED_NAME) --delete || true

download:
	for suffix in .iso -USB.img.bz2; do \
		curl -z smartos-latest$$suffix -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest$$suffix ; \
	done

download-resume:
	for suffix in .iso -USB.img.bz2; do \
		curl -C - -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest$$suffix ; \
	done

smartos-latest-USB.img: smartos-latest-USB.img.bz2
	bzip2 -dk $<

%.vmdk: %.img
	vboxmanage convertfromraw $< $@ --format VMDK

$(SEED_NAME).ovf: smartos-latest-USB.vmdk
	vboxmanage createvm --name $(SEED_NAME) --ostype Solaris11_64 --register
	vboxmanage modifyvm $(SEED_NAME) --memory 1024 --acpi on --pae on --cpus 2 \
		--boot1 dvd --boot2 disk --nic1 nat --audio none --clipboard disabled \
		--usb on
	vboxmanage storagectl $(SEED_NAME) --name ide0 --add ide --portcount 2 --bootable on
	vboxmanage storageattach $(SEED_NAME) --storagectl ide0 --port 0 --device 0 --type hdd \
		--medium $< --mtype immutable
	vboxmanage export $(SEED_NAME) --output $@
	vboxmanage unregistervm $(SEED_NAME) --delete

smartos-barebones-virtualbox.box: smartos-barebones.json $(SEED_NAME).ovf provision_barebones.bash
	packer build $<

smartos-barebones.ovf: smartos-barebones-virtualbox.box
	mv output-virtualbox-ovf/$@ output-virtualbox-ovf/*.vmdk .
	touch $@
	rmdir output-virtualbox-ovf

smartos-base64-virtualbox.box: smartos-base64.json smartos-barebones.ovf provision_base64.bash
	packer build $<

integrate: smartos-barebones-virtualbox.box smartos-base64-virtualbox.box
	for vm in barebones base64; do \
		vagrant destroy -f $$vm ; \
		vagrant box add smartos-$${vm}-virtualbox.box --name smartos-$${vm} --force ; \
	done

.PHONY: download clean integrate
.SECONDARY: smartos-latest-USB.vmdk

# vim:noet:
