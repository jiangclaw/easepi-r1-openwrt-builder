#!/usr/bin/env bash
set -euo pipefail

OPENWRT_DIR="${1:?usage: prepare_config.sh <openwrt-dir> <seed-config>}"
SEED_CONFIG="${2:?usage: prepare_config.sh <openwrt-dir> <seed-config>}"

ROOTFS_PARTSIZE="${ROOTFS_PARTSIZE:-1024}"
EXTRA_PACKAGES="${EXTRA_PACKAGES:-}"
REMOVE_PACKAGES="${REMOVE_PACKAGES:-}"

cp "${SEED_CONFIG}" "${OPENWRT_DIR}/.config"

python3 - "$OPENWRT_DIR/.config" "$ROOTFS_PARTSIZE" <<'PY'
import pathlib
import re
import sys

config_path = pathlib.Path(sys.argv[1])
rootfs = sys.argv[2]
text = config_path.read_text()
text = re.sub(r"^CONFIG_TARGET_ROOTFS_PARTSIZE=.*$", f"CONFIG_TARGET_ROOTFS_PARTSIZE={rootfs}", text, flags=re.M)
config_path.write_text(text)
PY

for pkg in ${EXTRA_PACKAGES}; do
  echo "CONFIG_PACKAGE_${pkg}=y" >> "${OPENWRT_DIR}/.config"
done

for pkg in ${REMOVE_PACKAGES}; do
  echo "# CONFIG_PACKAGE_${pkg} is not set" >> "${OPENWRT_DIR}/.config"
done

echo "Prepared seed config:"
tail -n 40 "${OPENWRT_DIR}/.config"
