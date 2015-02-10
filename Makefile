all: clean smartos_virtualbox.box

smartos-latest.iso:
	curl -z $@ -LO https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/$@

clean:
	rm -rvf output-virtualbox-iso

smartos_virtualbox.box: smartos-latest.json smartos-latest.iso Vagrantfile.template
	packer build $<

.PHONY: smartos-latest.iso box clean

# vim:noet:
