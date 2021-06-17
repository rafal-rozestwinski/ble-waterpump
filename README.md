# Bluetooth Low Energy IoT Water Pump powered by AA batteries

Another item in my home IoT system, a AA-battery powered pump for watering plants controlled over Bluetooth Low Energy (BLE).

# Design - cheap, fast, reliable vs quick 'n dirty

- Chip nrf51822 is **old and obsolete**, included firmware **(softdevice) is buggy**. But it's **cheap ($1)** and **available** in bulk. When using nrf52* series, I recommend using either native nordic semi SDK or [mbed examples](https://github.com/ARMmbed/mbed-os-example-ble).
- It's an **amazing device for radio controlled battery operated IoT devices**. In this project, it's directly **powered from a two AA batteries**, with **power consumption of around 1.5mA**. Therefore it should work for more than **2 months on a single charge**.
- Three AA batteries power the 5V cheap ($1) watertight water pump. A separate power source for pump here is being used to simplify project and avoid inefficient regulators. Pump, when running, is consuming between 70 and 100mA. [NPM BC547](https://www.mouser.com/datasheet/2/149/BC547-190204.pdf) is rated for 100mA continuous.
- uC battery level is measured and available over BLE GATT service. I changed that to use internal reference voltage, not implemented in mBed.
- **3xAA battery level is not measured**. I check those from time to time, as pump runs for just a few seconds every day.
- Project is downloaded from ARM mbed online IDE and adjust to **work in an offline mode**, using normal GCC ARM build on ubuntu etc.
- No encryption nor secure pairing.
- *WDT is enabled*, but in addition device reboots every 1024 seconds, as a additional failsafe for unstable (old) SoftDevice.
- Just a *few passive components* and a *single [BJT NPM](https://www.mouser.com/datasheet/2/149/BC547-190204.pdf)* transistor being used.
- Code is forked from some mbed example in a quite dirty way. **No warranty** ;)

# Building

- Install ARM GCC on ubuntu: `sudo apt install gcc-arm-none-eabi gdb valgrind make openocd srecord`
- Connect STLINK programmer to SWDIO/SWCLK/GND/VCC pins (with batteries disconnected) and attach to the computer.
- `make && ./RR_FLASH.sh`
- Check using `gatttool` on linux/RPI or via official [nRF Connect app](https://apps.apple.com/app/nrf-connect-for-mobile/id1054362403), which is very useful for debugging BLE in general. 
- Use my python tool `pumpble.py`, available in this directory (including `requirements.txt`).

# Electronic Connection Diagram

As my cheap imported [nrf51822](https://www.nordicsemi.com/Products/Low-power-short-range-wireless/nRF51822) [cheap module](https://botland.com.pl/moduly-bluetooth/4505-modul-bluetooth-low-energy-ble-40-nrf51822-waveshare-9515.html) has 2.0mm goldpin spacing, I'm using [wire-wrapping](https://en.wikipedia.org/wiki/Wire_wrap) technique to connect it.

```
[ 3xAA battery + ] ---------+------[+ 5V water pump -]-----+--------+
                            |                              |        |
                            +------[   |< diode   ]--------+        |  
                                                                 | /
                                          +--[  360 Ohm  ]-----  |   NPN BJT BC547
                                          |                      | \>
                                          |                         |
                                        PIN19                       |
                               ==========================           |
                               |                        |           |
                               |   nrf51822 module      |+-------- Common GND
                     +--VCC +--|                        |           |
                     |         ===========================          |
                     |                       PIN2                   |
                     |                        |                     |
                     |                        |                     |
[ 2*AA battery + ] --+---- [  6800 Ohm  ] ----+---- [ 680 Ohm ] ----+
```

Note: PIN18 is a blinking status LED. Not attached to save battery.

# Hardware

STL and FreeCAD files for attaching pump to the 5mm silicone tube, as well as compatible splitter (so single pump can serve multiple pots etc.). Those are in CAD/ directory.

# Usage [Linux/raspberry pi]

### Find device MAC:

Run `hcitool lescan` and lookup for a device name configured in `main.cpp` as `DEVICE_NAME[]`.

```bash
$ sudo hcitool lescan | grep -i waterpump
C8:5E:22:9A:21:3A waterpump
```

### Find handle values:

```bash
$ gatttool -t random -b C8:5E:22:9A:21:3A --characteristics
(...)
handle = 0x000d, char properties = 0x12, char value handle = 0x000e, uuid = 0000a301-0000-1000-8000-00805f9b34fb
handle = 0x0011, char properties = 0x0a, char value handle = 0x0012, uuid = 0000a101-0000-1000-8000-00805f9b34fb
handle = 0x0014, char properties = 0x02, char value handle = 0x0015, uuid = 0000a201-0000-1000-8000-00805f9b34fb
```

Where first part of UUIDs define services:

- 0000a101-0000-1000-8000-00805f9b34fb -> 0xA101 - pump characteristic uuid for reading and writing a value
- 0000a201-0000-1000-8000-00805f9b34fb -> 0xA201 - uptime characteristic uuid for reading a value
- 0000a301-0000-1000-8000-00805f9b34fb -> 0xA301 - battery characteristic for reading a value

Use `char value handle` value when calling commands below for particular service.

### Read battery state

Value returned is hex-encoded byte, where for example value of 64 => 0x64 => 100 => 100%

`gatttool -t random  -b $MAC --char-read --handle=0x0e | cut -d':' -f2`

### Read uptime

Returns 4 bytes, uint32_t of uptime in seconds since last reboot:

`gatttool -t random  -b $MAC --char-read --handle=0x15 | cut -d':' -f2`

### Read pump state (pumping or not)

`gatttool -t random  -b $MAC --char-read --handle=0x12 | cut -d':' -f2`

### Start pump

Value = seconds for which it should be running, as an hex-encoded byte (and padded with 0!):

`gatttool -t random  -b $MAC --char-write-req -a 0x0012 -n 05`

### Wrapper tool

`LINUX_BLE_GATTTOOL_TEST.sh` is my wrapper to perform those steps. I run it over ssh over my all raspberry pi's all over my home, which is integrated with custom `sensors-dashboard` as well as with the (http://homebridge.io)[HomeBridge] for iOS/HomeKit integration. One can also use iOS Shortcuts app to perform the same.

# Media

Note: always use properly matched batteries ;)

Note: due to a lot of hot glue being used, my implementation has scored only 6/10 repairability score ;)

![Photo - inside the box ](img/box.jpeg?raw=true "Battery box")
![Photo - physical water splitter](img/pump_splitter.jpeg?raw=true "3D printed water splitter")
![Video - pumping water](img/waterpump_in_action.mp4?raw=true "Pumping in action")
![FreeCAD - water splitter](img/CAD_screenshot.png?raw=true "FreeCAD screenshot of water splitter")

# Learn more about GATT and BLE

- https://epxx.co/artigos/bluetooth_gatt.html

# Licensing

All-but-some files in this repo were exported/downloaded from [ARM's mBed Studio online](https://os.mbed.com/studio/).

My changes? Choose: Apache 2, MIT, BSD.
