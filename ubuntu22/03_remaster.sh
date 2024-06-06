
BASEDIR="/srv/iso.remaster/ubuntu22"
AUTOINSTALL="$BASEDIR/autoinstall-user-data"
ISO_SRC="$BASEDIR/ubuntu-22.04.4-live-server-amd64.iso"
ISO_DST="$BASEDIR/ubuntu-22.04-autoinstall-amd64.iso"
WORK_DIR="$BASEDIR/build"


cd $BASEDIR/build/source-files || exit 1
test -f boot.catalog || exit 1
test -f $ISO_DST && rm -fv $ISO_DST
xorriso -as mkisofs -r \
-o $ISO_DST \
-V 'Ubuntu-Server 22.04.4 LTS amd64' \
--modification-date="$(date +%Y%m%d%H%M%S00)" \
--grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:"$ISO_SRC" \
--protective-msdos-label \
-partition_cyl_align off \
-partition_offset 16 \
--mbr-force-bootable \
-append_partition 2 0xef --interval:local_fs:4099440d-4109507d::"$ISO_SRC" \
-part_like_isohybrid \
-c '/boot.catalog' \
-b '/boot/grub/i386-pc/eltorito.img' \
-no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
--grub2-boot-info \
-eltorito-alt-boot \
-e '--interval:appended_partition_2_start_1024860s_size_10068d:all::' \
-no-emul-boot \
-boot-load-size 10068 \
-isohybrid-gpt-basdat \
-no-pad \
.
