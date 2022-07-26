# Exar/MxL USB Serial Driver

## Introduction

Update of Exar/MxL USB Serial Driver to support linux kernel 5.15.

Please star this repository if it has util for you :).

## Versions

Version 1E_unofficial, 2022/7/26

* Fixed Bug: Support linux kernel 5.15 by adapting to the changes in `<linux/tty_driver.h>`.

Version 1D, 2021/9/14

* Add GPIO operation support
* Use dynamic allocate memory for usb_control_msg
* Avoid re-configuring the flow mode if no changes
* Remove obsoleted flag check for newer version
* Fix XR21B142x incorrect register mapping
* Fix baud rate setting for Big-Endian system
* XR2280x wide mode setting
* Clean up ident

Version 1C, 2017/1/11

* Add the 9-bit mode support.
* Disable the debug messages.

Version 1B, 11/6/2015

* Fixed Bug: The conditional logic to support kernel 3.9 was incorrect(line 396 in xr_usb_serial_common.c).

Version 1A, 1/9/2015

## Compatibility

This driver will work with any USB UART function in these Exar/MxL devices:

* XR21V1410/1412/1414
* XR21B1411
* XR21B1420/1422/1424
* XR22801/802/804

The original source code has been tested by its authors on various Linux kernels from 3.6.x to 5.11.x.
This version has been tested on version 5.15.0-41-generic where there original version failed because of changes in the `<linux/tty_driver.h>` header, resulting in the following errors:

```bash
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2019:33: error: initialization of ‘unsigned int (*)(struct tty_struct *)’ from incompatible pointer type ‘int (*)(struct tty_struct *)’ [-Werror=incompatible-pointer-types]
 2019 |         .write_room =           xr_usb_serial_tty_write_room,
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2019:33: note: (near initialization for ‘xr_usb_serial_ops.write_room’)
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2026:33: error: initialization of ‘unsigned int (*)(struct tty_struct*)’ from incompatible pointer type ‘int (*)(struct tty_struct*)’ [-Werror=incompatible-pointer-types]
 2026 |         .chars_in_buffer =      xr_usb_serial_tty_chars_in_buffer,
      |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2026:33: note: (near initialization for ‘xr_usb_serial_ops.chars_in_buffer’)
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c: In function ‘xr_usb_serial_init’:
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2040:36: error: implicit declaration of function ‘alloc_tty_driver’ [-Werror=implicit-function-declaration]
 2040 |         xr_usb_serial_tty_driver = alloc_tty_driver(XR_USB_SERIAL_TTY_MINORS);
      |                                    ^~~~~~~~~~~~~~~~
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2040:34: warning: assignment to ‘struct tty_driver *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
 2040 |         xr_usb_serial_tty_driver = alloc_tty_driver(XR_USB_SERIAL_TTY_MINORS);
      |                                  ^
xr_usb_serial_common_lnx-3.6-and-newer-pak/xr_usb_serial_common.c:2057:17: error: implicit declaration of function ‘put_tty_driver’ [-Werror=implicit-function-declaration]
 2057 |                 put_tty_driver(xr_usb_serial_tty_driver);
      |                 ^~~~~~~~~~~~~~
```

These problems where solved by replacing `put_tty_driver` for `tty_driver_kref_put` and `alloc_tty_driver` by `tty_alloc_driver` and adding `-Wno-incompatible-pointer-types` to the compilation flags (yes, it would be better to real solve the error than just ignore it).

## Installation

1. Compile and install the common usb serial driver module

    ```bash
    make
    sudo insmod ./xr_usb_serial_common.ko
    ```

2. Plug the device into the USB host. You should see up to four devices created, typically /dev/ttyXRUSB[0-3].

## Tips for Debugging

* Check that the USB UART is detected by the system

    ```bash
    lsusb
    ```

* Check that the CDC-ACM driver was not installed for the Exar USB UART

    ```bash
    ls /dev/tty*
    ```

    To remove the CDC-ACM driver and install the driver:

    ```bash
    rmmod cdc-acm
    modprobe -r usbserial
    modprobe usbserial
    insmod ./xr_usb_serial_common.ko
    ```

## Technical Support

Send any technical questions/issues to uarttechsupport@exar.com.
