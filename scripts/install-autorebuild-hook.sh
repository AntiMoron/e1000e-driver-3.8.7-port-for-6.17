#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOOK_SRC="${REPO_DIR}/scripts/e1000e-kernel-postinst.sh"
HOOK_DST="/etc/kernel/postinst.d/zz-e1000e-custom"
BUILD_SCRIPT="${REPO_DIR}/scripts/e1000e-rebuild-install.sh"

if [[ "$EUID" -ne 0 ]]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

install -m 0755 "${HOOK_SRC}" "${HOOK_DST}"
chmod 0755 "${BUILD_SCRIPT}"

echo "[INFO] Installed postinst hook at ${HOOK_DST}"
echo "[INFO] Future 6.17.x kernels will auto-rebuild this e1000e module on install."
