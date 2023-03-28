#! /bin/sh

# https://www.cyberciti.biz/faq/how-to-add-ssh-public-key-to-qcow2-linux-cloud-images-using-virt-sysprep/
# https://ostechnix.com/create-a-kvm-virtual-machine-using-qcow2-image-in-linux/
# http://thomasmullaly.com/2014/11/16/the-list-of-os-variants-in-kvm/
# https://www.cyberciti.biz/faq/howto-linux-delete-a-running-vm-guest-on-kvm/

virt-install \
--name=caladan \
--virt-type=kvm \
--memory=4096,maxmemory=4096 \
--vcpus=2,maxvcpus=2 \
--cpu host \
--os-variant=openbsd7.2 \
--import \
--disk /var/lib/libvirt/images/openbsd.qcow2
--network=bridge=virbr0,model=virtio \
--graphics=vnc \
--disk path=/var/lib/libvirt/images/caladan.qcow2,size=40,bus=virtio,format=qcow2

