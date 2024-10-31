#!/bin/bash


test -f env.sh || echo ERROR: env.sh is missing
test -f env.sh || exit 1
source env.sh

echo "INFO: Set Grub password in autoinstall"
read -sp "Enter Grub Password: " grub_pw
echo
GRUB_HASH=$(echo -e "$grub_pw\n$grub_pw" | grub2-mkpasswd-pbkdf2 | awk '/PBKDF2/ {print $NF}')
sed -i "s#password_pbkdf2 .*#password_pbkdf2 root $GRUB_HASH#" $AUTOINSTALL

echo "INFO: Set root password in autoinstall"
read -sp "Enter new root password: " root_pw
echo
root_hash=$(openssl passwd -6 "$root_pw")
sed -i "s| usermod --password .*| usermod --password \'$root_hash\' root|" $AUTOINSTALL

test -f $WORK_DIR/source-files/server/user-data || echo PROBLEM: $WORK_DIR/source-files/server/user-data not found
test -f $WORK_DIR/source-files/server/user-data && (cp -avfp $AUTOINSTALL $WORK_DIR/source-files/server/user-data ; echo $WORK_DIR/source-files/server/user-data updated)



