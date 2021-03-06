#!/bin/sh
# POWER_SUPPLY_NAME=BAT0
# POWER_SUPPLY_STATUS=Charging
# POWER_SUPPLY_PRESENT=1
# POWER_SUPPLY_TECHNOLOGY=Li-ion
# POWER_SUPPLY_CYCLE_COUNT=209
# POWER_SUPPLY_VOLTAGE_MIN_DESIGN=11550000
# POWER_SUPPLY_VOLTAGE_NOW=11550000
# POWER_SUPPLY_POWER_NOW=19842000
# POWER_SUPPLY_ENERGY_FULL_DESIGN=57057000
# POWER_SUPPLY_ENERGY_FULL=40690000
# POWER_SUPPLY_ENERGY_NOW=16747000
# POWER_SUPPLY_CAPACITY=41
# POWER_SUPPLY_CAPACITY_LEVEL=Normal
# POWER_SUPPLY_MODEL_NAME=ASUS Battery
# POWER_SUPPLY_MANUFACTURER=ASUSTeK
# POWER_SUPPLY_SERIAL_NUMBER=

. /sys/class/power_supply/BAT0/uevent
echo "$POWER_SUPPLY_STATUS"
echo "$POWER_SUPPLY_MANUFACTURER"
