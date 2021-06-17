// nrf51822 BLE water pump powered by AA batteries
// by Rafal Rozestwinski
// Modified nrf mbed example.
// My changes under any of: Apache 2.0, BSD, MIT.

#ifndef DEV_NAME
#define DEV_NAME waterpump
#endif

#ifndef DISCONNECT_AFTER_SECONDS
#define DISCONNECT_AFTER_SECONDS 10
#endif

#ifndef RESET_AFTER_SECONDS
#define RESET_AFTER_SECONDS 3600
#endif



#define STRINGIZE(x) #x
#define STRINGIZE_VALUE_OF(x) STRINGIZE(x)

// BATTERY LEVEL:  VCC - R1 - ADC - R2 - GND
// with those values (6.8k + 680R): 12V = 1.09V; 3V = 0.273V; 5V = 0.455
// around 9% of actual value.
#define R1 6800
#define R2 680
#define REFERENCE_VOLTAGE 1.2f

#include <inttypes.h>
#include "ble/BLE.h"
#include "mbed.h"
#include "ble/services/BatteryService.h"
#include "ble/services/DeviceInformationService.h"
#include "nrf.h" // watchdog
#include "cmsis.h"
#include "pinmap.h"

// via ./mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/PinNames.h
//    LED1    = p18,
//    LED2    = p19,
//    LED3    = p20,
//    LED4    = p19,
//    BUTTON1 = p16,
//    BUTTON2 = p17,
//    //  RX_PIN_NUMBER = p11,  TX_PIN_NUMBER = p9,
//    USBTX = TX_PIN_NUMBER,
//    USBRX = RX_PIN_NUMBER,
// DEFAULT: sudo miniterm /dev/ttyUSB0 9600
// HERE: sudo miniterm /dev/ttyUSB0 115200
// Battery voltage with R1 and R2: p2

#define RR_ANALOGIN_MEDIAN_FILTER      1
#define RR_ADC_10BIT_RANGE             0x3FF
#define RR_ADC_RANGE    RR_ADC_10BIT_RANGE

void p2_adc_configure_internal_1_2V_ref() {
    NRF_ADC->ENABLE = ADC_ENABLE_ENABLE_Enabled;
    NRF_ADC->CONFIG = (ADC_CONFIG_RES_10bit << ADC_CONFIG_RES_Pos) |
//                      (ADC_CONFIG_INPSEL_AnalogInputOneThirdPrescaling << ADC_CONFIG_INPSEL_Pos) |
//                      (ADC_CONFIG_REFSEL_VBG << ADC_CONFIG_REFSEL_Pos) |
//                      (ADC_CONFIG_REFSEL_SupplyOneThirdPrescaling << ADC_CONFIG_REFSEL_Pos) | // NRF_ADC_CONFIG_REF_VBG
                      (ADC_CONFIG_PSEL_AnalogInput3 << ADC_CONFIG_PSEL_Pos);// |
//                      (ADC_CONFIG_EXTREFSEL_None << ADC_CONFIG_EXTREFSEL_Pos);
}

uint16_t p2_adc_read_u16() {
    NRF_ADC->CONFIG     &= ~ADC_CONFIG_PSEL_Msk;
    NRF_ADC->CONFIG     |= ADC_CONFIG_PSEL_AnalogInput3 << ADC_CONFIG_PSEL_Pos;
    NRF_ADC->TASKS_START = 1;
    while (((NRF_ADC->BUSY & ADC_BUSY_BUSY_Msk) >> ADC_BUSY_BUSY_Pos) == ADC_BUSY_BUSY_Busy) {
    }
    return (uint16_t)NRF_ADC->RESULT; // 10 bit
}

float p2_adc_read() {
    uint16_t value = p2_adc_read_u16();
    return (float)value * (1.0f / (float)RR_ADC_RANGE);
}

void wdt_init() {
    NRF_WDT->CONFIG = (WDT_CONFIG_HALT_Pause << WDT_CONFIG_HALT_Pos) | ( WDT_CONFIG_SLEEP_Run << WDT_CONFIG_SLEEP_Pos);
    NRF_WDT->CRV = 3*32768;
    NRF_WDT->RREN |= WDT_RREN_RR0_Msk;
    NRF_WDT->TASKS_START = 1;
}

void wdt_reset() {
    NRF_WDT->RR[0] = WDT_RR_RR_Reload;
}

DigitalOut led1(LED1);
DigitalOut powerswitch1(LED2);

Serial serial(USBTX, USBRX, 115200);
Ticker ticker;
volatile uint32_t cnt = 0;

void rr_reset() {
    NVIC_SystemReset();
}

void periodicCallback(void);
const char* get_current_sensor_name(int b1, int b2);

void rr_error() {
    serial.printf("> rr_error() - 1s loop for debugger now!\n");
    ticker.detach();
    ticker.attach(periodicCallback, 0.1);
    wait_ms(1000);
    rr_reset();
}

float nrf51_voltage_adc_to_battery(float adc_in) {
    float real_voltage_on_pin = adc_in * REFERENCE_VOLTAGE;
    //int R1 = 21000; // defined as macro
    //int R2 = 1000; //  defined as macro
    //   Vs ----- R1 ------ Vout_PIN ---- R2 ----- GND
    //
    //         Vs * R2
    // Vout = ---------------
    //        ( R1 + R2)
    //
    //          Vout
    // Vs =   -------- * ( R1 + R2)
    //          R2
    float actualVoltage = (real_voltage_on_pin / R2) * (R1 + R2);
    return actualVoltage;
}

