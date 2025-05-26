#!/bin/bash

# Get the current status of Bluetooth
status=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$status" = "yes" ]; then
    # Turn Bluetooth off
    bluetoothctl power off
    echo "Bluetooth is now OFF."
else
    # Turn Bluetooth on
    bluetoothctl power on
    echo "Bluetooth is now ON."
fi
