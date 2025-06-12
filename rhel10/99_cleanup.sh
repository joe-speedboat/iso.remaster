#!/bin/bash

test -f env.sh || echo ERROR: env.sh is missing
test -f env.sh || exit 1
source env.sh

set -e
cd $BASE_DIR/ || (echo project dir not found ; exit 1)

umount -fl $BASE_DIR/iso-mount/ || true

rm -frv $BASE_DIR/iso-remaster $BASE_DIR/iso-mount

rm -fv $BASE_DIR/*.iso

echo done
