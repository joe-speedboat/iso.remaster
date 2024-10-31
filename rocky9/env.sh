
BASE_DIR=/srv/iso.remaster/rocky9
DATE=$(date +%Y%m%d%H%M)
DST_ISO="$BASE_DIR/remastered-custom_rocky9-$DATE.iso"
ISO_FILE=Rocky-9.4-x86_64-dvd.iso
ISO_URL="https://mirror.puzzle.ch/rockylinux/9/isos/x86_64/$ISO_FILE"
MENU_TITLE="Rocky Linux 9.4 - $DATE"
PROJ_NAME="INSTALL CIS L1 Rocky 9 OS"
