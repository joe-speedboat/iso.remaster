#!/bin/bash
set -e

BASE_DIR=/srv/iso.remaster/rhel9

cd $BASE_DIR/ || (echo project dir not found ; exit 1)

umount -fl $BASE_DIR/iso-mount/ || true

rm -frv $BASE_DIR/iso-remaster $BASE_DIR/iso-mount

rm -fv $BASE_DIR/*.iso

echo done
