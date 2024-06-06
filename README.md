# OS Remastering Documentation

This repository contains scripts and configurations for remastering various operating systems to include custom partition layouts and configurations needed for CIS Level 1 compliance.

## Supported Operating Systems

### Ubuntu 22.04
* **Build Host:** Rocky Linux 9
* **ISO Version:** Ubuntu 22.04.4
* **Scripts:**
  - `00_requirements.sh`: Install necessary packages on the build host.
  - `01_setup_remaster_22.04.sh`: Download and prepare the ISO.
  - `02_change_passwords.sh`: Change passwords for root and GRUB.
  - `03_remaster.sh`: Build the remastered ISO.
  - `99_cleanup.sh`: Cleanup script for git checking, backup, etc.
* **Post-Setup:**
  - Apply CIS Level 1 Ansible role from [ansible-lockdown](https://github.com/ansible-lockdown).
  - Run sysprep script from [joe-speedboat](https://raw.githubusercontent.com/joe-speedboat/linux.scripts/master/shell/sysprep.sh).

### Ubuntu 24.04
* **Note:** The Ansible role `MindPointGroup.ubuntu24_cis` is not yet released. This is just a preview to get ready for when the role becomes available.
* **Build Host:** Rocky Linux 9
* **ISO Version:** Ubuntu 24.04
* **Scripts:**
  - `00_requirements.sh`: Install necessary packages on the build host.
  - `01_setup_remaster_24.04.sh`: Download and prepare the ISO.
  - `02_change_passwords.sh`: Change passwords for root and GRUB.
  - `03_remaster.sh`: Build the remastered ISO.
  - `99_cleanup.sh`: Cleanup script for git checking, backup, etc.
* **Post-Setup:**
  - Apply CIS Level 1 Ansible role from [ansible-lockdown](https://github.com/ansible-lockdown) once it is released.
  - Run sysprep script from [joe-speedboat](https://raw.githubusercontent.com/joe-speedboat/linux.scripts/master/shell/sysprep.sh).

### Rocky Linux 9
* **Build Host:** Rocky Linux 9
* **ISO Version:** Rocky Linux 9.4
* **Scripts:**
  - `00_requirements.sh`: Install necessary packages on the build host.
  - `01_setup_remaster_rocky9.sh`: Download and prepare the ISO.
  - `02_change_passwords.sh`: Change passwords for root and GRUB.
  - `03_remaster.sh`: Build the remastered ISO.
  - `99_cleanup.sh`: Cleanup script for git checking, backup, etc.
* **Post-Setup:**
  - Run sysprep script from [joe-speedboat](https://raw.githubusercontent.com/joe-speedboat/linux.scripts/master/shell/sysprep.sh).

### RHEL 9
* **Build Host:** Rocky Linux 9
* **ISO Version:** RHEL 9.4
* **Scripts:**
  - `00_requirements.sh`: Install necessary packages on the build host.
  - `01_setup_remaster_rhel9.sh`: Download and prepare the ISO.
  - `02_change_passwords.sh`: Change passwords for root and GRUB.
  - `03_remaster.sh`: Build the remastered ISO.
  - `99_cleanup.sh`: Cleanup script for git checking, backup, etc.
* **Post-Setup:**
  - Run sysprep script from [joe-speedboat](https://raw.githubusercontent.com/joe-speedboat/linux.scripts/master/shell/sysprep.sh).

## General Steps for Remastering
1. Run `00_requirements.sh` to install necessary packages on the build host.
2. Run the setup script for the specific OS to download and prepare the ISO.
3. Change passwords for root and GRUB using the `02_change_passwords.sh` script.
4. Build the remastered ISO using the `03_remaster.sh` script.
5. Apply the CIS Level 1 Ansible role (if available) and run the sysprep script.
6. Use the `99_cleanup.sh` script to clean up the build environment.
