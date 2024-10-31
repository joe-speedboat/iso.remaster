#!/bin/bash


BASEDIR="/srv/iso.remaster/ubuntu22"
ISO_SRC="$BASEDIR/ubuntu-22.04.4-live-server-amd64.iso"
ISO_DST="$BASEDIR/ubuntu-22.04-autoinstall-amd64.iso"
WORK_DIR="$BASEDIR/build"

cd $BASEDIR || exit 1
rm -rfv $WORK_DIR $BASEDIR/remaster.sh.hint $ISO_DST $ISO_SRC

