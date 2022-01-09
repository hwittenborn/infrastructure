- name: Stop Bitwarden if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/bitwarden.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Bitwarden service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "bitwarden/docker-compose.yml.j2", "dest": "/var/www/bitwarden.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "bitwarden/service.sh.j2", "dest": "/var/www/bitwarden.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Bitwarden
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/bitwarden.hunterwittenborn.com"

- name: Bring Bitwarden up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/bitwarden.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
