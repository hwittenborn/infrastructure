- name: Stop Matrix if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "{{ website_dir }}/matrix.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Matrix service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "matrix/docker-compose.yml.j2", "dest": "{{ website_dir }}/matrix.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "matrix/service.sh.j2", "dest": "{{ website_dir }}/matrix.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"},
    {"src": "matrix/homeserver.yaml.j2", "dest": "{{ website_dir }}/matrix.hunterwittenborn.com/data/app/homeserver.yaml", "owner": "root", "mode": "644"}
  ]

- name: Update Matrix
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "{{ website_dir }}/matrix.hunterwittenborn.com"

- name: Bring Matrix up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "{{ website_dir }}/matrix.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
