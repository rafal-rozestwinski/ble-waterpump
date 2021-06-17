#!/bin/bash

#MAC=D8:73:29:8B:50:8C
MAC="C8:5E:22:9A:21:3A"

#handle = 0x0002, char properties = 0x0a, char value handle = 0x0003, uuid = 00002a00-0000-1000-8000-00805f9b34fb
#handle = 0x0004, char properties = 0x02, char value handle = 0x0005, uuid = 00002a01-0000-1000-8000-00805f9b34fb
#handle = 0x0006, char properties = 0x02, char value handle = 0x0007, uuid = 00002a04-0000-1000-8000-00805f9b34fb
#handle = 0x0009, char properties = 0x20, char value handle = 0x000a, uuid = 00002a05-0000-1000-8000-00805f9b34fb
#handle = 0x000d, char properties = 0x12, char value handle = 0x000e, uuid = 0000a301-0000-1000-8000-00805f9b34fb
#handle = 0x0011, char properties = 0x0a, char value handle = 0x0012, uuid = 0000a101-0000-1000-8000-00805f9b34fb
#handle = 0x0014, char properties = 0x02, char value handle = 0x0015, uuid = 0000a201-0000-1000-8000-00805f9b34fb
#handle = 0x0017, char properties = 0x02, char value handle = 0x0018, uuid = 00002a29-0000-1000-8000-00805f9b34fb
#handle = 0x0019, char properties = 0x02, char value handle = 0x001a, uuid = 00002a24-0000-1000-8000-00805f9b34fb
#handle = 0x001b, char properties = 0x02, char value handle = 0x001c, uuid = 00002a25-0000-1000-8000-00805f9b34fb
#handle = 0x001d, char properties = 0x02, char value handle = 0x001e, uuid = 00002a27-0000-1000-8000-00805f9b34fb
#handle = 0x001f, char properties = 0x02, char value handle = 0x0020, uuid = 00002a26-0000-1000-8000-00805f9b34fb
#handle = 0x0021, char properties = 0x02, char value handle = 0x0022, uuid = 00002a28-0000-1000-8000-00805f9b34fb

if [[ "x$1" == "x--battery" ]] ; then
        gatttool -t random  -b $MAC --char-read --handle=0x0e | cut -d':' -f2
fi

if [[ "x$1" == "x--uptime" ]] ; then
        gatttool -t random  -b $MAC --char-read --handle=0x15 | cut -d':' -f2
fi

if [[ "x$1" == "x--pump" ]] ; then
        gatttool -t random  -b $MAC --char-read --handle=0x12 | cut -d':' -f2
fi

if [[ "x$1" == "x--start" ]] ; then
        gatttool -t random  -b $MAC --char-write-req -a 0x0012 -n 05
        # value has to be two digits, with 0 prefix if necessary
fi
