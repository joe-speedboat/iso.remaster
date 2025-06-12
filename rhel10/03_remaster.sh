#!/bin/bash

test -f env.sh || echo ERROR: env.sh is missing
test -f env.sh || exit 1
source env.sh

cd $BASE_DIR || (echo BASE_DIR=$BASE_DIR not found ; exit 1)
test -f $BASE_DIR/inject/ks-custom_rhel10.cfg || ( echo kickstart not found ; exit 1)
test -f $BASE_DIR/inject/ks_efi-custom_rhel10.cfg || ( echo kickstart not found ; exit 1)

echo RHEL REMASTER SCRIPT
echo have you reviewed and modified scripts as needed, press enter or ctrl-c
echo

ls -l $BASE_DIR/inject/*
echo

read x
echo "inject kickstart into iso-remaster"
rsync -av $BASE_DIR/inject/* $BASE_DIR/iso-remaster/inject/

ISO_NAME="$(cat $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg | grep no-floppy | cut -d\' -f2)"

#---------- LEGACY BIOS MENU CONFIG ----------
grep -q "ks-custom_rhel10.cfg" $BASE_DIR/iso-remaster/boot/grub2/grub.cfg 
if [ $? -ne 0 ]
then
  echo "inject efi setup menu entry"
  awk -v proj="$PROJ_NAME" -v iso="$ISO_NAME" -v proj_cfg="ks-custom_rhel10.cfg" 'flag==0 && /^menuentry / {print "menuentry '\''"proj"'\'' --class fedora --class gnu-linux --class gnu --class os {\n        linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=''"iso"'' inst.ks=cdrom:/inject/''"proj_cfg"''\n        initrd /images/pxeboot/initrd.img\n}\n"; print; flag=1; next} 1' $BASE_DIR/iso-remaster/boot/grub2/grub.cfg > $BASE_DIR/temp && mv -f $BASE_DIR/temp $BASE_DIR/iso-remaster/boot/grub2/grub.cfg
else
  echo "legacy setup menu entry is existing"
fi

echo "insert/update installer date dummy entry into legacy bios menu"
egrep -q 'BUILD_DATE: ' iso-remaster/boot/grub2/grub.cfg || sed -i '/^set timeout.*/a \menuentry "'"BUILD_DATE: $DATE"'" { return }' $BASE_DIR/iso-remaster/boot/grub2/grub.cfg
egrep -q 'BUILD_DATE: ' iso-remaster/boot/grub2/grub.cfg && sed -i 's/.*BUILD_DATE:.*/menuentry "'"BUILD_DATE: $DATE"'" { return }/' $BASE_DIR/iso-remaster/boot/grub2/grub.cfg

#---------- EFI BIOS MENU CONFIG ----------
grep -q "ks_efi-custom_rhel10.cfg" $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg 
if [ $? -ne 0 ]
then
  echo "inject efi setup menu entry"
  awk -v proj="$PROJ_NAME" -v iso="$ISO_NAME" -v proj_cfg="ks_efi-custom_rhel10.cfg" 'flag==0 && /^menuentry / {print "menuentry '\''"proj"'\'' --class fedora --class gnu-linux --class gnu --class os {\n        linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=''"iso"'' inst.ks=cdrom:/inject/''"proj_cfg"''\n        initrdefi /images/pxeboot/initrd.img\n}\n"; print; flag=1; next} 1' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg > $BASE_DIR/temp && mv -f $BASE_DIR/temp $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg
else
  echo "efi setup menu entry is existing"
fi

echo "insert/update installer date dummy entry into efi bios menu"
egrep -q 'BUILD_DATE: ' iso-remaster/EFI/BOOT/grub.cfg || sed -i '/^set timeout.*/a \menuentry "'"BUILD_DATE: $DATE"'" { return }' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg
egrep -q 'BUILD_DATE: ' iso-remaster/EFI/BOOT/grub.cfg && sed -i 's/.*BUILD_DATE:.*/menuentry "'"BUILD_DATE: $DATE"'" { return }/' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg


#---------- REMASTER ISO IMAGE ----------
cd $BASE_DIR/iso-remaster
xorriso -as mkisofs -o $DST_ISO -b images/eltorito.img -J -R -l -no-emul-boot -boot-load-size 4 \
  -boot-info-table -eltorito-alt-boot -e images/efiboot.img \
  -no-emul-boot -graft-points -joliet-long -V "$ISO_NAME" .


implantisomd5 $DST_ISO


ls -altrh $DST_ISO
umount -fl $BASE_DIR/iso-mount/ || true
echo done
