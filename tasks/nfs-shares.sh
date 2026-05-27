# Install nfs-common, add and mount network shares

if ! which nfsstat &> /dev/null ; then
    sudo apt-get install -y nfs-common
fi

SHARES=(
  "10.0.14.13:/storage /mnt/storage"
  "10.0.14.13:/backups /mnt/backups"
  "10.0.14.13:/cdn     /mnt/cdn"
)

FSTAB=$( < /etc/fstab)
for item in "${SHARES[@]}"; do
  read -r remote mount_point <<< "$item"
  if [[ $FSTAB =~ ${remote} ]]; then
    continue
  fi
  echo -e "$remote \t$mount_point \tnfs \tdefaults \t0 \t0" | sudo tee -a /etc/fstab
done

sudo mount -a
