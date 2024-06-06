#!/bin/bash
set -e

BASE_DIR=/srv/iso.remaster/rhel9
ISO_FILE=rhel-9.4-x86_64-dvd.iso

echo "Check prereq"
cd $BASE_DIR || (echo BASE_DIR=$BASE_DIR not found ; exit 1)
test -f $BASE_DIR/inject/ks-custom_rhel9.cfg || ( echo error: kickstart not found ; exit 1)
test -f $BASE_DIR/inject/ks_efi-custom_rhel9.cfg || ( echo error: kickstart not found ; exit 1)

RC=0
test -d $BASE_DIR/iso-remaster && RC=1
test -d $BASE_DIR/iso-mount && RC=1
if [ $RC -ne 0 ]
then
  echo
  echo
  echo "ERROR: remaster dir $BASE_DIR/iso-remaster does exist, delete it first to start over"
  echo "TRY: bash 99_cleanup.sh"
  echo "... and start over"
  exit 1
fi
 

echo "Download ISO $ISO_FILE hint"
test -f $BASE_DIR/$ISO_FILE && DL=1 || DL=0
if [ $DL -ne 1 ]
then
   echo "ERROR: ISO_FILE=$BASE_DIR/$ISO_FILE does not exist, please download from RHN first"
   exit 1
else
  echo "INFO: ISO_FILE=$BASE_DIR/$ISO_FILE is present"
fi

echo "Mount iso $BASE_DIR/$ISO_FILE into $BASE_DIR/iso-mount/"
umount -fl $BASE_DIR/iso-mount/ || true
test -d $BASE_DIR/iso-mount && rm -rf $BASE_DIR/iso-mount
mkdir -p $BASE_DIR/iso-mount
mount -o loop $BASE_DIR/$ISO_FILE $BASE_DIR/iso-mount/

echo "Cleanup remaster dir $BASE_DIR/iso-remaster"
rm -fr $BASE_DIR/iso-remaster || true
mkdir $BASE_DIR/iso-remaster

echo "Copy $BASE_DIR/iso-mount/ into $BASE_DIR/iso-remaster/"
shopt -s dotglob
cp -aRf $BASE_DIR/iso-mount/* $BASE_DIR/iso-remaster/
rsync -av $BASE_DIR/inject $BASE_DIR/iso-remaster/

echo done
