#!/usr/bin/env bash
set -euo pipefail

OPENWRT_DIR="${1:?usage: clone_openclash.sh <openwrt-dir> [ref] }"
OPENCLASH_REF="${2:-master}"
PACKAGE_ROOT="${OPENWRT_DIR}/package/openclash"

rm -rf "${PACKAGE_ROOT}"
mkdir -p "${PACKAGE_ROOT}"

git -C "${PACKAGE_ROOT}" init
git -C "${PACKAGE_ROOT}" remote add origin https://github.com/vernesong/OpenClash.git
git -C "${PACKAGE_ROOT}" config core.sparseCheckout true
printf 'luci-app-openclash/\n' > "${PACKAGE_ROOT}/.git/info/sparse-checkout"
git -C "${PACKAGE_ROOT}" pull --depth 1 origin "${OPENCLASH_REF}"

test -f "${PACKAGE_ROOT}/luci-app-openclash/Makefile"
echo "OpenClash source prepared at ${PACKAGE_ROOT}/luci-app-openclash"
