- name: Stop Nextcloud if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "{{ website_mnt_dir }}/nextcloud.hunterwittenborn.com"
    removes: "./service.sh"

- name: Copy Nextcloud service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "nextcloud/docker-compose.yml.j2", "dest": "{{ website_mnt_dir }}/nextcloud.hunterwittenborn.com/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "nextcloud/service.sh.j2", "dest": "{{ website_mnt_dir }}/nextcloud.hunterwittenborn.com/service.sh", "owner": "root", "mode": "755"}
  ]

- name: Update Nextcloud
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "{{ website_mnt_dir }}/nextcloud.hunterwittenborn.com"

- name: Bring Nextcloud up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "{{ website_mnt_dir }}/nextcloud.hunterwittenborn.com"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
