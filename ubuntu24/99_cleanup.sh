#!/bin/bash


test -f env.sh || echo ERROR: env.sh is missing
test -f env.sh || exit 1
source env.sh

cd $BASEDIR || exit 1
rm -rfv $WORK_DIR $BASEDIR/remaster.sh.hint $ISO_DST $ISO_SRC

