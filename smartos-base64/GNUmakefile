all: smartos-base64-virtualbox.box

smartos-base64-virtualbox.box: smartos-base64.json provision_base64.bash \
  ../smartos-barebones/output-virtualbox-ovf/smartos-barebones.ovf
	packer build $<

install: smartos-base64-virtualbox.box
	vagrant box add $< --name smartos-base64 --force

clean:
	rm -rvf output-virtualbox-ovf
	vboxmanage unregistervm smartos-base64 --delete

.PHONY: all clean install
.IGNORE: clean

# vim:noet:
