- name: Create Traefik directory if it doesn't exist
  ansible.builtin.file:
    path: "/var/www/traefik.{{ hw_url }}"
    state: directory

- name: Stop Traefik if it's currently running
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "stop"]
    chdir: "/var/www/traefik.{{ hw_url }}"
    removes: "./service.sh"

- name: Copy Traefik service files
  ansible.builtin.template:
    src: "{{ item.src }}"
    dest: "{{ item.dest }}"
    owner: "{{ item.owner }}"
    group: "{{ item.owner }}"
    mode: "{{ item.mode }}"
  loop: [
    {"src": "traefik/docker-compose.yml.j2", "dest": "/var/www/traefik.{{ hw_url }}/docker-compose.yml", "owner": "root", "mode": "600"},
    {"src": "traefik/service.sh.j2", "dest": "/var/www/traefik.{{ hw_url }}/service.sh", "owner": "root", "mode": "755"},
    {"src": "traefik/traefik.yml.j2", "dest": "/var/www/traefik.{{ hw_url }}/traefik.yml", "owner": "root", "mode": "644"}
  ]

- name: Update Traefik
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "update"]
    chdir: "/var/www/traefik.{{ hw_url }}"

- name: Bring Traefik up
  changed_when: False
  ansible.builtin.command:
    argv: ["./service.sh", "start"]
    chdir: "/var/www/traefik.{{ hw_url }}"

# vim: set ts=2 sw=2 expandtab syntax=yaml:
