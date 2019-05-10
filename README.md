## Introduction

Issue when doing with Quectel EC21/EC25, ... you can't connect to the device via ADB interface or the device is not shown ```$ adb devices```

Reasons: ADB port node was occupied by option driver

Solution: unbind the option driver for the ADB port. This method is tested in Ubuntu 18.04 LTS, 16.04 LTS.

## Feature

- Run ADB under userspace
- Understand EC2x USB interface and how to unbind the ADB port under option driver

Next step: write a script to identify the ADB port and unbind accordingly. 

## Prepare

For the convience, we need to run the ADB at user level and prepare ADB packages, this can be done using the provided script.

```
$ sh setup.sh
```

## Unbind the option driver

Plug the EC2x modules to Ubuntu machine via USB and run those commands as root:

```bash
# dmesg

[   11.688113] usb 1-2: new high-speed USB device number 4 using ehci-pci
[   11.845420] usb 1-2: New USB device found, idVendor=2c7c, idProduct=0125, bcdDevice= 3.18
[   11.845422] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.845423] usb 1-2: Product: Android
[   11.845424] usb 1-2: Manufacturer: Android
[   11.863802] option 1-2:1.0: GSM modem (1-port) converter detected
[   11.864130] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB0
[   11.864297] option 1-2:1.1: GSM modem (1-port) converter detected
[   11.864958] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB1
[   11.865006] option 1-2:1.2: GSM modem (1-port) converter detected
[   11.865178] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB2
[   11.865221] option 1-2:1.3: GSM modem (1-port) converter detected
[   11.865385] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB3
[   11.869118] qmi_wwan 1-2:1.4: cdc-wdm0: USB WDM device
[   11.869588] qmi_wwan 1-2:1.4 wwan0: register 'qmi_wwan' at usb-0000:00:1d.7-2, WWAN/QMI device, d6:0a:73:76:e8:7e
[   11.869894] option 1-2:1.5: GSM modem (1-port) converter detected
[   11.869990] usb 1-2: GSM modem (1-port) converter now attached to ttyUSB4
[   11.908316] qmi_wwan 1-2:1.4 wwp0s29f7u2i4: renamed from wwan0
```

```bash
# cat /sys/kernel/debug/usb/devices

T:  Bus=01 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  2 Spd=480  MxCh= 0
D:  Ver= 2.00 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2c7c ProdID=0125 Rev= 3.18
S:  Manufacturer=Android
S:  Product=Android
C:* #Ifs= 6 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=option
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=83(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=85(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=03(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 3 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
E:  Ad=87(I) Atr=03(Int.) MxPS=  10 Ivl=32ms
E:  Ad=86(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 4 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
E:  Ad=89(I) Atr=03(Int.) MxPS=   8 Ivl=32ms
E:  Ad=88(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 5 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=42 Prot=01 Driver=option
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=8a(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

```
Check the option driver:

```
# ls -la /sys/bus/usb/drivers/option/
total 0
drwxr-xr-x  2 root root    0 May 10 10:49 .
drwxr-xr-x 11 root root    0 May 10 10:46 ..
lrwxrwxrwx  1 root root    0 May 10 10:49 1-2:1.0 -> ../../../../devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.0
lrwxrwxrwx  1 root root    0 May 10 10:49 1-2:1.1 -> ../../../../devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1
lrwxrwxrwx  1 root root    0 May 10 10:49 1-2:1.2 -> ../../../../devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.2
lrwxrwxrwx  1 root root    0 May 10 10:49 1-2:1.3 -> ../../../../devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.3
lrwxrwxrwx  1 root root    0 May 10 10:49 1-2:1.5 -> ../../../../devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.5
--w-------  1 root root 4096 May 10 10:49 bind
lrwxrwxrwx  1 root root    0 May 10 10:49 module -> ../../../../module/usbserial
--w-------  1 root root 4096 May 10 10:46 uevent
--w-------  1 root root 4096 May 10 10:49 unbind
```

For EC2x USB interface, the ports are defined as:
- Port 0: ttyUSB0 --> DM Port
- Port 1: ttyUSB1 --> GNSS port
- Port 2: ttyUSB2 --> AT commands
- Port 3: ttyUSB3 --> PPP and AT commands
- Port 4: QMI interface
- Port 5: ADB --> in this, it is loaded under option driver

ADB Port is "1-2:1.5", thus you need to unbind the ADB port:

```
# echo "1-2:1.5" > /sys/bus/usb/drivers/option/unbind
```

Back to normal user, you can see the devices, result:

```
$ adb devices
List of devices attached
(no serial number)	device
```

## Alternative solution

Other option is to build the serial driver to ignore the Quectel modules, pls follow this repo: https://github.com/ngohaibac/Quectel_USB_Serial_Driver

## Credit

https://zhiwei.li/text/2017/02/11/ec20ec21ec25开启adb/ 