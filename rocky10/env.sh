
BASE_DIR=/srv/iso.remaster/rocky10
DATE=$(date +%Y%m%d%H%M)
DST_ISO="$BASE_DIR/remastered-custom_rocky10-$DATE.iso"
ISO_FILE=Rocky-10.0-x86_64-dvd1.iso
ISO_URL="https://mirror.init7.net/rockylinux/10/isos/x86_64/$ISO_FILE"
MENU_TITLE="Rocky Linux 10.0 - $DATE"
PROJ_NAME="INSTALL CIS L1 Rocky 10 OS"
