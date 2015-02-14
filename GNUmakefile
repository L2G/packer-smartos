SEED_NAME=smartos-seed
export SEED_NAME

all: barebones base64

clean: clean-base64 clean-barebones clean-seed-from-vb
	rm -rvf smartos-latest-USB.img smartos-latest-USB.vmdk $(SEED_NAME)*

clean-seed-from-vb:
	vboxmanage unregistervm $(SEED_NAME) --delete

clean-barebones:
	$(MAKE) -C smartos-barebones clean

clean-base64:
	$(MAKE) -C smartos-base64 clean

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
		--boot1 dvd --boot2 disk \
		--nic1 nat --nic2 nat --nic3 nat --nic4 nat \
		--cableconnected1 on --cableconnected2 on --cableconnected3 on --cableconnected4 on \
		--audio none --clipboard disabled --usb on --vram 16
	vboxmanage storagectl $(SEED_NAME) --name ide0 --add ide --portcount 2 --bootable on
	vboxmanage storageattach $(SEED_NAME) --storagectl ide0 --port 0 --device 0 --type hdd \
		--medium $< --mtype immutable
	vboxmanage export $(SEED_NAME) --output $@
	vboxmanage unregistervm $(SEED_NAME) --delete

barebones:
	$(MAKE) -C smartos-barebones all

base64:
	$(MAKE) -C smartos-base64 all

install: install-barebones install-base64
install-%: %
	$(MAKE) -C smartos-% install

.PHONY: all clean clean-seed-from-db clean-barebones download download-resume \
        barebones base64 install install-barebones install-base64
.SECONDARY: smartos-latest-USB.vmdk
.IGNORE: clean clean-seed-from-vb

# vim:noet:
