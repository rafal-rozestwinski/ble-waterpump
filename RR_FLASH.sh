#!/bin/bash -x

openocd -f interface/stlink-v2.cfg -f target/nrf51.cfg -c "init ; halt; sleep 10 ; nrf51 mass_erase ; sleep 10 ; program BUILD/nrf51_BLE_Button-combined.hex verify ; reset ; exit"
