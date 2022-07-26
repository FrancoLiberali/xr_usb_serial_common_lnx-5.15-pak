obj-m := xr_usb_serial_common.o

KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD       := $(shell pwd)

# EXTRA_CFLAGS := -DDEBUG=0
# EXTRA_CFLAGS := -DDEBUG=0 -Wno-implicit-function-declaration -Wno-incompatible-pointer-types -Wno-int-conversion
EXTRA_CFLAGS := -DDEBUG=0 -Wno-incompatible-pointer-types

all:
	$(MAKE) -C $(KERNELDIR) M=$(PWD)

modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install

clean:
	rm -rf *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions vtty