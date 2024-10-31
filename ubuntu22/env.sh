
BASEDIR="/srv/iso.remaster/ubuntu22"
AUTOINSTALL="$BASEDIR/autoinstall-user-data"
ISO_SRC="$BASEDIR/ubuntu-22.04.5-live-server-amd64.iso"
ISO_DST="$BASEDIR/ubuntu-22.04-autoinstall-amd64-$(date +%Y%m%d).iso"
ISO_URL="https://releases.ubuntu.com/jammy/$(basename $ISO_SRC)"
WORK_DIR="$BASEDIR/build"
MENU_TITLE="INSTALL Ubuntu 22.04 LTS AUTO - $(date +%Y%m%d)"

