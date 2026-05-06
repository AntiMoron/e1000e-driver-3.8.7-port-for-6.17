#!/usr/bin/env bash
set -euo pipefail

KVER="${1:-}"
if [[ -z "${KVER}" ]]; then
  exit 0
fi

# Keep this hook scoped to the kernel line this repo targets.
if [[ "${KVER}" != 6.17.* ]]; then
  exit 0
fi

REPO_DIR="/home/ama/.e1000e/e1000e-driver-3.8.7-port-for-6.17"
BUILD_SCRIPT="${REPO_DIR}/scripts/e1000e-rebuild-install.sh"

if [[ ! -x "${BUILD_SCRIPT}" ]]; then
  echo "[e1000e-hook] Missing executable build script: ${BUILD_SCRIPT}" >&2
  exit 0
fi

echo "[e1000e-hook] Rebuilding e1000e for ${KVER}"
"${BUILD_SCRIPT}" "${KVER}" || {
  echo "[e1000e-hook] rebuild failed for ${KVER}" >&2
  exit 0
}

echo "[e1000e-hook] rebuild finished for ${KVER}"
