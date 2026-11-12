#!/usr/bin/env bash
set -euo pipefail

RULE_SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/99-teensy-ota.rules"
RULE_DST="/etc/udev/rules.d/99-teensy-ota.rules"

if [[ ${EUID} -ne 0 ]]; then
  echo "Installing Teensy udev rules requires sudo/root." >&2
  exec sudo "$0" "$@"
fi

install -m 0644 "$RULE_SRC" "$RULE_DST"
udevadm control --reload-rules
udevadm trigger --attr-match=idVendor=16c0 || true
udevadm settle || true

cat <<'MSG'
Installed /etc/udev/rules.d/99-teensy-ota.rules and reloaded udev.
Unplug/replug the Teensy or press its program button if permissions do not update immediately.
The rules allow access through uaccess or membership in the dialout group.
MSG
