#!/bin/bash

BASE_DIR=/srv/iso.remaster/rocky9

RC=0
test -f $BASE_DIR/inject/ks-custom_rocky9.cfg || ( echo "error kickstart not found" ; exit 1 )
test -f $BASE_DIR/inject/ks_efi-custom_rocky9.cfg || ( echo "error kickstart not found" ; exit 1 )

cp -a $BASE_DIR/inject/ks-custom_rocky9.cfg $BASE_DIR/inject/ks-custom_rocky9.cfg.orig
cp -a $BASE_DIR/inject/ks_efi-custom_rocky9.cfg $BASE_DIR/inject/ks_efi-custom_rocky9.cfg.orig

echo "INFO: Set Grub password in kickstart"
read -sp "Enter Grub Password: " grub_pw
echo 
GRUB_HASH=$(echo -e "$grub_pw\n$grub_pw" | grub2-mkpasswd-pbkdf2 | awk '/PBKDF2/ {print $NF}')
sed -i "s|^bootloader --password.*|bootloader --password=$GRUB_HASH --iscrypted|" $BASE_DIR/inject/*.cfg

echo "INFO: Set root password in kickstart"
read -sp "Enter new root password: " root_pw
echo
root_hash=$(openssl passwd -6 "$root_pw")
sed -i "s|^usermod -p .* root|usermod -p '$root_hash' root|" $BASE_DIR/inject/*.cfg
echo passwords changed

echo
echo show diff

echo "--- $BASE_DIR/inject/ks-custom_rocky9.cfg*"
diff $BASE_DIR/inject/ks-custom_rocky9.cfg*
echo "--- $BASE_DIR/inject/ks_efi-custom_rocky9.cfg*"
diff $BASE_DIR/inject/ks_efi-custom_rocky9.cfg*
rm -f $BASE_DIR/inject/*.cfg.orig
echo "------"
echo done
