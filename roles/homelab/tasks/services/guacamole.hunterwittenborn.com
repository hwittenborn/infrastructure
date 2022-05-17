- name: Ensure directory for Guacamole exists
  ansible.builtin.file:
    path: "/var/www/guacamole.hunterwittenborn.com"
    state: directory

- name: Stop Guacamole if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/guacamole.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Guacamole service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "guacamole/docker-compose.yml.j2", "dest": "/var/www/guacamole.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "guacamole/service.sh.j2", "dest": "/var/www/guacamole.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Guacamole
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/guacamole.hunterwittenborn.com"

- name: Bring Guacamole up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/guacamole.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
