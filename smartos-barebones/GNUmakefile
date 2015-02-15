all: smartos-barebones-virtualbox.box

smartos-barebones-virtualbox.box: smartos-barebones.json provision_barebones.bash \
                                  ../$(SEED_NAME).ovf 
	packer build $<

install: smartos-barebones-virtualbox.box
	vagrant box add $< --name smartos-barebones --force

clean:
	-rm -rvf output-virtualbox-ovf
	-vboxmanage unregistervm smartos-barebones --delete

.PHONY: all clean install

# vim:noet:
