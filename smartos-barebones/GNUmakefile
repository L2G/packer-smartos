all: smartos-barebones-virtualbox.box

Vagrantfile: generate_vagrantfile.bash
	./$< > $@

smartos-barebones-virtualbox.box: smartos-barebones.json provision_barebones.bash \
                                  ../$(SEED_NAME).ovf Vagrantfile
	packer build $<

install: smartos-barebones-virtualbox.box
	vagrant box add $< --name smartos-barebones --force

clean:
	-rm -rvf output-virtualbox-ovf Vagrantfile
	-vboxmanage unregistervm smartos-barebones --delete

.PHONY: all clean install

# vim:noet:
