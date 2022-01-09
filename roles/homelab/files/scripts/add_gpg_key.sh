#!/usr/bin/bash
set -euo pipefail

wget -qO - "${1}" | \
gpg --dearmor | \
tee "${2}" 1> /dev/null
