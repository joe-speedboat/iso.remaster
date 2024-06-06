* After Setup, apply cis level1 ansible role
  * https://github.com/ansible-lockdown
  ```
  cd /etc/ansible
  ansible-galaxy role search MindPointGroup | grep ubuntu
  ansible-galaxy role install MindPointGroup.ubuntu24_cis,xxx
  cd roles/MindPointGroup.ubuntu24_cis/
  ansible-galaxy install -r collections/requirements.yml
  cd - 
  # run ansible role against new template vm 
  echo '
  ---
  # Ubuntu CIS L1 Hardening
  - hosts: ubuntu24
    become: true
    vars:
      ubtu24cis_level_1: true
      ubtu24cis_level_2: false
      ubtu24cis_uses_root: true
      setup_audit: false
      run_audit: false
      ubtu24cis_ufw_allow_out_ports: "all" # we do not restrict outgoing ports on host
      ubtu24cis_rule_1_4_1: False #grub password test
      ubtu24cis_rule_1_4_3: False #grub shadow pw
      ubtu24cis_config_aide: False
      ubtu24cis_install_network_manager: False # we keep netplan
      ubtu24cis_time_sync_tool: "chrony"
      ubtu24cis_time_pool:
        - name: ch.pool.ntp.org
          options: iburst maxsources 4
    roles:
      - role: MindPointGroup.ubuntu24_cis
  ' > harden_cis_l1_ubuntu24.yml
  ```
