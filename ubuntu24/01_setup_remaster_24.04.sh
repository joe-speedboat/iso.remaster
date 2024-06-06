#!/bin/bash
# https://www.pugetsystems.com/labs/hpc/ubuntu-22-04-server-autoinstall-iso/

# PREREQ RPMS, REMASTERING TESTED WITH ROCKY9
# dnf install p7zip p7zip-plugins wget xorriso

BASEDIR="/srv/iso.remaster/ubuntu24"
AUTOINSTALL="$BASEDIR/autoinstall-user-data"
ISO_SRC="$BASEDIR/ubuntu-24.04-live-server-amd64.iso"
ISO_DST="$BASEDIR/ubuntu-24.04-autoinstall-amd64.iso"
WORK_DIR="$BASEDIR/build"
MENU_TITLE="INSTALL Ubuntu 24.04 LTS AUTO"


echo "DOWNLOAD ISO IF NEEDED"
test -f $ISO_SRC || curl https://releases.ubuntu.com/noble/$(basename $ISO_SRC) --output $ISO_SRC || exit 1

ISO_NAME="$(file $ISO_SRC | cut -d\' -f2)"
test -d "$WORK_DIR" 
if [ $? -eq 0 ]
then
  echo
  echo
  echo "ERROR: WORK_DIR=$WORK_DIR does exist, delete it first to start over"
  echo "TRY: bash 99_cleanup.sh"
  echo "... and start over"
  exit 1
fi

mkdir -p "$WORK_DIR"

test -f $ISO_SRC || exit 1
test -f $AUTOINSTALL || exit 1
cd $WORK_DIR || exit 1


echo "EXTRACTING ISO"
mkdir $WORK_DIR/source-files
7z -y x $ISO_SRC -o$WORK_DIR/source-files || exit 1


echo "MOVE BOOT DIR"
test -d $WORK_DIR/source-files/BOOT || mv -v $WORK_DIR/source-files/\[BOOT\] $WORK_DIR/BOOT

grep -q nocloud source-files/boot/grub/grub.cfg
if [ $? -ne 0 ]
then
  echo "UPDATE GRUB CONFIG IN CUSTOM CD IMAGE SOURCE FILES"
  sed -i "s/Try or Install Ubuntu Server/$MENU_TITLE/" source-files/boot/grub/grub.cfg
  sed -i 's#linux.*/casper/vmlinuz.*#linux   /casper/vmlinuz quiet autoinstall ds=nocloud\\;s=/cdrom/server/  ---#' source-files/boot/grub/grub.cfg
fi

mkdir $WORK_DIR/source-files/server
touch $WORK_DIR/source-files/server/meta-data

test -f $WORK_DIR/source-files/server/user-data || cp -av $AUTOINSTALL $WORK_DIR/source-files/server/user-data


xorriso -indev $ISO_SRC -report_el_torito as_mkisofs 2>&1 | sed '1,/Volume id/d' > tmp_sh

sed -i 's/$/ \\/' tmp_sh
echo . >> tmp_sh

echo "cd $WORK_DIR/source-files || exit 1
test -f boot.catalog || exit 1
test -f $ISO_DST && rm -fv $ISO_DST
xorriso -as mkisofs -r \\
-o $ISO_DST \\
" > $BASEDIR/remaster.sh.hint
cat tmp_sh >> $BASEDIR/remaster.sh.hint
rm -fv tmp_sh


echo "FINISHED SETUP OF REMASTER ENV
- review remaster.sh.template, but 03_remaster.sh should be ready out of the box
  vimdiff $BASEDIR/03_remaster.sh $BASEDIR/remaster.sh.hint
- review autoinstall file
  vim $AUTOINSTALL
- update passwords for Grub and root
  bash 02_change_passwords.sh
- build custom iso
  bash 03_remaster.sh
- Test and keep custom iso: $ISO_DST
- Cleanup all except custom files
  99_cleanup.sh
"
