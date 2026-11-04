#!/usr/bin/env bash
# Thiet lap moi truong ban dau cho QuickBite.
# Cach chay: sudo ./initial-script.sh

set -euo pipefail

APP_USER="quickbite"
APP_GROUP="quickbite"
PACKAGES=(openjdk-17-jdk git curl)

# Script can quyen root de cai goi, tao group va tao user.
if [[ "${EUID}" -ne 0 ]]; then
    echo "Vui long chay script bang sudo: sudo ./initial-script.sh" >&2
    exit 1
fi

echo "==> Cap nhat he thong"
sudo apt-get update && sudo apt-get upgrade -y

echo "==> Cai dat cac goi bat buoc: ${PACKAGES[*]}"
sudo apt-get install -y "${PACKAGES[@]}"

echo "==> Kiem tra group ${APP_GROUP}"
if getent group "${APP_GROUP}" > /dev/null; then
    echo "Group ${APP_GROUP} da ton tai, bo qua."
else
    groupadd "${APP_GROUP}"
    echo "Da tao group ${APP_GROUP}."
fi

echo "==> Kiem tra user ${APP_USER}"
if id "${APP_USER}" > /dev/null 2>&1; then
    echo "User ${APP_USER} da ton tai, bo qua."
else
    # -r: tao system user, khong tu dong tao thu muc home.
    # -g: dat nhom chinh. -s /bin/false: khoa dang nhap truc tiep.
    useradd -r -g "${APP_GROUP}" -s /bin/false "${APP_USER}"
    echo "Da tao system user ${APP_USER}."
fi

echo "==> Hoan tat thiet lap moi truong QuickBite"
id "${APP_USER}"
