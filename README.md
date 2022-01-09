# Infrastructure
This repository contains the Ansible playbooks and roles necessary to deploy to my homelab.

## Requirements
The following ansible modules need to be installed on your system. If they're not installed already, you can install them with `ansible-galaxy collection install`:

- `ansible.posix`

## Usage
You must first have access to a server and have its fingerprints registered on your system.
After, just add the host to the `hosts` file and you should be good to go.

The following secrets need to be set in `group_vars/homelab.yml`:

- `cloudflare_api_key`: An API key for Cloudflare. This is used for automatic DNS setup for things like email configuration.

All other secrets in `group_vars/homelab.yml` can be any secret. The other secrets map to the deployed configs in `roles/homelab/templates/services/`. Once the values for such are set, you should also (in general) not change them, as they may require manual intervention on the servers if a secret change messes with an already deployed service (such as credentials for a MariaDB instance).

To deploy, simply run the following from the root of this repository:

```sh
ansible-playbook playbook/homelab.yml
```

You should then be prompted for a password, which will unlock all required secrets.

### Setting the password
A convenience script, `get_vault_pass.sh`, is provided if you want to set the vault password, such as if you don't want to retype if every time you redeploy.

To set a vault password, just place your password in a file named `vault_password` at the root of thisrepository. The file is not tracked by Git, so you're safe to keep it on your local file system between commits.

## Usability notice
This Ansible setup is meant to tie directly into my own setup, and will likely not work in your own configurations without making several changes. The main purpose of this repository is to simply provide an outside view on how my homelab is set up, so:

1. If noticed, feedback can be obtained, and
2. So others can learn from what I've implemented.

Note that the Ansible configs here won't currently work for setting up a server from scratch. Currently, my existing infrastructure needs to be running for a succesful update, though work is planned to be done in that area.
