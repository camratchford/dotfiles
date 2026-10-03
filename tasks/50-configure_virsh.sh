# Install and configure virt-manager / virsh to use a storage pool at `/virsh` (run zfs task first)

if ! which zfs &> /dev/null ; then
    sudo apt-get install -y virt-manager
fi

virsh pool-destroy default
virsh pool-undefine default

virsh pool-define-as default dir --target /virsh

virsh pool-build default
virsh pool-start default
virsh pool-autostart default

virsh pool-list --all
virsh pool-info default
