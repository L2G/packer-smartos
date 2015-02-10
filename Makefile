all: smartos_virtualbox.box

download:
	curl -z smartos-latest.iso -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos-latest.iso

clean:
	rm -rvf output-virtualbox-iso packer_cache

smartos_virtualbox.box: smartos-latest.json smartos-latest.iso Vagrantfile.template
	packer build $<

.PHONY: download clean

# vim:noet:
