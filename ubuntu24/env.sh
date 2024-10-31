
BASEDIR="/srv/iso.remaster/ubuntu24"
AUTOINSTALL="$BASEDIR/autoinstall-user-data"
ISO_SRC="$BASEDIR/ubuntu-24.04.1-live-server-amd64.iso"
ISO_URL="https://releases.ubuntu.com/noble/$(basename $ISO_SRC)"
ISO_DST="$BASEDIR/ubuntu-24.04-autoinstall-amd64-$(date +%Y%m%d).iso"
WORK_DIR="$BASEDIR/build"
MENU_TITLE="INSTALL Ubuntu 24.04 LTS AUTO - $(date +%Y%m%d)"

