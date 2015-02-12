# packer-smartos

Build Vagrant/VirtualBox images of SmartOS with Packer driven by GNU Make

## Tools you'll need

- [curl](http://curl.haxx.se/)
- [GNU Make](https://www.gnu.org/software/make/)
- [Packer](https://www.packer.io/)
- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)

## Tee-ell-dee-are (quick start)

Substitute `gmake` for `make` if necessary on your system.

```
make download
make
```

## Under the hood

1. The latest USB- and ISO-formatted live images for SmartOS are [downloaded from Joyent](https://wiki.smartos.org/display/DOC/Download+SmartOS).
2. A "seed" VM named "smartos-seed" is created in VirtualBox from the USB image and exported as an OVF image.
  - This is done directly with the VirtualBox tools rather than Packer, which at this writing does not have a VirtualBox builder that can start from an arbitrary filesystem image.
  - While Packer does have a "virtualbox-iso" builder, it does not include the ISO image in the finished build, and SmartOS still needs that image for booting (this is the convention in the SmartOS world). Whether we include the ISO or USB image in the build, contortions are required either way, but using the USB image seems to simplify later steps in the process.
3. A box named "smartos-barebones" is built from the "smartos-seed" image. It simply adds a persistent disk in parallel to the live-boot disk, just like in the real world.
4. A box named "smartos-base64" is built from the "smartos-barebones" box. It downloads and installs the "base64" zone image from Joyent and saves the result as a new box. This build is a work in progress (see "Known issues" below).

## Useful targets for `make`

(Or `gmake`, as the case may be.)

- `all` - Simply build the smartos-barebones and smartos-base64 boxes. This is the default. However, it will quickly fail if you haven't run `make download` yet.
- `clean` - Remove all built boxes and intermediate files (_not_ downloads) from the filesystem, and remove the smartos-seed box from VirtualBox in case it is still installed.
- `download` - Use Curl to check for and download new SmartOS live images.
- `download-resume` - Use Curl to resume a download interrupted in the middle. To check for and download new images, use `make download` instead.
- `install` - Install the base boxes in Vagrant. (`install-barebones` and `install-base64` are also available.) They can then be used with the included Vagrantfile.

## Known issues

**The smartos-base64 box is not built successfully.** This is kind of important to fix. :smile_cat:

**The smartos-barebones box is not a true Vagrant box.** It represents the SmartOS global zone. It does not have a "vagrant" user because it is not customary to add extra users or software directly to the global zone.

**The ISO image is not used for anything.** This build system is still under development, and there may no longer be a need for the ISO image.

## Just VirtualBox?

Because Packer is used, there is no technical reason not to support any other "providers" that Packer supports, but there are more basic reasons for not doing so:
- VMware: I don't have access to VMware Fusion, and Joyent already provides a ready-to-use VMware image (but there is still a need for a Vagrant box).
- Parallels: I don't have access to Parallels Desktop.
- Docker: Because SmartOS itself claims to support Docker containers now, this seems a little perverse.
- Amazon EC2, DigitalOcean, Google Compute Engine, OpenStack: Now, that is just crazy talk.
