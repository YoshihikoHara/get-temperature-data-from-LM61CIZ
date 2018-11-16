# Author       : Yoshihiko Hara <goronyanko.h@gmail.com>
# last updated : 2018/11/16
# Overview     : Get temperature data from "LM61CIZ" connected to "GR-CITRUS" with mruby.
# License      : MIT License

def mapping_data(conversion_targetfloat,in_min,in_max,out_min,out_max)

  # Convert "conversion_targetfloat" from "in_min" to "in_max" range to "out_min” to ”out_max" range.
  return (conversion_targetfloat - in_min) * (out_max - out_min) / (in_max - in_min) + out_min

end

# Minimum value and maximum value of data that each device can return
PIN_NUMBER_OF_A0               =   14
DELAY_TIME                     = 1000
MIN_INPUT_VALUE_OF_ANALOGPIN   =    0
MAX_INPUT_VALUE_OF_ANALOGPIN   = 1023
MIN_VOLTAGE_VALUE_OF_ANALOGPIN =    0
MAX_VOLTAGE_VALUE_OF_ANALOGPIN = 5000
MIN_VOLTAGE_VALUE_OF_SENSOR    =  300.0
MAX_VOLTAGE_VALUE_OF_SENSOR    = 1600.0
MIN_TEMP_VALUE_OF_SENSOR       =  -30.0
MAX_TEMP_VALUE_OF_SENSOR       =  100.0

# Prepare for serial communication with PC via USB.
usb_serial = Serial.new(0)

# Repeat the following operations.
#  1. Read data from sensor.
#  2. Convert the read data to air temperature.
#  3. Transfer temperature data to PC.
#  4. Stop operation for 1000 ms (1 s).
while true

  # Read data from sensor (A 0 → 14 pin)
  sensor_data = analogRead(PIN_NUMBER_OF_A0)

  # Convert the read data to a voltage value.
  voltage_data = mapping_data(sensor_data,MIN_INPUT_VALUE_OF_ANALOGPIN,MAX_INPUT_VALUE_OF_ANALOGPIN,MIN_VOLTAGE_VALUE_OF_ANALOGPIN,MAX_VOLTAGE_VALUE_OF_ANALOGPIN)

  # Convert voltage value to temperature
  temperature_data = mapping_data(voltage_data.to_f,MIN_VOLTAGE_VALUE_OF_SENSOR,MAX_VOLTAGE_VALUE_OF_SENSOR,MIN_TEMP_VALUE_OF_SENSOR,MAX_TEMP_VALUE_OF_SENSOR)

  # Transfer temperature data to PC.
  usb_serial.println(temperature_data.to_s)

  # Stop operation for 1000 ms (1 s).
  delay(DELAY_TIME)

end
