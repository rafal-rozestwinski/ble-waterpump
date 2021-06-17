#!/usr/bin/env python3
import gatt
import binascii
import sys
import os
import time
import threading
import io

sys.stdout = io.TextIOWrapper(open(sys.stdout.fileno(), 'wb', 0), write_through=True)
sys.stderr = io.TextIOWrapper(open(sys.stderr.fileno(), 'wb', 0), write_through=True)

def show_help():
    appname = sys.argv[0]
    print(f'''Usage:

REMEMBER RUN AS ROOT or with sudo:

   sudo {appname} --discovery
   sudo {appname} MAC --battery
   sudo {appname} MAC --uptime
   sudo {appname} MAC --pump
   sudo {appname} MAC --pump <time_in_seconds, int 0..100>

example:
   sudo {appname} 'C8:5E:22:9A:21:3A' --pump 10
''', file=sys.stderr)
    os._exit(1)


if len(sys.argv) < 2:
    show_help()

if os.geteuid() != 0:
   print("\n!!!!\n ERROR: NOT RUNNING AS ROOT! \n!!!!\n\n")
   show_help()

class AnyDeviceManager(gatt.DeviceManager):
    def device_discovered(self, device):
        #print("Discovered [%s] %s" % (device.mac_address, device.alias()))
        if "waterpump" in device.alias():
            print("Water Pump found: ", device.mac_address, file=sys.stderr)


manager = AnyDeviceManager(adapter_name='hci0')


class AnyDevice(gatt.Device):
    def connect_succeeded(self):
        super().connect_succeeded()
        print("connect_succeeded_cb: [%s] Connected" % (self.mac_address), file=sys.stderr)

    def connect_failed(self, error):
        super().connect_failed(error)
        print(
            "connect_failed_cb: [%s] Connection failed: %s" % (self.mac_address, str(error)),
            file=sys.stderr)

    def disconnect_succeeded(self):
        super().disconnect_succeeded()
        print("disconnect_succeeded_cb: [%s] Disconnected" % (self.mac_address), file=sys.stderr)

    def services_resolved(self):
        super().services_resolved()

        print("services_resolved_cb: [%s] Resolved services" % (self.mac_address), file=sys.stderr)
        for service in self.services:
            print(
                "services_resolved_cb: [%s]  Service [%s]" % (self.mac_address, service.uuid),
                file=sys.stderr)
            for characteristic in service.characteristics:
                print(
                    "services_resolved_cb: [%s]    Characteristic [%s]" % (self.mac_address,
                                                     characteristic.uuid),
                    file=sys.stderr)

        self.device_information_service = next(
            s for s in self.services
            if s.uuid == '0000180a-0000-1000-8000-00805f9b34fb')
        self.firmware_version_characteristic = next(
            c for c in self.device_information_service.characteristics
            if c.uuid == '00002a26-0000-1000-8000-00805f9b34fb')
        self.battery_service = next(
            s for s in self.services
            if s.uuid == '0000a300-0000-1000-8000-00805f9b34fb')
        self.battery_characteristic = next(
            c for c in self.battery_service.characteristics
            if c.uuid == '0000a301-0000-1000-8000-00805f9b34fb')
        self.uptime_service = next(
            s for s in self.services
            if s.uuid == '0000a200-0000-1000-8000-00805f9b34fb')
        self.uptime_characteristic = next(
            c for c in self.uptime_service.characteristics
            if c.uuid == '0000a201-0000-1000-8000-00805f9b34fb')

        self.pump_service = next(
            s for s in self.services
            if s.uuid == '0000a100-0000-1000-8000-00805f9b34fb')
        self.pump_characteristic = next(
            c for c in self.pump_service.characteristics
            if c.uuid == '0000a101-0000-1000-8000-00805f9b34fb')

        #print("FW:")
        #self.firmware_version_characteristic.read_value()

        if self.action == "READ_BATTERY":
            self.battery_characteristic.read_value()

        if self.action == "READ_UPTIME":
            self.uptime_characteristic.read_value()

        if self.action == "TURN_ON_PUMP":
            self.pump_characteristic.write_value(
                bytearray([self.pumping_time]))

    def read_battery(self):
        self.action = "READ_BATTERY"

    def read_uptime(self):
        self.action = "READ_UPTIME"

    def turn_on_pump(self, howlong=5):
        self.action = "TURN_ON_PUMP"
        if howlong > 100:
            howlong = 100
        if howlong < 0:
            howlong = 0
        self.pumping_time = howlong

    def characteristic_value_updated(self, characteristic, value):
        #try:
        #   print("   [utf8] value updated:", characteristic.uuid, " => ", value.decode("utf-8"))
        #except:
        #   pass
        print(
            "characteristic_value_updated_cb: [hex] value updated:",
            characteristic.uuid,
            " => ",
            binascii.hexlify(value),
            file=sys.stderr)
        #if self.action in [ "READ_UPTIME", "READ_BATTERY" ]:
        if self.action == "READ_UPTIME":
        	print("UPTIME[s]", int.from_bytes(value, byteorder='little', signed=False))
        elif self.action == "READ_BATTERY":
        	print("BATTERY[%]:", int.from_bytes(value, byteorder='little', signed=False))
        else:
                print("VALUE[bytearray]", binascii.hexlify(value))
        device.disconnect()
        manager.stop()
        #time.sleep(1)
        #os._exit(0)

    def characteristic_write_value_succeeded(self, characteristic):
        print("characteristic_write_value_succeeded_cb: write ok:", characteristic.uuid, file=sys.stderr)
        device.disconnect()
        manager.stop()
        #time.sleep(1)
        #os._exit(0)

    def characteristic_write_value_failed(self, error):
        print("characteristic_write_value_failed_cb: write failed, error:", error, file=sys.stderr)
        device.disconnect()
        manager.stop()
        #time.sleep(1)
        #os._exit(2)

