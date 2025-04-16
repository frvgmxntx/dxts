#!/usr/bin/env bash

if bluetoothctl show | grep 'Powered: no' -q; then
  echo "bluetoothctl power on"
else
  echo "bluetoothctl power off"
fi
