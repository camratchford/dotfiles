# Install zfs, select disks to use as a zpool, then configure the zpool with vvols

if ! which zfs &> /dev/null ; then
    sudo apt-get install -y zfsutils-linux
fi

ZFS_POOL_NAME="storage"
ZFS_PARTS="docker virsh projects"
ZFS_PARTS_PARENT="" # "" is root

LINES=$(tput lines)
HEIGHT=$(( LINES / 2  ))
COLUMNS=$(tput cols)
WIDTH=$(( COLUMNS / 2 ))
CHECKLIST_ITEMS=()
VALID_DISKS=()
HAS_MOUNTS=()

while IFS=$' ' read -r path name size type subsystem root; do
  # We're only checking disks and their partitions
  if [[ "$type" != "part" && "$type" != "disk" ]]; then
    continue
  fi
  # Ignore USB drives
  if [[ "$subsystem" =~ "usb" ]]; then
    continue
  fi
  # If the partition is mounted to the filesystem, mark it so we can ignore its disk
  if [[ $type == "part" && $root == "/" ]]; then
    parent=$(echo "$name" | grep -oP "[a-z]{3}")
    if [ -n "$parent"  ]; then
      HAS_MOUNTS+=("$parent")
    fi
  fi
  if [ "$type" == "disk" ]; then
    # If it's a disk and none of it's partitions are mounted, we format the checklist item
    if ! [[ " ${HAS_MOUNTS[*]} " =~ [[:space:]]${name}[[:space:]] ]]; then
      if ! [[ " ${VALID_DISKS[*]} " =~ [[:space:]]${name}[[:space:]] ]]; then
        VALID_DISKS+=("$name")
        CHECKLIST_ITEMS+=("$path" "$name $size" "off")
      fi
    fi
  fi
done < <(lsblk -lo PATH,NAME,SIZE,TYPE,SUBSYSTEMS,FSROOTS |  sort)

CHECKLIST_ITEM_COUNT=${#VALID_DISKS[@]}

POOL_DEVICES=$(whiptail --title "Disks to Format as ZFS Storage Pool" \
  --checklist "Select disks to be wiped and initialized as a ZFS storage pool" \
  "$HEIGHT" "$WIDTH" "$CHECKLIST_ITEM_COUNT" \
  "${CHECKLIST_ITEMS[@]}" 3>&1 1>&2 2>&3
)

if [[ $? != 0 ]]; then
  exit
fi

POOL_DEVICES=$(echo "$POOL_DEVICES" | tr -d '"')

for dev in $POOL_DEVICES; do
  echo "Wiping $dev"
  parted -s $dev mklabel gpt
done

if ! [[ $(zpool list) =~ $ZFS_POOL_NAME ]]; then
  echo "Creating ZFS pool: $ZFS_POOL_NAME"
  sudo zpool create -m none -O compression=lz4 -O dedup=on "$ZFS_POOL_NAME" raidz $POOL_DEVICES
fi
for part in $ZFS_PARTS; do
  part_mount_point="${ZFS_PARTS_PARENT}/${part}"
  part_name="${ZFS_POOL_NAME}/${part}"
  if ! [[ $(zfs list) =~ $part_name ]]; then
    echo "Creating ZFS vvol: $part_name"
    sudo mkdir -p "$part_mount_point"
    sudo zfs create -o mountpoint="$part_mount_point" "$part_name"
    sudo chown "$(logname):$(logname)" "$part_mount_point"
  fi
done

