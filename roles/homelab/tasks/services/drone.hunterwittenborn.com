- name: Stop Drone CI if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/drone.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Drone CI service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "drone/docker-compose.yml.j2", "dest": "/var/www/drone.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "drone/service.sh.j2", "dest": "/var/www/drone.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Drone CI
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/drone.hunterwittenborn.com"

- name: Bring Drone CI up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/drone.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
