- name: Stop Element if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/element.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Element service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "element/docker-compose.yml.j2", "dest": "/var/www/element.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "element/service.sh.j2", "dest": "/var/www/element.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"},
    {"src": "element/config.json.j2", "dest": "/var/www/element.hunterwittenborn.com/data/app/config.json", "owner": "root", "mode": "644"}
  ]

- name: Update Element
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/element.hunterwittenborn.com"

- name: Bring Element up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/element.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
