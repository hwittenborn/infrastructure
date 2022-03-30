- name: Stop ProGet if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "{{ website_dir }}/proget.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy ProGet service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "proget/docker-compose.yml.j2", "dest": "{{ website_dir }}/proget.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "proget/service.sh.j2", "dest": "{{ website_dir }}/proget.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update ProGet
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "{{ website_dir }}/proget.hunterwittenborn.com"

- name: Bring ProGet up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "{{ website_dir }}/proget.hunterwittenborn.com"

- name: Wait for a successful connection to ProGet
  register: result
  retries: 20
  until: "result.status == 200"
  delay: 3
  ansible.builtin.uri:
    url: "https://proget.{{ hw_url }}"
# vim: set ts=2 sw=2 expandtab syntax=yaml:
