- name: Ensure needed directories exist
  ansible.builtin.file:
    path: "{{ website_dir }}/hunterwittenborn.com/{{ item }}"
    state: directory
    mode: '755'
  loop:
    - '.well-known/'
    - '.well-known/matrix/'

- name: Copy needed files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: root
    group: root
    mode: 644
  loop: [
    {"src": "hunterwittenborn.com/matrix-server.json", "dest": "/var/www/hunterwittenborn.com/.well-known/matrix/server"}
  ]

# vim: set ts=2 sw=2 expandtab syntax=yaml:
