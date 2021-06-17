#!/bin/bash

echo "RUN GDB IN SEPARATE TERMINAL:"
echo "> gdb BUILD/nrf51822_mbed_blinky.elf"
echo "   (gdb) target remote localhost:3333   "
echo "   (gdb) monitor reset halt"
echo "   (gdb) load"
echo "   (gdb) continue"
echo ""
openocd -f interface/stlink-v2.cfg -f target/nrf51.cfg "target remote localhost:3333"