int32_t map(int32_t x, int32_t in_min, int32_t in_max, int32_t out_min, int32_t out_max) {
    int32_t ret = (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
    if(ret > out_max) return out_max;
    if(ret < out_min) return out_min;
    return ret;
}

float LAST_BATTERY_VOLTAGE = 0.0f;
uint8_t LAST_BATTERY_PERCENT = 0;

float get_current_battery_voltage() {
    float adc_out = p2_adc_read(); // using internal 1.2V reference voltage, same below.
    float voltage = nrf51_voltage_adc_to_battery(adc_out);
    return voltage;
}

void periodicCallback(void) {
    led1 = !led1;
    cnt++;
}

class WaterPumpService {
public:
    const static uint16_t WATER_PUMP_SERVICE_UUID              = 0xA100;
    const static uint16_t WATER_PUMP_STATE_CHARACTERISTIC_UUID = 0xA101;

    WaterPumpService(BLEDevice &_ble, uint8_t initial) :
        ble(_ble), pumpingValue(initial), pumpState(WATER_PUMP_STATE_CHARACTERISTIC_UUID, &initial) {
        GattCharacteristic *charTable[] = {&pumpState};
        GattService pumpService(WATER_PUMP_SERVICE_UUID, charTable, sizeof(charTable) / sizeof(GattCharacteristic *));
        ble.addService(pumpService);
    }

    GattAttribute::Handle_t getValueHandle() const {
        return pumpState.getValueHandle();
    }

    void updatePumpState(uint8_t v) {
        pumpingValue = v;
        ble.gattServer().write(pumpState.getValueHandle(), &pumpingValue, 1);
    }

private:
    BLEDevice &ble;
    uint8_t pumpingValue;
    ReadWriteGattCharacteristic<uint8_t> pumpState;
};

class CustomBatteryService {
public:
    const static uint16_t CUSTOM_BATTERY_SERVICE_UUID              = 0xA300;
    const static uint16_t CUSTOM_BATTERY_CHARACTERISTIC_UUID = 0xA301;

    CustomBatteryService(BLE &_ble, uint8_t level = 100) :
        ble(_ble),
        batteryLevel(level),
        batteryLevelCharacteristic(CUSTOM_BATTERY_CHARACTERISTIC_UUID, &batteryLevel, GattCharacteristic::BLE_GATT_CHAR_PROPERTIES_NOTIFY) {

        GattCharacteristic *charTable[] = {&batteryLevelCharacteristic};
        GattService         batteryService(CUSTOM_BATTERY_SERVICE_UUID, charTable, sizeof(charTable) / sizeof(GattCharacteristic *));

        ble.addService(batteryService);
    }
    void updateBatteryLevel(uint8_t newLevel) {
        batteryLevel = newLevel;
        ble.gattServer().write(batteryLevelCharacteristic.getValueHandle(), &batteryLevel, 1);
    }

protected:
    BLE &ble;
    uint8_t    batteryLevel;
    ReadOnlyGattCharacteristic<uint8_t> batteryLevelCharacteristic;
};

class UptimeService {
public:
    const static uint16_t UPTIME_SERVICE_UUID              = 0xA200;
    const static uint16_t UPTIME_STATE_CHARACTERISTIC_UUID = 0xA201;

    UptimeService(BLEDevice &_ble, uint32_t initial) :
        ble(_ble), value(initial), valueState(UPTIME_STATE_CHARACTERISTIC_UUID, &initial) {
        GattCharacteristic *charTable[] = {&valueState};
        GattService         uptimeService(UPTIME_SERVICE_UUID, charTable, sizeof(charTable) / sizeof(GattCharacteristic *));
        ble.addService(uptimeService);
    }

    GattAttribute::Handle_t getValueHandle() const {
        return valueState.getValueHandle();
    }

    void updateUptimeState(uint32_t v) {
        value = v;
        ble.gattServer().write(valueState.getValueHandle(), (uint8_t*)&value, 4);
    }

private:
    BLEDevice &ble;
    uint32_t value;
    ReadOnlyGattCharacteristic<uint32_t> valueState;
};

const static char DEVICE_NAME[] = STRINGIZE_VALUE_OF(DEV_NAME);
static const uint16_t uuid16_list[] = {
    WaterPumpService::WATER_PUMP_SERVICE_UUID,
    UptimeService::UPTIME_SERVICE_UUID,
    GattService::UUID_BATTERY_SERVICE,
    GattService::UUID_DEVICE_INFORMATION_SERVICE,
    CustomBatteryService::CUSTOM_BATTERY_SERVICE_UUID
};

WaterPumpService *pumpServicePtr = NULL;
UptimeService *uptimeServicePtr = NULL;
CustomBatteryService *batteryServicePtr = NULL;
DeviceInformationService *deviceInfo = NULL;

volatile uint32_t PUMPING_STOP_AT_CNT = 0;
volatile bool PUMPING_ENABLED = false;

void onDataWrittenCallback(const GattWriteCallbackParams *params) {
    if ((params->handle == pumpServicePtr->getValueHandle()) && (params->len == 1)) {
        int pump_for_seconds = (int)(*(params->data));
        serial.printf("PUMP DATA: %i\n", pump_for_seconds);
        PUMPING_STOP_AT_CNT = cnt + pump_for_seconds + 1;
        PUMPING_ENABLED = true;
        powerswitch1 = 1;
        if(pumpServicePtr) {
            pumpServicePtr->updatePumpState(pump_for_seconds);
            serial.printf("!!    -> pumpServicePtr updated to value %i\n", (int)pump_for_seconds);
        } else {
            serial.printf("WARNING: pumpServicePtr is NULL!\n");
            rr_error();
        }
        return;
    }
}

void onBleInitError(BLE& ble, ble_error_t error) {
    rr_error();
}

void disconnectionCallback(const Gap::DisconnectionCallbackParams_t* params) {
    serial.printf("\n\n\nDisconnected!\n\n\n");
    BLE::Instance().gap().startAdvertising();
}

uint32_t CONNECTED_AT = 0;
uint32_t DISCONNECT_AT = 999999;

void connectionCallback(const Gap::ConnectionCallbackParams_t *params) {
    CONNECTED_AT = cnt;
    DISCONNECT_AT = cnt + DISCONNECT_AFTER_SECONDS;
    serial.printf("\n\n\nConnected! will disconnect at: %u \n\n\n", (unsigned int)DISCONNECT_AT);
}

void bleInitComplete(BLE::InitializationCompleteCallbackContext *params) {
    BLE& ble = params->ble;
    ble_error_t error = params->error;
    if (error != BLE_ERROR_NONE) {
        onBleInitError(ble, error);
        return;
    }
    if(ble.getInstanceID() != BLE::DEFAULT_INSTANCE) {
        return;
    }
    ble.gap().onDisconnection(disconnectionCallback);
    ble.gap().onConnection(connectionCallback);
    ble.gattServer().onDataWritten(onDataWrittenCallback);

    batteryServicePtr = new CustomBatteryService(ble, LAST_BATTERY_PERCENT);
    pumpServicePtr = new WaterPumpService(ble, (uint8_t)0);
    uptimeServicePtr = new UptimeService(ble, (uint32_t)0);
    deviceInfo = new DeviceInformationService(ble, "(c)RR", "ble-waterpump", "SN0001", "hw-rev1", "fw-rev1", "soft-rev3");

    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::BREDR_NOT_SUPPORTED | GapAdvertisingData::LE_GENERAL_DISCOVERABLE);
    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LIST_16BIT_SERVICE_IDS, (uint8_t *)uuid16_list, sizeof(uuid16_list));
    ble.gap().accumulateAdvertisingPayload(GapAdvertisingData::COMPLETE_LOCAL_NAME, (uint8_t *)DEVICE_NAME, sizeof(DEVICE_NAME));
    ble.gap().setAdvertisingType(GapAdvertisingParams::ADV_CONNECTABLE_UNDIRECTED);
    ble.gap().setAdvertisingInterval(1000);
    ble.gap().startAdvertising();
}

int main() {
    wdt_init();
    wait_ms(1000);
    wdt_reset();
    led1 = 1;
    powerswitch1 = 0;
    cnt = 0;
    serial.printf("! Starting board, device name is '%s'\n", STRINGIZE_VALUE_OF(DEV_NAME));
    p2_adc_configure_internal_1_2V_ref();
    ticker.attach(periodicCallback, 1);
    BLE &ble = BLE::Instance();
    serial.printf("! BLE init...\n");
    ble.init(bleInitComplete);
    serial.printf("! BLE init complete!\n");
    while (ble.hasInitialized() == false) { } // spinlock
    uint32_t prev_cnt = 0;
    wdt_reset();
    while (true) {
        if(cnt > RESET_AFTER_SECONDS) {
            serial.printf("\n\n\n!!!!!cnt > %u, soft reset to keep things running...\n\n\n", RESET_AFTER_SECONDS);
            rr_reset();
            serial.printf("\n\n\n this msg should not appear!\n\n\n\n");
        }
	if(cnt >= DISCONNECT_AT) {
		serial.printf("Forcing client disconnection (disconnect_at=%u)\n\n\n", (unsigned int)DISCONNECT_AT);
		ble.disconnect(Gap::CONNECTION_TIMEOUT);
		DISCONNECT_AT = 999999;
	}
        if(cnt != prev_cnt) {
            prev_cnt = cnt;
            serial.printf("cnt=%u ", (unsigned)cnt);
            if(uptimeServicePtr) {
                uptimeServicePtr->updateUptimeState(cnt);
            }
            wdt_reset();
            if(PUMPING_ENABLED) {
                serial.printf("\n\n! pumping cnt=%u till=%u\n", (unsigned int)cnt, (unsigned int)PUMPING_STOP_AT_CNT);
                if(cnt >= PUMPING_STOP_AT_CNT) {
                    serial.printf("\n\n! STOPPING PUMP!\n\n");
                    powerswitch1 = 0;
                    PUMPING_ENABLED = false;
                    PUMPING_STOP_AT_CNT = 0;
                    if(pumpServicePtr) {
                        pumpServicePtr->updatePumpState(0);
                        serial.printf("!!    -> pumpServicePtr updated to value 0\n");
                    } else {
                        serial.printf("WARNING: pumpServicePtr is NULL!\n");
                        rr_error();
                    }
                }
                //if(pumpServicePtr) {
                //	pumpServicePtr->updatePumpState(PUMPING_STOP_AT_CNT - cnt);
                //	//serial.printf("!!    -> pumpServicePtr updated to value %i\n", (int)(PUMPING_STOP_AT_CNT - cnt));
                //} else {
                //	serial.printf("WARNING: pumpServicePtr is NULL!\n");
                //}
            }

            LAST_BATTERY_VOLTAGE = get_current_battery_voltage();
            LAST_BATTERY_PERCENT = map((int)(LAST_BATTERY_VOLTAGE * 1000), 1800, 3200, 0, 100);
            //serial.printf("# update svc data cnt=%u battery= (int)%i[mV] (est_battery_percent=%i)\n", (unsigned int)cnt, (int)LAST_BATTERY_VOLTAGE*1000, (int)LAST_BATTERY_PERCENT);
            if(batteryServicePtr) {
                batteryServicePtr->updateBatteryLevel(LAST_BATTERY_PERCENT);
                //serial.printf("BatteryService - level updated\n");
            } else {
                serial.printf("BatteryServicePtr is NULL!\n");
                rr_error();
            }

        }
        ble.waitForEvent();
    }
}

