#!/bin/sh -eux

# Only for use in CentOS 5 which has no UUID

case "$PACKER_BUILDER_TYPE" in
  qemu) exit 0 ;;
esac

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/boot/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /boot/whitespace

# Whiteout the swap partition to reduce box size
# Swap is disabled till reboot
swappart="/dev/mapper/VolGroup00-LogVol01";
/sbin/swapoff "$swappart";
dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
/sbin/mkswap "$swappart";

sync;
