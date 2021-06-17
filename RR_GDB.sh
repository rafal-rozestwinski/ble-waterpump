#!/bin/bash -x
set -e
echo "   (gdb) target remote localhost:3333   "
echo "   (gdb) monitor reset halt"
echo "   (gdb) load"
echo "   (gdb) continue"
gdb-multiarch --command="connect.gdb" BUILD/nrf51_BLE_Button.elf
