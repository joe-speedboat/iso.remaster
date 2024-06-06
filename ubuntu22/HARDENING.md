* After Setup, apply cis level1 ansible role
  * https://github.com/ansible-lockdown
  ```
  cd /etc/ansible
  ansible-galaxy role search MindPointGroup | grep ubuntu
  ansible-galaxy role install MindPointGroup.ubuntu22_cis,1.4.0
  cd roles/MindPointGroup.ubuntu22_cis/
  ansible-galaxy install -r collections/requirements.yml
  cd - 
  # run ansible role against new template vm 
  echo '
  ---
  # Ubuntu CIS L1 Hardening
  - hosts: ubuntu22
    become: true
    vars:
      ubtu22cis_level_1: true
      ubtu22cis_level_2: false
      ubtu22cis_uses_root: true
      setup_audit: false
      run_audit: false
      ubtu22cis_ufw_allow_out_ports: "all" # we do not restrict outgoing ports on host
      ubtu22cis_rule_1_4_1: False #grub password test
      ubtu22cis_rule_1_4_3: False #grub shadow pw
      ubtu22cis_config_aide: False
      ubtu22cis_install_network_manager: False # we keep netplan
      ubtu22cis_time_sync_tool: "chrony"
      ubtu22cis_time_pool:
        - name: ch.pool.ntp.org
          options: iburst maxsources 4
    roles:
      - role: MindPointGroup.ubuntu22_cis
  ' > harden_cis_l1_ubuntu22.yml
  ```
