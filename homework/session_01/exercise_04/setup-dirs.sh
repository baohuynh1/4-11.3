#!/usr/bin/env bash
# Chuan bi thu muc chua file JAR cua user-service.
# Yeu cau: da chay initial-script.sh de tao user va group quickbite.
# Cach chay: sudo ./setup-dirs.sh
#
# Y nghia cua ma phan quyen 750 (r = 4, w = 2, x = 1):
#   7 (rwx = 4+2+1) - Chu so huu (user quickbite): doc, ghi va vao thu muc.
#   5 (r-x = 4+1)   - Nhom (group quickbite): doc va vao thu muc, khong duoc ghi.
#   0 (---)         - Nguoi dung khac: khong co quyen nao, nen khong the
#                     vao thu muc hay doc file cau hinh nhay cam ben trong.

set -euo pipefail

BASE_DIR="/opt/quickbite"
SERVICE_DIR="${BASE_DIR}/user-service"
APP_USER="quickbite"
APP_GROUP="quickbite"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Vui long chay script bang sudo: sudo ./setup-dirs.sh" >&2
    exit 1
fi

if ! id "${APP_USER}" > /dev/null 2>&1; then
    echo "Chua co user ${APP_USER}. Hay chay initial-script.sh truoc." >&2
    exit 1
fi

echo "==> Tao thu muc ${SERVICE_DIR}"
mkdir -p "${SERVICE_DIR}"

echo "==> Doi chu so huu ${BASE_DIR} cho ${APP_USER}:${APP_GROUP}"
chown -R "${APP_USER}:${APP_GROUP}" "${BASE_DIR}"

echo "==> Dat quyen 750 cho ${BASE_DIR}"
chmod 750 "${BASE_DIR}"

echo "==> Hoan tat"
ls -la /opt
