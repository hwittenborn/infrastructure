- name: Create directory for Vault if it doesn't exist
  ansible.builtin.file:
    path: "/var/www/vault.hunterwittenborn.com"
    state: "directory"

- name: Stop Vault if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/vault.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Vault service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "vault/docker-compose.yml.j2", "dest": "/var/www/vault.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "vault/config.hcl.j2", "dest": "/var/www/vault.hunterwittenborn.com/config.hcl", "owner": "root", "mode": "644"},
    {"src": "vault/unlock_key.j2", "dest": "/var/www/vault.hunterwittenborn.com/unlock_key", "owner": "root", "mode": "644"},
    {"src": "vault/service.sh.j2", "dest": "/var/www/vault.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Vault
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/vault.hunterwittenborn.com"

- name: Bring Vault up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/vault.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
