#!/bin/sh
# FanControl for TrueNAS running in a QNAP TS-563
# Author: Sergio Bernal Ponce
#
# This script 

# Variables
MIN_TEMP=40
MAX_TEMP=60
MIN_PWM=70
MAX_PWM=200

# This is the path of the FAN hwmon device
FAN_PATH="/sys/class/hwmon/hwmon4/device"

# This is the path CPU temperature sensor (check ./name)
RAW_CPU_TEMP=$(cat /sys/class/hwmon/hwmon2/temp1_input)

# These are the temperature sensors of the two internal nvme devices
NVME0_TEMP=$(cat /sys/class/hwmon/hwmon0/temp1_input)
NVME1_TEMP=$(cat /sys/class/hwmon/hwmon1/temp1_input)

#We need to convert to float to be able to calculate things later on
CPU_TEMP=$(awk "BEGIN {print $RAW_CPU_TEMP/1000}")
NVME0_TEMP=$(awk "BEGIN {print $NVME0_TEMP/1000}")
NVME1_TEMP=$(awk "BEGIN {print $NVME1_TEMP/1000}")

echo " -- CPU temp  : $CPU_TEMP"
echo " -- NVME 1 temp: $NVME0_TEMP"
echo " -- NVME 2 temp: $NVME1_TEMP"

# We will use a linear/proportional mapping between temperature and PWM value
if awk "BEGIN {exit !($CPU_TEMP <= $MIN_TEMP)}"; then
    PWM=$MIN_PWM
elif awk "BEGIN {exit !($CPU_TEMP >= $MAX_TEMP)}"; then
    PWM=$MAX_PWM
else
    PWM=$(awk "BEGIN {print int(($CPU_TEMP - $MIN_TEMP) * ($MAX_PWM - $MIN_PWM) / ($MAX_TEMP - $MIN_TEMP) + $MIN_PWM)}")
fi

echo "FAN speed $PWM"
echo $PWM | sudo tee $FAN_PATH/pwm1
