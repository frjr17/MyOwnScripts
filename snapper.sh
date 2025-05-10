#!/bin/bash

sudo dnf install snapper libdnf5-plugin-actions btrfs-assistant inotify-tools git make

sudo bash -c "cat > /etc/dnf/libdnf5-plugins/actions.d/snapper.actions" <<'EOF'
# Get snapshot description
pre_transaction::::/usr/bin/sh -c echo\ "tmp.cmd=$(ps\ -o\ command\ --no-headers\ -p\ '${pid}')"

# Creates pre snapshot before the transaction and stores the snapshot number in the "tmp.snapper_pre_number"  variable.
pre_transaction::::/usr/bin/sh -c echo\ "tmp.snapper_pre_number=$(snapper\ create\ -t\ pre\ -c\ number\ -p\ -d\ '${tmp.cmd}')"

# If the variable "tmp.snapper_pre_number" exists, it creates post snapshot after the transaction and removes the variable "tmp.snapper_pre_number".
post_transaction::::/usr/bin/sh -c [\ -n\ "${tmp.snapper_pre_number}"\ ]\ &&\ snapper\ create\ -t\ post\ --pre-number\ "${tmp.snapper_pre_number}"\ -c\ number\ -d\ "${tmp.cmd}"\ ;\ echo\ tmp.snapper_pre_number\ ;\ echo\ tmp.cmd
EOF

sudo snapper -c root create-config /
sudo snapper -c home create-config /home

sudo restorecon -RFv /.snapshots
sudo restorecon -RFv /home/.snapshots

sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes

echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf

# Installing grub-btrfs
cd /tmp 
git clone https://github.com/Antynea/grub-btrfs
cd grub-btrfs

sed -i.bkp \
  -e '/^#GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS=/a \
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"' \
  -e '/^#GRUB_BTRFS_GRUB_DIRNAME=/a \
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' \
  -e '/^#GRUB_BTRFS_MKCONFIG=/a \
GRUB_BTRFS_MKCONFIG=/usr/bin/grub2-mkconfig' \
  -e '/^#GRUB_BTRFS_SCRIPT_CHECK=/a \
GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' \
  config

sudo make install
sudo systemctl enable --now grub-btrfsd.service

cd ..
rm -rfv grub-btrfs

# Enabling automatic snapshots
sudo snapper -c home set-config TIMELINE_CREATE=no
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer