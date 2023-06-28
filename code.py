# SPDX-FileCopyrightText: 2020 Dan Halbert for Adafruit Industries
#
# SPDX-License-Identifier: MIT

# Provide an "eval()" service over BLE UART.

from adafruit_ble import BLERadio
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement, Advertisement
from adafruit_ble.services.nordic import UARTService
from adafruit_ble_eddystone import uid, url
import time
import json
import array
import math
import board
import displayio
import terminalio
import audiobusio
import adafruit_apds9960.apds9960
import adafruit_bmp280
import adafruit_lis3mdl
import adafruit_lsm6ds.lsm6ds33
import adafruit_sht31d
from math import acos, degrees, atan2, sqrt, atan, pi, cos, sin
import digitalio
import busio

ble = BLERadio()
uart = UARTService()
advertisement = ProvideServicesAdvertisement(uart)

# Reuse the BLE address as our Eddystone instance id.
eddystone_uid = uid.EddystoneUID(ble.address_bytes)
eddystone_url = url.EddystoneURL("https://adafru.it/discord")

i2c = board.I2C()
lis3mdl = adafruit_lis3mdl.LIS3MDL(i2c) # Magnetometer
lsm6ds33 = adafruit_lsm6ds.lsm6ds33.LSM6DS33(i2c) # accelerometer

def get_tilt():
    x,y,z = lsm6ds33.acceleration
    #print("X:"+str(x)+" Y:"+str(y)+" Z:"+str(z))
    #print("Magnetic: {:.3f} {:.3f} {:.3f} uTesla".format(*lis3mdl.magnetic))
    pitch = round((atan2(y, z) * 180/pi),4)
    roll = round((atan2(x, sqrt(y*y +z*z))* 180/pi),4)
    #print("Raw Roll: " + str(roll) + " & Raw Pitch: "+str(pitch))
    #pitch = round(atan2(y, z) * 180/PI) - pitch_offset
    #roll = round(atan2(x, sqrt(y*y +z*z))* 180/PI) - roll_offset
    #print("Calibrated roll: "+ str(roll) + " pitch: " + str(pitch))
    return roll,pitch

def vector_2_degrees(x, y):
    angle = degrees(atan2(y, x))
    if angle < 0:
        angle += 360
    return angle

def get_heading(_sensor):
    magnet_x, magnet_y, _ = _sensor.magnetic
    return vector_2_degrees(magnet_x, magnet_y)


count = 0
tilt = {} # empty dictionary
tiltx = {}
tilty = {}

ad2 = Advertisement()
ad2.short_name = "HELLO"
ad2.connectable = True

while True:
    ble.start_advertising(advertisement)
    #ble.start_advertising(ad2)
    print("Waiting to connect")
    while not ble.connected:
        pass
    print("Connected")
    while ble.connected:
        roll, pitch = get_tilt()
        s = uart.readline()
        if s:
            try:
                result = str(eval(s))
            except Exception as e:
                result = repr(e)

        tilt['x'] = roll
        tiltx['x'] = roll
        tilt['y'] = pitch
        tilty['y'] = pitch
        json_string = json.dumps(tilt)
        #uart.write(json_string.encode("utf-8"))
        #print(json_string)

        #x_string = json.dumps(tiltx)
        #uart.write(x_string.encode("utf-8"))
        #print(x_string)
        #time.sleep(.5)

        #y_string = json.dumps(tilty)
        #uart.write(y_string.encode("utf-8"))
        #print(y_string)

        string = "{:.2f} {:.2f}".format(roll,pitch)
        #print(string)
        uart.write(string.encode("utf-8"))

        #print("\n")

        time.sleep(.01)
