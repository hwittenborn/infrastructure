- name: Stop Shlink if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/shlink.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Shlink service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "shlink/docker-compose.yml.j2", "dest": "/var/www/shlink.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "shlink/service.sh.j2", "dest": "/var/www/shlink.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Shlink
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/shlink.hunterwittenborn.com"

- name: Bring Shlink up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/shlink.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
