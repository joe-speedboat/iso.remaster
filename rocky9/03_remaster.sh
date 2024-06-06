#!/bin/bash

DATE=$(date +%Y%m%d%H%M)
MENU_TITLE="Rocky Linux 9.4 - Custom v$DATE"
PROJ_NAME="INSTALL CIS L1 Rocky 9 OS"
BASE_DIR=/srv/iso.remaster/rocky9
DST_ISO="$BASE_DIR/remastered-custom_rocky9-$DATE.iso"

cd $BASE_DIR || (echo BASE_DIR=$BASE_DIR not found ; exit 1)
test -f $BASE_DIR/inject/ks-custom_rocky9.cfg || ( echo kickstart not found ; exit 1)
test -f $BASE_DIR/inject/ks_efi-custom_rocky9.cfg || ( echo kickstart not found ; exit 1)

echo ROCKY REMASTER SCRIPT
echo have you reviewed and modified scripts as needed, press enter or ctrl-c
echo

ls -l $BASE_DIR/inject/*
echo

read x
echo "inject kickstart into iso-remaster"
rsync -av $BASE_DIR/inject/* $BASE_DIR/iso-remaster/inject/


ISO_NAME="$(cat $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg | grep no-floppy | cut -d\' -f2)"

#---------- EFI BIOS MENU CONFIG ----------
grep -q "ks_efi-custom_rocky9.cfg" $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg 
if [ $? -ne 0 ]
then
  echo "inject efi setup menu entry"
  awk -v proj="$PROJ_NAME" -v iso="$ISO_NAME" -v proj_cfg="ks_efi-custom_rocky9.cfg" 'flag==0 && /^menuentry / {print "menuentry '\''"proj"'\'' --class fedora --class gnu-linux --class gnu --class os {\n        linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=''"iso"'' inst.ks=cdrom:/inject/''"proj_cfg"''\n        initrdefi /images/pxeboot/initrd.img\n}\n"; print; flag=1; next} 1' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg > $BASE_DIR/temp && mv -f $BASE_DIR/temp $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg
else
  echo "efi setup menu entry is existing"
fi

echo "insert/update installer date dummy entry into efi bios menu"
egrep -q 'BUILD_DATE: ' iso-remaster/EFI/BOOT/grub.cfg || sed -i '/^set timeout.*/a \menuentry "'"BUILD_DATE: $DATE"'" { return }' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg
egrep -q 'BUILD_DATE: ' iso-remaster/EFI/BOOT/grub.cfg && sed -i 's/.*BUILD_DATE:.*/menuentry "'"BUILD_DATE: $DATE"'" { return }/' $BASE_DIR/iso-remaster/EFI/BOOT/grub.cfg


#---------- LEGACY BIOS MENU CONFIG ----------
grep -q 'label linux-custom_rocky9' $BASE_DIR/iso-remaster/isolinux/isolinux.cfg 
if [ $? -ne 0 ]
then
  echo "insert boot loader entry for legacy bios"
  sed -i "/^label linux/i label linux-custom_rocky9\n  menu label ^$PROJ_NAME\n  kernel vmlinuz\n  append initrd=initrd.img inst.stage2=hd:LABEL=$ISO_NAME inst.ks=cdrom:/inject/ks-custom_rocky9.cfg\n" $BASE_DIR/iso-remaster/isolinux/isolinux.cfg
else
  echo "boot loader entry for legacy bios is already present"
fi
  
echo "update installer menu title for legacy bios"
sed -i "s/^menu title .*/menu title $MENU_TITLE/" $BASE_DIR/iso-remaster/isolinux/isolinux.cfg

#---------- REMASTER ISO IMAGE ----------
cd $BASE_DIR/iso-remaster
mkisofs -o $DST_ISO  -b isolinux/isolinux.bin -J -R -l -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -graft-points -joliet-long -V "$ISO_NAME" .

isohybrid --uefi $DST_ISO
implantisomd5 $DST_ISO


ls -altrh $DST_ISO
umount -fl $BASE_DIR/iso-mount/ || true
echo done
