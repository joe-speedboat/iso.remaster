
test -f env.sh || echo ERROR: env.sh is missing
test -f env.sh || exit 1
source env.sh

cd $WORK_DIR || exit 1
echo "UPDATE MENU ENTRY WITH CURRENT PATTERN (DATE)"
sed -i "0,/^menuentry/{s/^menuentry \"[^\"]*\"/menuentry \"$MENU_TITLE\"/}" source-files/boot/grub/grub.cfg

echo REMASTER CD
cd $BASEDIR/build/source-files || exit 1
test -f boot.catalog || exit 1
test -f $ISO_DST && rm -fv $ISO_DST
xorriso -as mkisofs -r \
-o $ISO_DST \
-V 'Ubuntu-Server 24.04.1 LTS amd64' \
--modification-date="$(date +%Y%m%d%H%M%S00)" \
--grub2-mbr --interval:local_fs:0s-15s:zero_mbrpt,zero_gpt:"$ISO_SRC" \
--protective-msdos-label \
-partition_cyl_align off \
-partition_offset 16 \
--mbr-force-bootable \
-append_partition 2 0xef --interval:local_fs:5406916d-5417059d::"$ISO_SRC" \
-part_like_isohybrid \
-c '/boot.catalog' \
-b '/boot/grub/i386-pc/eltorito.img' \
-no-emul-boot \
-boot-load-size 4 \
-boot-info-table \
--grub2-boot-info \
-eltorito-alt-boot \
-e '--interval:appended_partition_2_start_1351729s_size_10144d:all::' \
-no-emul-boot \
-boot-load-size 10144 \
-isohybrid-gpt-basdat \
-no-pad \
.
