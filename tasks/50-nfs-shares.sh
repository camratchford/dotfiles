# Install nfs-common, add and mount network shares

if ! which nfsstat &> /dev/null ; then
    sudo apt-get install -y nfs-common
fi

SHARES=(
  "10.0.14.13:/storage  /mnt/storage"
  "10.0.14.13:/backups  /mnt/backups"
  "10.0.14.13:/cdn      /mnt/cdn"
)

FSTAB=$( < /etc/fstab)
for item in "${SHARES[@]}"; do
  PADDING_LEN=$(echo "$item" | tr -d -c ' ' | wc -c)
  printf -v padding "%${PADDING_LEN}s" ""
  read -r remote mount_point <<< "$item"

  if [[ $FSTAB =~ ${remote} ]]; then
    continue
  fi
  sudo mkdir "$mount_point"
  echo -e "$remote${padding}$mount_point${padding}nfs defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
done

sudo mount -a
