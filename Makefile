BOXES=smartos_virtualbox.box

all: $(BOXES)

clean:
	rm -rvf output-virtualbox-iso packer_cache $(BOXES)

download:
	curl -z smartos-latest.iso -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest.iso

smartos_virtualbox.box: smartos-latest.json smartos-latest.iso Vagrantfile.template post_install.bash
	packer build smartos-latest.json

integrate: $(BOXES)
	vagrant destroy -f
	vagrant box add smartos_virtualbox.box --name smartos --force
	vagrant up

.PHONY: download clean integrate

# vim:noet:
