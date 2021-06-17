# This file was automagically generated by mbed.org. For more information, 
# see http://mbed.org/handbook/Exporting-to-GCC-ARM-Embedded

###############################################################################
# Boiler-plate

# cross-platform directory manipulation
ifeq ($(shell echo $$OS),$$OS)
    MAKEDIR = if not exist "$(1)" mkdir "$(1)"
    RM = rmdir /S /Q "$(1)"
else
    MAKEDIR = '$(SHELL)' -c "mkdir -p \"$(1)\""
    RM = '$(SHELL)' -c "rm -rf \"$(1)\""
endif

OBJDIR := BUILD
# Move to the build directory
ifeq (,$(filter $(OBJDIR),$(notdir $(CURDIR))))
.SUFFIXES:
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
MAKETARGET = '$(MAKE)' --no-print-directory -C $(OBJDIR) -f '$(mkfile_path)' \
		'SRCDIR=$(CURDIR)' $(MAKECMDGOALS)
.PHONY: $(OBJDIR) clean
all:
	+@$(call MAKEDIR,$(OBJDIR))
	+@$(MAKETARGET)
$(OBJDIR): all
Makefile : ;
% :: $(OBJDIR) ; :
clean :
	$(call RM,$(OBJDIR))

else

# trick rules into thinking we are in the root, when we are in the bulid dir
VPATH = ..

# Boiler-plate
###############################################################################
# Project settings

PROJECT := nrf51_BLE_Button

# Project settings
###############################################################################
# Objects and Paths

OBJECTS += BLE_API/source/BLE.o
OBJECTS += BLE_API/source/BLEInstanceBase.o
OBJECTS += BLE_API/source/DiscoveredCharacteristic.o
OBJECTS += BLE_API/source/GapScanningParams.o
OBJECTS += BLE_API/source/services/DFUService.o
OBJECTS += BLE_API/source/services/UARTService.o
OBJECTS += BLE_API/source/services/URIBeaconConfigService.o
OBJECTS += main.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_radio_notification/ble_radio_notification.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_services/ble_dfu/ble_dfu.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common/ble_advdata.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common/ble_conn_params.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common/ble_conn_state.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common/ble_srv_common.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/device_manager/device_manager_peripheral.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/id_manager.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/peer_data.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/peer_data_storage.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/peer_database.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/peer_id.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/pm_buffer.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager/pm_mutex.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/ble_flash/ble_flash.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/delay/nrf_delay.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/hal/nrf_ecb.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/hal/nrf_nvmc.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/pstorage/pstorage.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu/bootloader_util.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu/dfu_app_handler.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu/dfu_init_template.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/crc16/crc16.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fds/fds.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fstorage/fstorage.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fstorage/fstorage_nosd.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/hci/hci_mem_pool.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/scheduler/app_scheduler.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util/app_error.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util/app_util_platform.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util/nrf_assert.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util/sdk_mapped_flags.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common/softdevice_handler/softdevice_handler.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common/softdevice_handler/softdevice_handler_appsh.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/btle.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/btle_advertising.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/btle_discovery.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/btle_gap.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/btle_security.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/btle/custom/custom_helper.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xCharacteristicDescriptorDiscoverer.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xDiscoveredCharacteristic.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xGap.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xGattClient.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xGattServer.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xServiceDiscovery.o
OBJECTS += nRF51822/TARGET_MCU_NRF51822/source/nRF5xn.o

 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/analogin_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/cmsis_nvic.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/except.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/gpio_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/gpio_irq_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/i2c_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/mbed_board.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/mbed_fault_handler.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/mbed_retarget.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/mbed_sdk_boot.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/mbed_tz_context.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/pinmap.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/port_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/pwmout_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/serial_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/sleep.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/spi_api.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/startup_NRF51822.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/system_nrf51.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/twi_master.o
 SYS_OBJECTS += mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/us_ticker.o

INCLUDE_PATHS += -I../
INCLUDE_PATHS += -I../.
INCLUDE_PATHS += -I..//usr/src/mbed-sdk
INCLUDE_PATHS += -I../BLE_API
INCLUDE_PATHS += -I../BLE_API/ble
INCLUDE_PATHS += -I../BLE_API/ble/services
INCLUDE_PATHS += -I../mbed
INCLUDE_PATHS += -I../mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM
INCLUDE_PATHS += -I../mbed/drivers
INCLUDE_PATHS += -I../mbed/hal
INCLUDE_PATHS += -I../mbed/platform
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_radio_notification
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_services
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_services/ble_dfu
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/device_manager
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/device_manager/config
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/device
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/ble_flash
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/delay
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/hal
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/pstorage
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/pstorage/config
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu/hci_transport
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/crc16
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/experimental_section_vars
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fds
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fstorage
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/hci
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/scheduler
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/timer
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common/softdevice_handler
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/s130
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/s130/headers
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/toolchain
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/source
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/source/btle
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/source/btle/custom
INCLUDE_PATHS += -I../nRF51822/TARGET_MCU_NRF51822/source/common

LIBRARY_PATHS := -L../mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM 
LIBRARIES := -lmbed 
LINKER_SCRIPT ?= ../mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/NRF51822.ld

# Objects and Paths
###############################################################################
# Tools and Flags

AS      = arm-none-eabi-gcc
CC      = arm-none-eabi-gcc
CPP     = arm-none-eabi-g++
LD      = arm-none-eabi-gcc
ELF2BIN = arm-none-eabi-objcopy
PREPROC = arm-none-eabi-cpp -E -P -Wl,--gc-sections -Wl,--wrap,main -Wl,--wrap,_malloc_r -Wl,--wrap,_free_r -Wl,--wrap,_realloc_r -Wl,--wrap,_memalign_r -Wl,--wrap,_calloc_r -Wl,--wrap,exit -Wl,--wrap,atexit -Wl,-n --specs=nano.specs -mcpu=cortex-m0 -mthumb -DMBED_BOOT_STACK_SIZE=4096

SREC_CAT = srec_cat

C_FLAGS += -DRR_HACK_INTERNAL_1_2V_REFERENCE
C_FLAGS += -std=gnu11
C_FLAGS += -include
C_FLAGS += mbed_config.h
C_FLAGS += -D__CORTEX_M0
C_FLAGS += -DNRF5x
C_FLAGS += -DTARGET_MCU_NRF51_16K_BASE
C_FLAGS += -DNRF51
C_FLAGS += -DTARGET_MCU_NRF51_16K_S130
C_FLAGS += -DTARGET_LIKE_MBED
C_FLAGS += -DTARGET_NRF51822
C_FLAGS += -DDEVICE_PORTINOUT=1
C_FLAGS += -D__MBED_CMSIS_RTOS_CM
C_FLAGS += -DCOMPONENT_PSA_SRV_EMUL=1
C_FLAGS += -D__CMSIS_RTOS
C_FLAGS += -DMBED_BUILD_TIMESTAMP=1576879223.41
C_FLAGS += -DTARGET_MCU_NRF51_16K
C_FLAGS += -DTOOLCHAIN_GCC
C_FLAGS += -DTARGET_CORTEX_M
C_FLAGS += -DARM_MATH_CM0
C_FLAGS += -DFEATURE_BLE=1
C_FLAGS += -DTARGET_M0
C_FLAGS += -DCOMPONENT_PSA_SRV_IMPL=1
C_FLAGS += -DTARGET_MCU_NRF51
C_FLAGS += -DCMSIS_VECTAB_VIRTUAL
C_FLAGS += -DDEVICE_SERIAL=1
C_FLAGS += -D__MBED__=1
C_FLAGS += -DTARGET_CORTEX
C_FLAGS += -DDEVICE_I2C=1
C_FLAGS += -DDEVICE_PORTOUT=1
C_FLAGS += -DTARGET_NRF51822_MKIT
C_FLAGS += -DTARGET_RELEASE
C_FLAGS += -DCOMPONENT_NSPE=1
C_FLAGS += -DTARGET_NORDIC
C_FLAGS += -DTARGET_NAME=NRF51822
C_FLAGS += -DTARGET_MCU_NORDIC_16K
C_FLAGS += -DDEVICE_PORTIN=1
C_FLAGS += -DDEVICE_SLEEP=1
C_FLAGS += -DTOOLCHAIN_GCC_ARM
C_FLAGS += -DTARGET_MCU_NRF51822
C_FLAGS += -DDEVICE_SPI=1
C_FLAGS += -DCMSIS_VECTAB_VIRTUAL_HEADER_FILE=\"cmsis_nvic.h\"
C_FLAGS += -DDEVICE_INTERRUPTIN=1
C_FLAGS += -DDEVICE_SPISLAVE=1
C_FLAGS += -DDEVICE_ANALOGIN=1
C_FLAGS += -DDEVICE_PWMOUT=1
C_FLAGS += -DTARGET_LIKE_CORTEX_M0
C_FLAGS += -include
C_FLAGS += mbed_config.h
C_FLAGS += -std=gnu11
C_FLAGS += -c
C_FLAGS += -Wall
C_FLAGS += -Wextra
C_FLAGS += -Wno-unused-parameter
C_FLAGS += -Wno-missing-field-initializers
C_FLAGS += -fmessage-length=0
C_FLAGS += -fno-exceptions
C_FLAGS += -ffunction-sections
C_FLAGS += -fdata-sections
C_FLAGS += -funsigned-char
C_FLAGS += -MMD
C_FLAGS += -fno-delete-null-pointer-checks
C_FLAGS += -fomit-frame-pointer
C_FLAGS += -Os
C_FLAGS += -g
C_FLAGS += -DMBED_TRAP_ERRORS_ENABLED=1
C_FLAGS += -DMBED_RTOS_SINGLE_THREAD
C_FLAGS += -mcpu=cortex-m0
C_FLAGS += -mthumb
C_FLAGS += $(EXTRA_CFLAGS)

CXX_FLAGS += -DRR_HACK_INTERNAL_1_2V_REFERENCE
CXX_FLAGS += -std=gnu++14
CXX_FLAGS += -fno-rtti
CXX_FLAGS += -Wvla
CXX_FLAGS += -include
CXX_FLAGS += mbed_config.h
CXX_FLAGS += -D__CORTEX_M0
CXX_FLAGS += -DNRF5x
CXX_FLAGS += -DTARGET_MCU_NRF51_16K_BASE
CXX_FLAGS += -DNRF51
CXX_FLAGS += -DTARGET_MCU_NRF51_16K_S130
CXX_FLAGS += -DTARGET_LIKE_MBED
CXX_FLAGS += -DTARGET_NRF51822
CXX_FLAGS += -DDEVICE_PORTINOUT=1
CXX_FLAGS += -D__MBED_CMSIS_RTOS_CM
CXX_FLAGS += -DCOMPONENT_PSA_SRV_EMUL=1
CXX_FLAGS += -D__CMSIS_RTOS
CXX_FLAGS += -DMBED_BUILD_TIMESTAMP=1576879223.41
CXX_FLAGS += -DTARGET_MCU_NRF51_16K
CXX_FLAGS += -DTOOLCHAIN_GCC
CXX_FLAGS += -DTARGET_CORTEX_M
CXX_FLAGS += -DARM_MATH_CM0
CXX_FLAGS += -DFEATURE_BLE=1
CXX_FLAGS += -DTARGET_M0
CXX_FLAGS += -DCOMPONENT_PSA_SRV_IMPL=1
CXX_FLAGS += -DTARGET_MCU_NRF51
CXX_FLAGS += -DCMSIS_VECTAB_VIRTUAL
CXX_FLAGS += -DDEVICE_SERIAL=1
CXX_FLAGS += -D__MBED__=1
CXX_FLAGS += -DTARGET_CORTEX
CXX_FLAGS += -DDEVICE_I2C=1
CXX_FLAGS += -DDEVICE_PORTOUT=1
CXX_FLAGS += -DTARGET_NRF51822_MKIT
CXX_FLAGS += -DTARGET_RELEASE
CXX_FLAGS += -DCOMPONENT_NSPE=1
CXX_FLAGS += -DTARGET_NORDIC
CXX_FLAGS += -DTARGET_NAME=NRF51822
CXX_FLAGS += -DTARGET_MCU_NORDIC_16K
CXX_FLAGS += -DDEVICE_PORTIN=1
CXX_FLAGS += -DDEVICE_SLEEP=1
CXX_FLAGS += -DTOOLCHAIN_GCC_ARM
CXX_FLAGS += -DTARGET_MCU_NRF51822
CXX_FLAGS += -DDEVICE_SPI=1
CXX_FLAGS += -DCMSIS_VECTAB_VIRTUAL_HEADER_FILE=\"cmsis_nvic.h\"
CXX_FLAGS += -DDEVICE_INTERRUPTIN=1
CXX_FLAGS += -DDEVICE_SPISLAVE=1
CXX_FLAGS += -DDEVICE_ANALOGIN=1
CXX_FLAGS += -DDEVICE_PWMOUT=1
CXX_FLAGS += -DTARGET_LIKE_CORTEX_M0
CXX_FLAGS += -include
CXX_FLAGS += mbed_config.h
CXX_FLAGS += -std=gnu++14
CXX_FLAGS += -fno-rtti
CXX_FLAGS += -Wvla
CXX_FLAGS += -c
CXX_FLAGS += -Wall
CXX_FLAGS += -Wextra
CXX_FLAGS += -Wno-unused-parameter
CXX_FLAGS += -Wno-missing-field-initializers
CXX_FLAGS += -fmessage-length=0
CXX_FLAGS += -fno-exceptions
CXX_FLAGS += -ffunction-sections
CXX_FLAGS += -fdata-sections
CXX_FLAGS += -funsigned-char
CXX_FLAGS += -MMD
CXX_FLAGS += -fno-delete-null-pointer-checks
CXX_FLAGS += -fomit-frame-pointer
CXX_FLAGS += -Os
CXX_FLAGS += -g
CXX_FLAGS += -DMBED_TRAP_ERRORS_ENABLED=1
CXX_FLAGS += -DMBED_RTOS_SINGLE_THREAD
CXX_FLAGS += -mcpu=cortex-m0
CXX_FLAGS += -mthumb
CXX_FLAGS += $(EXTRA_CFLAGS)

ASM_FLAGS += -x
ASM_FLAGS += assembler-with-cpp
ASM_FLAGS += -D__CORTEX_M0
ASM_FLAGS += -DNRF5x
ASM_FLAGS += -DTARGET_MCU_NRF51_16K
ASM_FLAGS += -DTARGET_NRF51822_MKIT
ASM_FLAGS += -DNRF51
ASM_FLAGS += -DTARGET_MCU_NRF51_16K_S130
ASM_FLAGS += -DTARGET_NRF51822
ASM_FLAGS += -DARM_MATH_CM0
ASM_FLAGS += -D__MBED_CMSIS_RTOS_CM
ASM_FLAGS += -DCMSIS_VECTAB_VIRTUAL_HEADER_FILE="cmsis_nvic.h"
ASM_FLAGS += -DCMSIS_VECTAB_VIRTUAL
ASM_FLAGS += -D__CMSIS_RTOS
ASM_FLAGS += -DTARGET_MCU_NORDIC_16K
ASM_FLAGS += -I/usr/src/mbed-sdk
ASM_FLAGS += -I../BLE_API
ASM_FLAGS += -I../BLE_API/ble
ASM_FLAGS += -I../BLE_API/ble/services
ASM_FLAGS += -I../mbed
ASM_FLAGS += -I../mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM
ASM_FLAGS += -I../mbed/drivers
ASM_FLAGS += -I../mbed/hal
ASM_FLAGS += -I../mbed/platform
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_radio_notification
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_services
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/ble_services/ble_dfu
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/common
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/device_manager
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/device_manager/config
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/ble/peer_manager
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/device
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/ble_flash
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/delay
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/hal
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/pstorage
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/drivers_nrf/pstorage/config
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/bootloader_dfu/hci_transport
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/crc16
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/experimental_section_vars
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fds
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/fstorage
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/hci
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/scheduler
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/timer
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/libraries/util
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/common/softdevice_handler
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/s130
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/softdevice/s130/headers
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/sdk/source/toolchain
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/source
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/source/btle
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/source/btle/custom
ASM_FLAGS += -I../nRF51822/TARGET_MCU_NRF51822/source/common
ASM_FLAGS += -include
ASM_FLAGS += /filer/workspace_data/exports/2/217ff7e455ac347ee7b6b23fd12dee5e/nrf51_BLE_Button/mbed_config.h
ASM_FLAGS += -x
ASM_FLAGS += assembler-with-cpp
ASM_FLAGS += -c
ASM_FLAGS += -Wall
ASM_FLAGS += -Wextra
ASM_FLAGS += -Wno-unused-parameter
ASM_FLAGS += -Wno-missing-field-initializers
ASM_FLAGS += -fmessage-length=0
ASM_FLAGS += -fno-exceptions
ASM_FLAGS += -ffunction-sections
ASM_FLAGS += -fdata-sections
ASM_FLAGS += -funsigned-char
ASM_FLAGS += -MMD
ASM_FLAGS += -fno-delete-null-pointer-checks
ASM_FLAGS += -fomit-frame-pointer
ASM_FLAGS += -Os
ASM_FLAGS += -g
ASM_FLAGS += -DMBED_TRAP_ERRORS_ENABLED=1
ASM_FLAGS += -DMBED_RTOS_SINGLE_THREAD
ASM_FLAGS += -mcpu=cortex-m0
ASM_FLAGS += -mthumb


LD_FLAGS :=-Wl,--gc-sections -Wl,--wrap,main -Wl,--wrap,_malloc_r -Wl,--wrap,_free_r -Wl,--wrap,_realloc_r -Wl,--wrap,_memalign_r -Wl,--wrap,_calloc_r -Wl,--wrap,exit -Wl,--wrap,atexit -Wl,-n --specs=nano.specs -mcpu=cortex-m0 -mthumb -DMBED_BOOT_STACK_SIZE=4096 
LD_SYS_LIBS :=-Wl,--start-group -lstdc++ -lsupc++ -lm -lc -lgcc -lnosys -lmbed -Wl,--end-group

# Tools and Flags
###############################################################################
# Rules

.PHONY: all lst size

all: $(PROJECT).bin $(PROJECT)-combined.hex size


.s.o:
	+@$(call MAKEDIR,$(dir $@))
	+@echo "Assemble: $(notdir $<)"
  
	@$(AS) -c $(ASM_FLAGS) -o $@ $<
  


.S.o:
	+@$(call MAKEDIR,$(dir $@))
	+@echo "Assemble: $(notdir $<)"
  
	@$(AS) -c $(ASM_FLAGS) -o $@ $<
  

.c.o:
	+@$(call MAKEDIR,$(dir $@))
	+@echo "Compile: $(notdir $<)"
	@$(CC) $(C_FLAGS) $(INCLUDE_PATHS) -o $@ $<

.cpp.o:
	+@$(call MAKEDIR,$(dir $@))
	+@echo "Compile: $(notdir $<)"
	@$(CPP) $(CXX_FLAGS) $(INCLUDE_PATHS) -o $@ $<


$(PROJECT).link_script.ld: $(LINKER_SCRIPT)
	@$(PREPROC) $< -o $@



$(PROJECT).elf: $(OBJECTS) $(SYS_OBJECTS) $(PROJECT).link_script.ld 
	+@echo "$(filter %.o, $^)" > .link_options.txt
	+@echo "link: $(notdir $@)"
	@$(LD) $(LD_FLAGS) -T $(filter-out %.o, $^) $(LIBRARY_PATHS) --output $@ @.link_options.txt $(LIBRARIES) $(LD_SYS_LIBS)


$(PROJECT).bin: $(PROJECT).elf
	$(ELF2BIN) -O binary $< $@


$(PROJECT).hex: $(PROJECT).elf
	$(ELF2BIN) -O ihex $< $@


$(PROJECT)-combined.hex: $(PROJECT).hex
	+@echo "NOTE: the $(SREC_CAT) binary is required to be present in your PATH. Please see http://srecord.sourceforge.net/ for more information."
	$(SREC_CAT) ../mbed/TARGET_NRF51822/TOOLCHAIN_GCC_ARM/s130_nrf51_1.0.0_softdevice.hex -intel $(PROJECT).hex -intel -o $(PROJECT)-combined.hex -intel --line-length=44
	+@echo "===== hex file ready to flash: $(OBJDIR)/$@ ====="

# Rules
###############################################################################
# Dependencies

DEPS = $(OBJECTS:.o=.d) $(SYS_OBJECTS:.o=.d)
-include $(DEPS)
endif

# Dependencies
###############################################################################
# Catch-all

%: ;

# Catch-all
###############################################################################