#device = AnyDevice(mac_address='C8:5E:22:9A:21:3A', manager=manager)
#device = AnyDevice(mac_address='D8:73:29:8B:50:8C', manager=manager)

if sys.argv[1] == "--discovery":
   print("Scanning for BLE devices with device name containing 'waterpump'. Press CTRL+C to exit.")
   try:
      manager.start_discovery()
      manager.run()
   finally:
      print("[main@finally] Disconnecting...", file=sys.stderr)
      manager.stop()
      time.sleep(0.5)
      sys.exit(0)

if len(sys.argv) < 3:
    show_help()


MAC = sys.argv[1]
device = AnyDevice(mac_address=MAC, manager=manager)

if sys.argv[2] == '--battery':
    device.read_battery()
elif sys.argv[2] == '--uptime':
    device.read_uptime()
elif sys.argv[2] == '--pump':
    howlong = 5
    if len(sys.argv) > 3:
        howlong = int(sys.argv[3])
    device.turn_on_pump(howlong)
else:
    show_help()

STOP_THREAD = False
def bg_thread_task():
   global STOP_THREAD
   print("[thread] Running BLE manager in background thread...", file=sys.stderr)
   try:
      for i in range(0, 30):
         if STOP_THREAD:
            print("[thread] STOP_THREAD is true, exiting.", file=sys.stderr)
            return
         time.sleep(0.5)
      print("[thread] Requesting disconnect...", file=sys.stderr)
      device.disconnect()
      manager.stop()
      print("[thread] manager and device stop requested.", file=sys.stderr)
   finally:
      print("[thread@finally] Disconnecting...", file=sys.stderr)
      device.disconnect()
      manager.stop()
      print("[thread@finally] manager and device stop requested.", file=sys.stderr)

try:
    device.connect()
    thread = threading.Thread(target=bg_thread_task, args=())
    thread.start()
    manager.run()
    print("[main] manager.run() exited.", file=sys.stderr)
finally:
    print("[main@finally] Disconnecting...", file=sys.stderr)
    STOP_THREAD = True
    device.disconnect()
    manager.stop()
    print("[main@finally] Disconnected.", file=sys.stderr)
