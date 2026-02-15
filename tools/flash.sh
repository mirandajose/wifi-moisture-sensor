#!/usr/bin/env bash
set -euo pipefail

PORT="${1:-/dev/cu.usbserial-0001}"
BAUD="${2:-460800}"

# This is the *container* workspace path, but it's a bind mount of your host repo.
PROJ_DIR="/workspaces/wifi-moisture-sensor"

ssh mac-host "bash -lc '
  set -euo pipefail

  cd \"$HOST_REPO\"

  # Ensure esptool exists on host
  python3 -m pip show esptool >/dev/null 2>&1 || python3 -m pip install --user esptool

  # Sanity check: files must exist in the mounted repo
  ls -l build/bootloader/bootloader.bin build/partition_table/partition-table.bin build/wifi_moisture_sensor.bin

  python3 -m esptool --chip esp8266 --port \"$PORT\" --baud \"$BAUD\" write_flash \
    0x00000 build/bootloader/bootloader.bin \
    0x8000  build/partition_table/partition-table.bin \
    0x10000 build/wifi_moisture_sensor.bin
'"