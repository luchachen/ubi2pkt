
KVER  := $(shell uname -r)
KSRC ?= /lib/modules/$(KVER)/build
MODDESTDIR := /lib/modules/$(KVER)/kernel/drivers/mtd/devices

obj-m += block2mtd.o

all:
	make -C $(KSRC) M=$(PWD) modules

clean:
	make -C $(KSRC) M=$(PWD) clean

voodoo: all
	-sudo rmmod ./block2mtd.ko
	sudo insmod ./block2mtd.ko block2mtd=/dev/sr0,65536,2048

install:
	install -p -m 644 block2mtd.ko  $(MODDESTDIR)
	/sbin/depmod -a ${KVER}

uninstall:
	rm -f $(MODDESTDIR)/block2mtd.ko
	/sbin/depmod -a ${KVER}
