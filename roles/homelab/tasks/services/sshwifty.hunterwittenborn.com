- name: Create directory for Sshwifty if it doesn't exist
  ansible.builtin.file:
    path: "/var/www/sshwifty.hunterwittenborn.com"
    state: "directory"

- name: Stop Sshwifty if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/sshwifty.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Sshwifty service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "sshwifty/docker-compose.yml.j2", "dest": "/var/www/sshwifty.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "sshwifty/sshwifty.conf.json.j2", "dest": "/var/www/sshwifty.hunterwittenborn.com/sshwifty.conf.json", "owner": "root", "mode": "666"},
    {"src": "sshwifty/sshwifty.ed25519.j2", "dest": "/var/www/sshwifty.hunterwittenborn.com/sshwifty.ed25519", "owner": "root", "mode": "666"},
    {"src": "sshwifty/service.sh.j2", "dest": "/var/www/sshwifty.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Sshwifty
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/sshwifty.hunterwittenborn.com"

- name: Bring Sshwifty up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/sshwifty.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
