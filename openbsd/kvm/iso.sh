#! /bin/sh

# Run as root
# Once running, connect with vncviewer on localhost:5900
# Or else check port with sudo virsh dumpxml openbsd | grep vnc
# Refer to https://www.cyberciti.biz/faq/kvmvirtualization-virt-install-openbsd-unix-guest/
# Make sure you download the ISO image and not the USB image


virt-install \
--name=openbsd \
--virt-type=kvm \
--memory=4096,maxmemory=4096 \
--vcpus=2,maxvcpus=2 \
--cpu host \
--os-variant=openbsd7.0 \
--cdrom=/home/abhishek/var/tmp/downloads/install72.iso \
--network=bridge=virbr0,model=virtio \
--graphics=vnc \
--disk path=/var/lib/libvirt/images/openbsd.qcow2,size=40,bus=virtio,format=qcow2

