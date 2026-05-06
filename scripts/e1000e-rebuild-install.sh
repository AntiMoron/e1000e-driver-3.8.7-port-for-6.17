#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${REPO_DIR}/src"
KVER="${1:-$(uname -r)}"
RUNNING_KVER="$(uname -r)"

if [[ ! -d "/usr/src/linux-headers-${KVER}" ]]; then
  echo "[ERROR] Missing kernel headers: /usr/src/linux-headers-${KVER}" >&2
  exit 1
fi

echo "[INFO] Building e1000e for kernel: ${KVER}"
make -C "${SRC_DIR}" clean
make -C "${SRC_DIR}" KVER="${KVER}" -j"$(nproc)"

echo "[INFO] Installing e1000e for kernel: ${KVER}"
make -C "${SRC_DIR}" KVER="${KVER}" install

# Ensure module dependency map is always refreshed for the target kernel.
depmod -a "${KVER}"

# Keep initramfs in sync so the custom module is available early at boot.
if command -v update-initramfs >/dev/null 2>&1; then
  update-initramfs -u -k "${KVER}" || true
fi

# If we just installed for the currently running kernel, apply immediately.
if [[ "${KVER}" == "${RUNNING_KVER}" ]]; then
  echo "[INFO] Reloading e1000e on running kernel ${RUNNING_KVER}"
  modprobe -r e1000e || true
  modprobe e1000e

  # Trigger a reprobe on the common Intel I219-LM PCI function if present.
  if [[ -e /sys/bus/pci/devices/0000:00:1f.6 ]]; then
    echo "0000:00:1f.6" > /sys/bus/pci/drivers/e1000e/bind 2>/dev/null || true
  fi
fi

echo "[INFO] Done. Installed module path:"
modinfo -n -k "${KVER}" e1000e || true
