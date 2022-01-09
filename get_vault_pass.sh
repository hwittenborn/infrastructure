#!/usr/bin/bash
file="$(dirname "${0}")/vault_password"

if [[ -f "${file}" ]]; then
  cat "${file}"
else
  read -sp "Vault password: " pass
  echo "${pass}"
fi
